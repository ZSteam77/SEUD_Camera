----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2023 19:19:31
-- Design Name: 
-- Module Name: camera_controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity camera_controller is
    port (
        nreset       : in std_logic;                         -- Active low reset
        clk          : in std_logic;
        camera_idle  : in std_logic;
        next_data    : in std_logic;
        data_in_cfg  : in std_logic_vector(8 downto 0);
        init_done : in std_logic;
        
        -- signals of axi slave from processor
        operation    : in std_logic;--take a picture
        
--        address      : out std_logic_vector(15 downto 0);
        read_controller : out std_logic;        
        write_config : out std_logic;
        data_to_send : out std_logic_vector(31 downto 0);
        xclk_en      : out std_logic;
        cam_reset    : out std_logic;
        cam_pwdn     : out std_logic;
--        capture_mode : out std_logic;
        take_pic     : out std_logic;
        R_W : out std_logic

        
        
        );
end camera_controller;

architecture Behavioral of camera_controller is
    signal init_flag, read_controller_flag : std_logic := '0';
    signal counter : std_logic_vector(1 downto 0) := (others => '0');
    signal data_to_send_reg : std_logic_vector(31 downto 0);
--    constant address_reg : address_array := (
--        x"3100",x"3102",x"3103",x"3108",x"3200",x"3201",x"3202",x"3203",x"3212",x"3213");
begin
    process (clk) begin
        if falling_edge(clk) then
            if (nreset = '0') then
                read_controller_flag <= '0';
                write_config <= '0';
                xclk_en <= '0';
                cam_reset <= '0';
                cam_pwdn <= '1';
                take_pic <= '0';
                init_flag <= '1';
                counter <= (others => '0');
                R_W <= '1';
                data_to_send_reg <= (others => '0');
            else
                cam_pwdn  <= '0'; 
                cam_reset <= '1';
                xclk_en <= '1';
                R_W <= '1';
                if (init_flag = '1') then
                    read_controller_flag <= '1';
                    if (init_done = '1' and next_data = '1') then
                        init_flag <= '0';
                        read_controller_flag <= '0';
                        write_config <= '0';
                    elsif (data_in_cfg(7 downto 0) = x"78" or unsigned(counter) >= 0) then
                        if (unsigned(counter) = 3) then
                            read_controller_flag <= '0';
                            write_config <= '1';
                            R_W <= '0';
                        else
                            counter <= std_logic_vector(unsigned(counter) + 1);
                        end if;
                        if (data_in_cfg(7 downto 0) = x"78" or data_in_cfg(7 downto 0) = "010110000") then
                            counter <= "01";
                        end if;
                        if (read_controller_flag = '1') then
                            data_to_send_reg <= data_to_send_reg(23 downto 0) & data_in_cfg(7 downto 0);
                        end if;
                        if (read_controller_flag = '0' and next_data = '1') then
                            read_controller_flag <= '1';
                            counter <= (others => '0');
                            write_config <= '0';
                            R_W <= '1';
                        end if;
                    else
                    
                    end if;
                    
                else
                    if (operation = '1' and camera_idle = '1') then
                        take_pic <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    read_controller <= read_controller_flag;
    data_to_send <= data_to_send_reg;

end Behavioral;
