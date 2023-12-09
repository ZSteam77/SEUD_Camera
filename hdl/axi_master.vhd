-------------------------------------------------------------------------------
-- File name:   axi_master.vhd
--
-- Description: This file implements an only-write AXI4 Master controller with
--              that executes only incremental burst transactions. 
--
--  IMPORTANT: Take care to ensure the initial slave address and burst sizes do
--             not cause any 4kB boundaries to be crossed in the address space.
--             This design does not implement any logic to handle this 
--             situation. This has been done in order to simplify target
--             address generation.
--              
--
-- Author:      Tomas H.
-- Versions:    v0.1    06/12/2021  Initial implementation
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_master is
    generic (
        -- Base addresses of targeted slave
        IMAGE_SIZE_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000000";
        -- This one is equal to:
        --  IMAGE_SIZE_SLAVE_BASE_ADDR + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8))
		IMAGE_DATA_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000100";
		-- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		AXI_BURST_LEN	: integer	:= 64;
        --
        BEAT_COUNTER_WIDTH : integer := 6; --log2(AXI_BURST_LEN)
		-- Width of Address Bus
		AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of Data Bus
		AXI_DATA_WIDTH	: integer	:= 32
    );
    port (
    -- AXI bus signals
        -- Common signals
        -- Global Clock Signal.
		m_axi_aclk	    : in std_logic;
		-- Global Reset Singal. This Signal is Active Low
		m_axi_aresetn	: in std_logic;

        -- Write Address Channel signals
		-- Master Interface Write Address ID
		m_axi_awid	    : out std_logic;
		-- Master Interface Write Address
		m_axi_awaddr	: out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		-- Burst length. The burst length gives the exact number of transfers in a burst
		m_axi_awlen	    : out std_logic_vector(7 downto 0);
		-- Burst size. This signal indicates the size of each transfer in the burst
		m_axi_awsize	: out std_logic_vector(2 downto 0);
		-- Burst type. The burst type and the size information, determine how the address
        --  for each transfer within the burst is calculated.
		m_axi_awburst	: out std_logic_vector(1 downto 0);
		-- Lock type. Provides additional information about the atomic characteristics of
        --  the transfer.
		m_axi_awlock	: out std_logic;
		-- Memory type. This signal indicates how transactions are required to progress 
        --  through a system.
		m_axi_awcache	: out std_logic_vector(3 downto 0);
		-- Protection type. This signal indicates the privilege and security level of the
        --  transaction, and whether the transaction is a data access or an instruction
        --  access.
		m_axi_awprot	: out std_logic_vector(2 downto 0);
		-- Quality of Service, QoS identifier sent for each write transaction.
		m_axi_awqos	    : out std_logic_vector(3 downto 0);
		-- Write address valid. This signal indicates that the channel is signaling valid
        --  write address and control information.
		m_axi_awvalid	: out std_logic;
		-- Write address ready. This signal indicates that the slave is ready to accept 
        --  an address and associated control signals
		m_axi_awready	: in std_logic;

        -- Write Data Channel signals
		-- Master Interface Write Data.
		m_axi_wdata	    : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold valid data. There
        --  is one write strobe bit for each eight bits of the write data bus.
		m_axi_wstrb	    : out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
		-- Write last. This signal indicates the last transfer in a write burst.
		m_axi_wlast	    : out std_logic;
		-- Write valid. This signal indicates that valid write data and strobes are 
        --  available
		m_axi_wvalid	: out std_logic;
		-- Write ready. This signal indicates that the slave can accept the write data.
		m_axi_wready	: in std_logic;

        -- Write Response signals
		-- Master Interface Write Response.
		m_axi_bid	    : in std_logic;
		-- Write response. This signal indicates the status of the write transaction.
		m_axi_bresp	    : in std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel is signaling a 
        --  valid write response.
		m_axi_bvalid	: in std_logic;
		-- Response ready. This signal indicates that the master can accept a write
        --  response.
		m_axi_bready	: out std_logic;
        -- AXI bus signals

    -- Custom interface signals
        start_axi   : in std_logic;
        stop_axi    : in std_logic;
        start_burst : in std_logic;
        data_in     : in std_logic_vector (AXI_DATA_WIDTH-1 downto 0);
        data_ack    : out std_logic := '0';
        image_size  : in std_logic_vector(31 downto 0);
        end_of_image : out std_logic := '0'
        -- Custom interface signals
    );
end axi_master;

