-------------------------------------------------------------------------------
-- File name:   dvp_capture.vhd
--
-- Description: Handles the capture of image data coming from the camera DVP
--              port and keeps track of syncronization signals and image size
--              (as the number of received bytes). Packs received data in 32-bit
--              words and synchronizes it with the system's main clock signal.
--
-- Author:      Tomas H.
-- Versions:    v0.1    11/11/2021  Initial implementation
--              v0.2    21/11/2021  32-bit output synchronized to system clock
--              v0.3    09/12/2021  Single image capture upon request
--              v0.4
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Output format: RGB 565
-- Resolution: 1280x720
-- FPS: 15
entity dvp_capture is
    port (
        nreset      : in std_logic;                         -- Active low reset
        sys_clk     : in std_logic;                         -- System clock
        pclk        : in std_logic;                         -- OV5640 Pixel clock
        vsync       : in std_logic;                         -- OV5640 Vsync signal
        href        : in std_logic;                         -- OV5640 Href signal
        data_in     : in std_logic_vector (7 downto 0);     -- OV5640 8-bit data output
        wen_out     : out std_logic := '0';                 -- High when 'data_out' updates
        data_out    : out std_logic_vector (31 downto 0) := (others => '0');    -- 32-bit packed image data
        capture_img : in std_logic;                         -- Initiates the image capture process
        new_image   : out std_logic := '0';                 -- Signals the start of the capture process
        end_image   : out std_logic := '0';                 -- Signal the end of the capture process
        image_size  : out std_logic_vector (31 downto 0) := (others => '0')     -- Num of bytes of the captured image
    );
end dvp_capture;

architecture behavioral of dvp_capture is
    type simple_fsm_states is (FSM_STANDBY, FSM_START, FSM_RUNNING, FSM_STOP);

    -- 'sys_clk' synchronized signals
    signal sysclk_fsm_state     : simple_fsm_states := FSM_STANDBY;
    signal capture_next_image   : std_logic := '0';
    signal int_wen_out          : std_logic := '0';
    signal sync01_send_buffer_1 : std_logic;
    signal sync01_send_buffer_2 : std_logic;
    signal sync02_send_buffer_1 : std_logic;
    signal sync02_send_buffer_2 : std_logic;
    signal reset_buffer_1 : std_logic := '0';
    signal reset_buffer_2 : std_logic := '1';

    -- 'pclk' synchronized signals
    signal pclk_fsm_state   : simple_fsm_states := FSM_STANDBY;
    signal prev_vsync       : std_logic := '1';
    signal capture_ongoing  : std_logic := '0';
    signal out_buffer_10    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_11    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_12    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_13    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_20    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_21    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_22    : std_logic_vector (7 downto 0) := (others => '0');
    signal out_buffer_23    : std_logic_vector (7 downto 0) := (others => '0');
    signal pack_buffer_pos  : unsigned (2 downto 0) := (others => '0');
    signal bytes_count      : std_logic_vector(31 downto 0) := (others => '0');
    signal pclk2sys_send_buffer_1 : std_logic := '0';  -- Cross-clock domain
    signal pclk2sys_send_buffer_2 : std_logic := '0';  -- Cross-clock domain

