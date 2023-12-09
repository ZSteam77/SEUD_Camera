----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2023 15:12:51
-- Design Name: 
-- Module Name: tb_top - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is
    component camera_controller_top is
        Port (
            clk : in std_logic;
            nreset : in std_logic;
            camera_idle : in std_logic;
            operation   : in std_logic;--take a picture
            
            xclk_en      : out std_logic;
            cam_reset    : out std_logic;
            cam_pwdn     : out std_logic;
            take_pic : out std_logic;
            sioc : out std_logic;
            siod : inout std_logic;
            next_data_o : out std_logic
        );
    end component;
    
    signal next_data,clk,nreset,camera_idle,operation,xclk_en,cam_reset,cam_pwdn,take_pic,sioc,siod : std_logic := '0';
    signal sioc_data, siod_data : std_logic_vector(40 downto 0) := (others => '0');
begin
    dut : camera_controller_top port map(
        clk => clk,
        nreset => nreset,
        camera_idle => camera_idle,
        operation => operation,
        xclk_en => xclk_en,
        cam_reset => cam_reset,
        cam_pwdn => cam_pwdn,
        take_pic => take_pic,
        sioc => sioc,
        siod => siod,
        next_data_o => next_data
    );
    clk <= not clk after 5 ns;
    process begin
        nreset <= '0';
        wait for 10 ns;
        nreset <= '1';
        camera_idle <= '0';
        wait;
    end process;
    process (sioc, next_data) begin
        if (rising_edge(sioc)) then
            siod_data <= siod_data(39 downto 0) & siod;
        end if;
        if next_data = '1' then
            siod_data <= (others => '0');
        end if;
    end process;
    process (next_data) begin
        
    end process;
end Behavioral;
