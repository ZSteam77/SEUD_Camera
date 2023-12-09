----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2021 11:00:43 AM
-- Design Name: 
-- Module Name: controller_fsm - behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity dma_controller is
    port(
        -- Common ports
        clk         : in std_logic;
        nreset      : in std_logic;
        -- Camera DVP related ports
        new_image   : in std_logic;
        end_image   : in std_logic;
        dvp_wen     : in std_logic;
        dvp_din     : in std_logic_vector(31 downto 0);
        dvp_capture : out std_logic := '0';
        -- AXI Master related ports
        axi_dout    : out std_logic_vector(31 downto 0) := (others => '0');
        axi_ack     : in std_logic;
        axi_eoi     : in std_logic;
        start_axi   : out std_logic := '0';
        stop_axi    : out std_logic := '0';
        start_burst : out std_logic := '0';
        -- DMA control/status ports
        take_pic    : in std_logic;
        camera_idle : out std_logic := '0'
    );
end dma_controller;

architecture behavioural of dma_controller is

    component ram_buffer is
        generic(
            DATA_WIDTH          : integer := 32;    -- Word size in bits
            ADDRESS_WIDTH       : integer := 7;      -- log2(number of words in the memory)
            MEMORY_SIZE_BITS    : integer := 4096   -- 2**ADDRESS_WIDTH * DATA_WIDTH
        );
        port(
            clk     : in std_logic;
            din_a   : in std_logic_vector (DATA_WIDTH-1 downto 0);
            addr_a  : in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
            we_a    : in std_logic;
            addr_b  : in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
            dout_b  : out std_logic_vector (DATA_WIDTH-1 downto 0)
        );
    end component;

    type dma_fsm_states is (DMA_STANDBY,    -- Initial state. Signals 'camera_idle' Waits
                                            -- for a rising edge in 'take_pic' signal
                            DMA_INIT,       -- Initializes internal states, signals DVP
                                            --  module to start capturing an image and
                                            --  intializes the AXI master
                            DMA_WAIT_NEW_IMG,   -- Waits for 'new_image' 

                            DMA_WAIT_END_IMG,   -- Waits for 'end_image'
                            
                            DMA_WAIT_EOI);  -- Stops the AXI master and Waits on 'axi_eoi'
                                            --  for the image size to be transfered to
                                            --  the SDRAM

    signal pres_dma_state   : dma_fsm_states := DMA_STANDBY;
    signal reset_addresses  : std_logic := '0';
    signal prev_take_pic    : std_logic := '0';
    -- This 
    signal ram_write_bank   : std_logic := '0'; 
    signal prev_write_bank  : std_logic := '0';
    -- Address to be written 
    signal ram_write_addr   : std_logic_vector(6 downto 0) := (others => '0'); 
    -- Address to be read
    signal ram_read_addr    : std_logic_vector(6 downto 0) := (others => '0');

begin
    inst_ram_buffer: ram_buffer
    port map(
        clk     => clk,
        din_a   => dvp_din,
        addr_a  => ram_write_addr,
        we_a    => dvp_wen,
        addr_b  => ram_read_addr,
        dout_b  => axi_dout
    );

    -- Main FSM to control the image adquisition process
    dma_fsm_proc: process(clk)
    begin
        if rising_edge(clk) then
            if nreset = '0' then
                pres_dma_state <= DMA_STANDBY;
                reset_addresses <= '0';
                dvp_capture     <= '0';
                start_axi       <= '0';
                stop_axi        <= '0';
                camera_idle     <= '1';
            else
                prev_take_pic <= take_pic;

                case pres_dma_state is
                    when DMA_STANDBY =>
                        -- Signal assignments
                        reset_addresses <= '0';
                        dvp_capture     <= '0';
                        start_axi       <= '0';
                        stop_axi        <= '0';
                        camera_idle     <= '1';
                        -- Next state logic
                        if prev_take_pic = '0' and take_pic = '1' then
                            pres_dma_state <= DMA_INIT;
                        end if;
                    when DMA_INIT =>
                        -- Signal assignments
                        reset_addresses <= '1';
                        dvp_capture     <= '1';
                        start_axi       <= '1';
                        stop_axi        <= '0';
                        camera_idle     <= '0';
                        -- Next state logic
                        pres_dma_state <= DMA_WAIT_NEW_IMG;
                    when DMA_WAIT_NEW_IMG =>
                        -- Signal assignments
                        reset_addresses <= '0';
                        dvp_capture     <= '0';
                        start_axi       <= '0';
                        stop_axi        <= '0';
                        camera_idle     <= '0';
                        -- Next state logic
                        if new_image = '1' then
                            pres_dma_state <= DMA_WAIT_END_IMG;
                        end if;
                    when DMA_WAIT_END_IMG =>
                        -- Signal assignments
                        reset_addresses <= '0';
                        dvp_capture     <= '0';
                        start_axi       <= '0';
                        stop_axi        <= '0';
                        camera_idle     <= '0';
                        -- Next state logic
                        if end_image = '1' then
                            pres_dma_state <= DMA_WAIT_EOI;
                        end if;
                    when DMA_WAIT_EOI =>
                        -- Signal assignments
                        reset_addresses <= '0';
                        dvp_capture     <= '0';
                        start_axi       <= '0';
                        stop_axi        <= '1';
                        camera_idle     <= '0';
                        -- Next state logic
                        if axi_eoi = '1' then
                            pres_dma_state <= DMA_STANDBY;
                        end if;
                    when others =>
                        pres_dma_state <= DMA_STANDBY;
                end case;
            end if;
        end if;
    end process dma_fsm_proc;

    -- Addresses generators for RAM
    ram_write_bank <= ram_write_addr(ram_write_addr'left);
    addr_gen_proc: process(clk)
    begin
        if rising_edge(clk) then
                
            if nreset = '0' or reset_addresses = '1' then
                ram_write_addr <= (others => '0');
                prev_write_bank <= '0';
                ram_read_addr <= (others => '0');
                start_burst <= '0';
            else
                prev_write_bank <= ram_write_bank;
                -- Start an AXI transaction each time one half of the memory is full.
                --  This assumes that AXI transactions will complete faster than one 
                --  half of the memory (bank) can be filled up.
                if ram_write_bank /= prev_write_bank then
                    start_burst <= '1';
                else
                    start_burst <= '0';
                end if;
                -- Handle RAM write addresses
                if dvp_wen = '1' then
                    ram_write_addr <= std_logic_vector(unsigned(ram_write_addr) + 1);
                end if;
                -- Handle RAM read addresses
                if axi_ack = '1' then
                    ram_read_addr <= std_logic_vector(unsigned(ram_read_addr) + 1);
                end if;
            end if;
        end if;
    end process addr_gen_proc;

end behavioural;
