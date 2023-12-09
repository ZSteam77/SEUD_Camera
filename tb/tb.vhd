----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2023 16:55:08
-- Design Name: 
-- Module Name: tb - Behavioral
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
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.all;
entity tb is
end tb;

architecture Behavioral of tb is
    signal clk: std_logic := '0';
    signal reset : std_logic := '0';
    signal clk_div1,clk_div2 : std_logic := '0';
    component tmr_clk_gen is
        port(clk,reset:IN std_logic;
            clk_div1,clk_div2:OUT std_logic);
    end component;
begin
    dut : tmr_clk_gen port map(
        clk => clk,
        reset => reset,
        clk_div1 => clk_div1,
        clk_div2 => clk_div2
    );
    clk <= (not clk) after 10 ns;
    process begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait;
    end process;
end Behavioral;