begin
    -- Logic synchronized to system clock 'sys_clk'
    sysclk_proc: process (sys_clk, capture_next_image, int_wen_out)
    begin
        wen_out <= int_wen_out;
        new_image <= capture_next_image;

        if rising_edge(sys_clk) then
            -- Double latching synchronization of 'pclk2sys_send_buffer_X' signals
            sync01_send_buffer_1 <= pclk2sys_send_buffer_1; 
            sync01_send_buffer_2 <= pclk2sys_send_buffer_2; 
            sync02_send_buffer_1 <= sync01_send_buffer_1;
            sync02_send_buffer_2 <= sync01_send_buffer_2;

            if nreset = '0' then    -- Synchronous active low reset
                sysclk_fsm_state    <= FSM_STANDBY;
                capture_next_image  <= '0';
                end_image           <= '0';
                data_out            <= (others => '0');
                image_size          <= (others => '0');
                int_wen_out         <= '0';
                reset_buffer_1 <= '0';
                reset_buffer_2 <= '1';                
            else
                case sysclk_fsm_state is
                    when FSM_STANDBY =>
                        -- Signal assignments
                        capture_next_image  <= '0';
                        end_image           <= '0';
                        data_out            <= (others => '0');
                        int_wen_out         <= '0';
                        reset_buffer_1 <= '0';
                        reset_buffer_2 <= '1';
                        -- Next state logic
                        if capture_img = '1' then
                            sysclk_fsm_state <= FSM_START;
                        end if;         
                    when FSM_START =>
                        -- Signal assignments
                        capture_next_image  <= '1';
                        end_image           <= '0';
                        image_size          <= (others => '0');
                        -- Next state logic
                        if capture_ongoing = '1' then
                            sysclk_fsm_state <= FSM_RUNNING;
                        end if;
                    when FSM_RUNNING =>
                        -- Signal assignments
                        capture_next_image  <= '0';
                        end_image           <= '0';
                        -- Transmit buffers when full, transmission lasts 1 'sys_clk' cycle
                        if int_wen_out = '1' then
                            int_wen_out <= '0';
                        -- It must only be possible to send one buffer if the other has
                        --  already been sent. ('reset_buffer_X' signals use here)
                        elsif sync02_send_buffer_1 = '1' and reset_buffer_1 = '0' then
                            data_out <= out_buffer_10 & out_buffer_11 & out_buffer_12 & out_buffer_13;
                            int_wen_out <= '1';
                            reset_buffer_1 <= '1';
                            reset_buffer_2 <= '0';
                        elsif sync02_send_buffer_2 = '1' and reset_buffer_2 = '0' then
                            data_out <= out_buffer_20 & out_buffer_21 & out_buffer_22 & out_buffer_23;
                            int_wen_out <= '1';
                            reset_buffer_1 <= '0';
                            reset_buffer_2 <= '1';                                
                        end if;
                        -- Next state logic
                        if capture_ongoing = '0' then
                            sysclk_fsm_state <= FSM_STOP;
                        end if;
                    when FSM_STOP =>
                        -- Signal assignments
                        capture_next_image  <= '0';
                        end_image           <= '1';
                        image_size <= bytes_count;
                        -- Next state logic
                        sysclk_fsm_state <= FSM_STANDBY;
                    when others => 
                        sysclk_fsm_state <= FSM_STANDBY;
                end case;
            end if;
        end if;
    end process sysclk_proc;

    -- Logic synchronized to OV5640 pixel clock 'pclk'
    pclk_proc: process (pclk, nreset)
    begin
        if rising_edge(pclk) then
            if nreset = '0' then    -- Asynchronous active low reset
                capture_ongoing <= '0';
                pack_buffer_pos <= (others => '0');
                bytes_count     <= (others => '0');
                pclk2sys_send_buffer_1 <= '0';
                pclk2sys_send_buffer_2 <= '0';
            else
                prev_vsync <= vsync;
    
                case pclk_fsm_state is
                    when FSM_STANDBY =>
                        -- Signal assignments
                        capture_ongoing <= '0';
                        pack_buffer_pos <= (others => '0');
                        bytes_count     <= (others => '0');
                        pclk2sys_send_buffer_1 <= '0';
                        pclk2sys_send_buffer_2 <= '0';
                        -- Next state logic
                        if capture_next_image = '1' and prev_vsync = '0' and vsync = '1' then
                            pclk_fsm_state <= FSM_START;
                        end if;
                    when FSM_START =>
                        -- Signal assignments
                        capture_ongoing <= '1';
                        bytes_count <= (others => '0');
                        -- Next state logic
                        pclk_fsm_state <= FSM_RUNNING;
                    when FSM_RUNNING =>
                        -- Signal assignments
                        capture_ongoing <= '1';
                        -- If href is high transfer 1 image byte to one of the output buffers
                        if href = '1' then
                            -- Store data input byte in one of the output buffers
                            case pack_buffer_pos is
                                when "000" => 
                                    out_buffer_10 <= data_in;
                                when "001" => 
                                    out_buffer_11 <= data_in;
                                when "010" => 
                                    out_buffer_12 <= data_in;
                                when "011" => 
                                    out_buffer_13 <= data_in;
                                    pclk2sys_send_buffer_1 <= '1';
                                when "100" => 
                                    out_buffer_20 <= data_in;
                                when "101" => 
                                    out_buffer_21 <= data_in;
                                when "110" => 
                                    out_buffer_22 <= data_in;
                                when "111" => 
                                    out_buffer_23 <= data_in;
                                    pclk2sys_send_buffer_2 <= '1';
                                when others => 
                                    out_buffer_10 <= (others => '0');
                            end case;
                            -- Increment the output buffer index
                            pack_buffer_pos <= pack_buffer_pos + 1;
                            -- Increment bytes_count
                            bytes_count <= std_logic_vector(unsigned(bytes_count) + 1);
                        end if;
                        -- 'pclk2sys_send_buffer_1' must be high for one 'pclk' cycle only.
                        --   Resetting the signal must be independent of 'href'
                        if pclk2sys_send_buffer_1 = '1' then
                            pclk2sys_send_buffer_1 <= '0';
                        end if;
                        -- 'pclk2sys_send_buffer_2' must be high for one 'pclk' cycle only
                        --   Resetting the signal must be independent of 'href'
                        if pclk2sys_send_buffer_2 = '1' then
                            pclk2sys_send_buffer_2 <= '0';
                        end if;
                        -- Next state logic
                        if prev_vsync = '1' and vsync = '0' then
                            pclk_fsm_state <= FSM_STOP;
                        end if;
                    when FSM_STOP =>
                        -- Signal assignments
                        capture_ongoing <= '0';
                        -- Next state logic
                        pclk_fsm_state <= FSM_STANDBY;
                    when others =>
                        pclk_fsm_state <= FSM_STANDBY;
                end case;
            end if;
        end if;
        
        -- Update the output buffer pointer on 'pclk' falling edge to avoid
        --  run away condition with 'sys_clk' sampling incorrect output data
        --  because data_in hasn't have time to settle in 'out_buffer'
    end process pclk_proc;
end behavioral;