architecture behavioural of axi_master is

    type axi_fsm_states is (    AXI_STANDBY,    -- Initial state, waits for 'start_axi'.
                                                --  Configures starting address for AXI
                                AXI_WAIT,       -- Waits for 'start_burst' or 'stop_axi'

                                AXI_SEND_DATA,  -- Initiates a new AXI burst transaction
                                                --  to send de image data from 'data_in'
                                AXI_BURST_DATA, -- Waits for the ongoing burst to finish

                                AXI_SEND_SIZE,  -- Initiates a new AXI busrt transaction
                                                --  to send 'image_size' only
                                AXI_BURST_SIZE, --Waits for the ongoing burst to finish

                                AXI_EOI);       -- Sets 'end_of_image' to indicate there
                                                --  is a valid image in the SDRAM

    signal axi_pres_state       : axi_fsm_states;
    signal start_single_burst   : std_logic;
    signal send_image_size      : std_logic;
    signal next_awaddr          : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    signal next_wdata           : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    signal beat_counter         : std_logic_vector(BEAT_COUNTER_WIDTH-1 downto 0);
    
    -- Internal AXI output signals 
    --signal axi_awid     : std_logic;
    signal axi_awaddr   : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
    --signal axi_awlen    : std_logic_vector(7 downto 0);
    --signal axi_awsize   : std_logic_vector(2 downto 0);
    --signal axi_awburst  : std_logic_vector(1 downto 0);
    --signal axi_awlock   : std_logic;
    --signal axi_awcache  : std_logic_vector(3 downto 0);
    --signal axi_awprot   : std_logic_vector(2 downto 0);
    --signal axi_awqos    : std_logic_vector(3 downto 0);
    signal axi_awvalid  : std_logic := '0';
    signal axi_wdata    : std_logic_vector(AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    --signal axi_wstrb    : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
    signal axi_wlast    : std_logic := '0';
    signal axi_wvalid   : std_logic := '0';
    signal axi_bready   : std_logic := '0';

begin
    -- Connect internal signals and assign constant values to certain AXI signals
    m_axi_awid      <= '0';     -- We don't really care about it
    m_axi_awaddr    <= axi_awaddr;
    m_axi_awlen     <= std_logic_vector(to_unsigned(AXI_BURST_LEN-1, 8));
    m_axi_awsize    <= "010";   -- 4 Bytes in each beat 
    m_axi_awburst   <= "01";    -- Incrementing burst type support only
    m_axi_awlock    <= '0';     -- Normal access transaction
    m_axi_awcache   <= "0000";  -- Non-bufferable, non-modifiable
    m_axi_awprot    <= "000";   -- Default value, don't care about it
    m_axi_awqos     <= "0000";  -- Default value, don't care about it
    m_axi_awvalid   <= axi_awvalid;
    m_axi_wdata     <= axi_wdata;
    m_axi_wstrb     <= (others => '1');  -- Don't support sub-word size writes
    m_axi_wlast     <= axi_wlast;
    m_axi_wvalid    <= axi_wvalid;
    m_axi_bready    <= axi_bready;

    -- DMA control FSM
    axi_fsm_proc: process(m_axi_aclk)
    begin
        if rising_edge(m_axi_aclk) then
            if m_axi_aresetn = '0' then
                axi_pres_state <= AXI_STANDBY;
                end_of_image <= '0';
                start_single_burst <= '0';
                send_image_size <= '0';
            else
                case axi_pres_state is
                    when AXI_STANDBY =>
                        -- Signal assignments
                        start_single_burst <= '0';
                        send_image_size <= '0';
                        next_awaddr <= IMAGE_DATA_SLAVE_BASE_ADDR;
                        -- Next state logic
                        if start_axi = '1' then
                            axi_pres_state <= AXI_WAIT;
                        end if;
                    when AXI_WAIT =>
                        -- Signal assignments
                        end_of_image <= '0';
                        start_single_burst <= '0';
                        send_image_size <= '0';
                        -- Next state logic
                        if stop_axi = '1' then
                            axi_pres_state <= AXI_SEND_SIZE;
                        elsif start_burst = '1' then
                            axi_pres_state <= AXI_SEND_DATA;
                        end if;
                    when AXI_SEND_DATA =>
                        -- Signal assignments
                        start_single_burst <= '1';
                        send_image_size <= '0';
                        --next_awaddr <= std_logic_vector(unsigned(next_awaddr) + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8)));
                        -- Next state logic
                        axi_pres_state <= AXI_BURST_DATA;
                    when AXI_BURST_DATA =>
                        -- Signal assignments
                        start_single_burst <= '0';
                        send_image_size <= '0';
                        -- Next state logic
                        if axi_bready = '1' then
                            axi_pres_state <= AXI_WAIT;
                            next_awaddr <= std_logic_vector(unsigned(next_awaddr) + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8)));
                        end if;
                    when AXI_SEND_SIZE =>
                        -- Signal assignments
                        start_single_burst <= '1';
                        send_image_size <= '1';
                        next_awaddr <= IMAGE_SIZE_SLAVE_BASE_ADDR;
                        -- Next state logic
                        axi_pres_state <= AXI_BURST_SIZE;
                    when AXI_BURST_SIZE =>
                        start_single_burst <= '0';
                        send_image_size <= '1';
                        -- Next state logic
                        if axi_bready = '1' then
                            axi_pres_state <= AXI_EOI;
                        end if;
                    when AXI_EOI =>
                        -- Signal assignments
                        end_of_image <= '1';
                        -- Next state logic
                        axi_pres_state <= AXI_STANDBY;
                    when others =>
                        axi_pres_state <= AXI_STANDBY;
                end case;
            end if;
        end if;
    end process axi_fsm_proc;

    ----------------------
	--Write Address Channel
	----------------------
	-- The purpose of the write address channel is to request the address and 
	-- command information for the entire transaction.  It is a single beat
	-- of information.
    
    w_addr_proc: process(m_axi_aclk)
    begin
        if rising_edge(m_axi_aclk) then
            if m_axi_aresetn = '0' or start_axi = '1' then   -- Check start_axi use here
                axi_awvalid <= '0';
                axi_awaddr <= (others => '0'); -- Not mandatory
            else
                -- If previously not valid, start next transaction by setting VALID
                --  signal, slave target address and burst length
                if axi_awvalid = '0' and start_single_burst = '1' then
                    axi_awvalid <= '1';
                    axi_awaddr <= next_awaddr;
                    -- Once asserted, VALIDs cannot be deasserted transaction is accepted
                elsif m_axi_awready = '1' and axi_awvalid = '1' then
                    axi_awvalid <= '0';
                end if;
            end if;
        end if;
    end process w_addr_proc;

	----------------------
	--Write Data Channel
	----------------------
    -- The write data channel will continually try to push write data across the 
    -- interface. Updating the wdata lines whenever wvalid and wready signals are high.
    -- The channel keeps track of the remaining beats in the transaction and drives 
    -- the wlast signal accordingly.

    next_wdata <= data_in when send_image_size = '0' else image_size;
    data_ack <= m_axi_wready and not send_image_size;
    axi_wdata <= next_wdata;
    w_data_proc: process(m_axi_aclk)
    begin
        if rising_edge(m_axi_aclk) then
            if m_axi_aresetn = '0' or start_axi = '1' then
                axi_wvalid <= '0';
                axi_wlast <= '0';               -- Not mandatory
                --axi_wdata <= (others => '0');   -- Not mandatory
                --data_ack <= '0';
            else
                if axi_wvalid = '0' and start_single_burst = '1' then
                    axi_wvalid <= '1';
                    axi_wlast <= '0';
                    --axi_wdata <= next_wdata;
                    --data_ack <= '1';
                    beat_counter <= (others => '0');
                elsif axi_wvalid = '1' then
                    if m_axi_wready = '1' then -- Write next beat
                        if axi_wlast = '1' then
                            axi_wvalid <= '0';
                            axi_wlast <= '0';
                            --data_ack <= '0';
                        else
                            axi_wvalid <= '1';
                            --axi_wdata <= next_wdata;
                            --data_ack <= '1';
                            if beat_counter = std_logic_vector(to_unsigned(AXI_BURST_LEN-2, BEAT_COUNTER_WIDTH)) then
                                axi_wlast <= '1';
                            else
                                beat_counter <= std_logic_vector(unsigned(beat_counter) + 1);
                            end if;
                        end if;
                    else
                        --data_ack <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process w_data_proc;

    ------------------------------
	--Write Response (B) Channel
	------------------------------
	--The write response channel provides feedback that the write has committed
	--to memory. BREADY will occur when all of the data and the write address
	--has arrived and been accepted by the slave.

    w_resp_proc: process(m_axi_aclk)
    begin
        if rising_edge(m_axi_aclk) then
            if m_axi_aresetn = '0' or start_axi = '1' then
                axi_bready <= '0';
            else
                -- Acknowledge bresp with axi_bready by the master       
	            -- when m_axi_bvalid is asserted by slave   
                if m_axi_bvalid = '1' and axi_bready = '0' then               
                    axi_bready <= '1';
                    -- something <= m_axi_bresp;                                        
                -- deassert after one clock cycle                             
                elsif axi_bready = '1' then                                   
                    axi_bready <= '0';                              
                end if;   
            end if;
        end if;
    end process w_resp_proc;


end behavioural;