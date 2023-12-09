----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2023 17:04:35
-- Design Name: 
-- Module Name: camera_configuration - Behavioral
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

entity camera_configuration is
    Port ( 
--           address : in std_logic_vector (11 downto 0);
           read_controller : in std_logic;
           nreset : in std_logic;
           sys_clk : in std_logic;
           data : out std_logic_vector (8 downto 0);
           init_done : out std_logic
           
           );
end camera_configuration;

architecture Behavioral of camera_configuration is
    signal counter : std_logic_vector(11 downto 0) := (others => '0');
begin
    process(sys_clk)begin
        if (rising_edge(sys_clk)) then
            if (nreset = '0') then
                counter <= (others => '0');
                data <= "011101110";
                init_done <= '0';
            elsif (read_controller = '1') then
                case(counter) is 
            -------------------------CAMERA INIT-------------------------
                    when x"000" => data <= "011101110"; -- start delay (30 ms)
                    
                    when x"001" => data <= '1' & x"78"; -- OV5640 ADDR (0x78) / 101111000
                    when x"002" => data <= '1' & x"31"; -- reg: 0x3103 HI (0x31) / 100110001
                    when x"003" => data <= '1' & x"03"; -- reg: 0x3103 LO (0x03) / 100000011
                    when x"004" => data <= '1' & x"11"; -- data: 0x11 / 100010001
                    when x"005" => data <= "011111111"; -- i2c stop
                     
                    when x"006" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"007" => data <= '1' & x"30"; -- reg: 0x3008 HI (0x30) / 100110000
                    when x"008" => data <= '1' & x"08"; -- reg: 0x3008 LO (0x08) / 100001000
                    when x"009" => data <= '1' & x"82"; -- data: 0x82 / 110000010
                    when x"00a" => data <= "011111111"; -- i2c stop
                     
                    when x"00b" => data <= "011101100"; -- second delay (10 ms)
                    
                    when x"00c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"00d" => data <= '1' & x"30"; -- reg: 0x3008 HI (0x30) / 100110000
                    when x"00e" => data <= '1' & x"08"; -- reg: 0x3008 LO (0x08) / 100001000
                    when x"00f" => data <= '1' & x"42"; -- data: 0x42 / 101000010
                    when x"010" => data <= "011111111"; -- i2c stop
                    
                    when x"011" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"012" => data <= '1' & x"31"; -- reg: 0x3103 HI (0x31) / 100110001
                    when x"013" => data <= '1' & x"03"; -- reg: 0x3103 LO (0x03) / 100000011
                    when x"014" => data <= '1' & x"03"; -- data: 0x03 / 100000011
                    when x"015" => data <= "011111111"; -- i2c stop
        
                    when x"016" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"017" => data <= '1' & x"30"; -- reg: 0x3017 HI (0x30) / 100110000
                    when x"018" => data <= '1' & x"17"; -- reg: 0x3017 LO (0x17) / 100010111
                    when x"019" => data <= '1' & x"ff"; -- data: 0xff / 111111111
                    when x"01a" => data <= "011111111"; -- i2c stop
        
                    when x"01b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"01c" => data <= '1' & x"30"; -- reg: 0x3018 HI (0x30) / 100110000
                    when x"01d" => data <= '1' & x"18"; -- reg: 0x3018 LO (0x18) / 100011000
                    when x"01e" => data <= '1' & x"ff"; -- data: 0xff / 111111111
                    when x"01f" => data <= "011111111"; -- i2c stop
        
                    when x"020" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"021" => data <= '1' & x"30"; -- reg: 0x3034 HI (0x30) / 100110000
                    when x"022" => data <= '1' & x"34"; -- reg: 0x3034 LO (0x34) / 100110100
                    when x"023" => data <= '1' & x"1a"; -- data: 0x1a / 100011010
                    when x"024" => data <= "011111111"; -- i2c stop
        
                    when x"025" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"026" => data <= '1' & x"30"; -- reg: 0x3037 HI (0x30) / 100110000
                    when x"027" => data <= '1' & x"37"; -- reg: 0x3037 LO (0x37) / 100110111
                    when x"028" => data <= '1' & x"13"; -- data: 0x13 / 100010011
                    when x"029" => data <= "011111111"; -- i2c stop
        
                    when x"02a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"02b" => data <= '1' & x"31"; -- reg: 0x3108 HI (0x31) 100110001
                    when x"02c" => data <= '1' & x"08"; -- reg: 0x3108 LO (0x08) 100001000
                    when x"02d" => data <= '1' & x"01"; -- data: 0x01 100000001
                    when x"02e" => data <= "011111111"; -- i2c stop
        
                    when x"02f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"030" => data <= '1' & x"36"; -- reg: 0x3630 HI (0x36) 100110110
                    when x"031" => data <= '1' & x"30"; -- reg: 0x3630 LO (0x30) 100110000
                    when x"032" => data <= '1' & x"36"; -- data: 0x36 100110110
                    when x"033" => data <= "011111111"; -- i2c stop
                    
                    when x"034" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"035" => data <= '1' & x"36"; -- reg: 0x3631 HI (0x36) 100110110
                    when x"036" => data <= '1' & x"31"; -- reg: 0x3631 LO (0x31) 100110001
                    when x"037" => data <= '1' & x"0e"; -- data: 0x0e 100001110
                    when x"038" => data <= "011111111"; -- i2c stop
                    
                    when x"039" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"03a" => data <= '1' & x"36"; -- reg: 0x3632 HI (0x36)
                    when x"03b" => data <= '1' & x"32"; -- reg: 0x3632 LO (0x32)
                    when x"03c" => data <= '1' & x"e2"; -- data: 0xe2
                    when x"03d" => data <= "011111111"; -- i2c stop
        
                    when x"03e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"03f" => data <= '1' & x"36"; -- reg: 0x3633 HI (0x36) 100110110
                    when x"040" => data <= '1' & x"33"; -- reg: 0x3633 LO (0x33) 100110011
                    when x"041" => data <= '1' & x"12"; -- data: 0x12 100010010
                    when x"042" => data <= "011111111"; -- i2c stop
        
                    when x"043" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"044" => data <= '1' & x"36"; -- reg: 0x3621 HI (0x36) 100110110
                    when x"045" => data <= '1' & x"21"; -- reg: 0x3621 LO (0x21) 100100001
                    when x"046" => data <= '1' & x"e0"; -- data: 0xe0 111100000
                    when x"047" => data <= "011111111"; -- i2c stop
        
                    when x"048" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"049" => data <= '1' & x"37"; -- reg: 0x3704 HI (0x37) 100110111
                    when x"04a" => data <= '1' & x"04"; -- reg: 0x3704 LO (0x04) 100000100
                    when x"04b" => data <= '1' & x"a0"; -- data: 0xa0 110100000
                    when x"04c" => data <= "011111111"; -- i2c stop
        
                    when x"04d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"04e" => data <= '1' & x"37"; -- reg: 0x3703 HI (0x37) 100110111
                    when x"04f" => data <= '1' & x"03"; -- reg: 0x3703 LO (0x03) 100000011
                    when x"050" => data <= '1' & x"5a"; -- data: 0x5a 101011010
                    when x"051" => data <= "011111111"; -- i2c stop
        
                    when x"052" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"053" => data <= '1' & x"37"; -- reg: 0x3715 HI (0x37) 100110111
                    when x"054" => data <= '1' & x"15"; -- reg: 0x3715 LO (0x15) 100010101
                    when x"055" => data <= '1' & x"78"; -- data: 0x78 101111000
                    when x"056" => data <= "011111111"; -- i2c stop
        
                    when x"057" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"058" => data <= '1' & x"37"; -- reg: 0x3717 HI (0x37) 100110111
                    when x"059" => data <= '1' & x"17"; -- reg: 0x3717 LO (0x17) 100010111
                    when x"05a" => data <= '1' & x"01"; -- data: 0x01 100000001
                    when x"05b" => data <= "011111111"; -- i2c stop
        
                    when x"05c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"05d" => data <= '1' & x"37"; -- reg: 0x370b HI (0x37) 100110
                    when x"05e" => data <= '1' & x"0b"; -- reg: 0x370b LO (0x0b) 100001011
                    when x"05f" => data <= '1' & x"60"; -- data: 0x60 101100000
                    when x"060" => data <= "011111111"; -- i2c stop
        
                    when x"061" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"062" => data <= '1' & x"37"; -- reg: 0x3705 HI (0x37) 100110111
                    when x"063" => data <= '1' & x"05"; -- reg: 0x3705 LO (0x05) 100000101
                    when x"064" => data <= '1' & x"1a"; -- data: 0x1a 100011010
                    when x"065" => data <= "011111111"; -- i2c stop
        
                    when x"066" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"067" => data <= '1' & x"39"; -- reg: 0x3905 HI (0x39)
                    when x"068" => data <= '1' & x"05"; -- reg: 0x3905 LO (0x05)
                    when x"069" => data <= '1' & x"02"; -- data: 0x02
                    when x"06a" => data <= "011111111"; -- i2c stop
                    
                    when x"06b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"06c" => data <= '1' & x"39"; -- reg: 0x3906 HI (0x39)
                    when x"06d" => data <= '1' & x"06"; -- reg: 0x3906 LO (0x06)
                    when x"06e" => data <= '1' & x"10"; -- data: 0x10
                    when x"06f" => data <= "011111111"; -- i2c stop
                    
                    when x"070" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"071" => data <= '1' & x"39"; -- reg: 0x3901 HI (0x39)
                    when x"072" => data <= '1' & x"01"; -- reg: 0x3901 LO (0x01)
                    when x"073" => data <= '1' & x"0a"; -- data: 0x0a
                    when x"074" => data <= "011111111"; -- i2c stop
                    
                    when x"075" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"076" => data <= '1' & x"37"; -- reg: 0x3731 HI (0x37)
                    when x"077" => data <= '1' & x"31"; -- reg: 0x3731 LO (0x31)
                    when x"078" => data <= '1' & x"12"; -- data: 0x12
                    when x"079" => data <= "011111111"; -- i2c stop
        
                    when x"07a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"07b" => data <= '1' & x"36"; -- reg: 0x3901 HI (0x39)
                    when x"07c" => data <= '1' & x"00"; -- reg: 0x3901 LO (0x01)
                    when x"07d" => data <= '1' & x"08"; -- data: 0x0a
                    when x"07e" => data <= "011111111"; -- i2c stop
        
                    when x"07f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"080" => data <= '1' & x"36"; -- reg: 0x3901 HI (0x39)
                    when x"081" => data <= '1' & x"01"; -- reg: 0x3901 LO (0x01)
                    when x"082" => data <= '1' & x"33"; -- data: 0x0a
                    when x"083" => data <= "011111111"; -- i2c stop
        
                    when x"084" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"085" => data <= '1' & x"30"; -- reg: 0x3901 HI (0x39)
                    when x"086" => data <= '1' & x"2d"; -- reg: 0x3901 LO (0x01)
                    when x"087" => data <= '1' & x"60"; -- data: 0x0a
                    when x"088" => data <= "011111111"; -- i2c stop
        
                    when x"089" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"08a" => data <= '1' & x"36"; -- reg: 0x3901 HI (0x39)
                    when x"08b" => data <= '1' & x"20"; -- reg: 0x3901 LO (0x01)
                    when x"08c" => data <= '1' & x"52"; -- data: 0x0a
                    when x"08d" => data <= "011111111"; -- i2c stop
        
                    when x"08e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"08f" => data <= '1' & x"37"; -- reg: 0x3901 HI (0x39)
                    when x"090" => data <= '1' & x"1b"; -- reg: 0x3901 LO (0x01)
                    when x"091" => data <= '1' & x"20"; -- data: 0x0a
                    when x"092" => data <= "011111111"; -- i2c stop
        
                    when x"093" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"094" => data <= '1' & x"47"; -- reg: 0x3901 HI (0x39)
                    when x"095" => data <= '1' & x"1c"; -- reg: 0x3901 LO (0x01)
                    when x"096" => data <= '1' & x"50"; -- data: 0x0a
                    when x"097" => data <= "011111111"; -- i2c stop
        
                    when x"098" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"099" => data <= '1' & x"3a"; -- reg: 0x3901 HI (0x39)
                    when x"09a" => data <= '1' & x"13"; -- reg: 0x3901 LO (0x01)
                    when x"09b" => data <= '1' & x"43"; -- data: 0x0a
                    when x"09c" => data <= "011111111"; -- i2c stop
        
                    when x"09d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"09e" => data <= '1' & x"3a"; -- reg: 0x3901 HI (0x39)
                    when x"09f" => data <= '1' & x"18"; -- reg: 0x3901 LO (0x01)
                    when x"0a0" => data <= '1' & x"00"; -- data: 0x0a
                    when x"0a1" => data <= "011111111"; -- i2c stop
        
                    when x"0a2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0a3" => data <= '1' & x"3a"; -- reg HI
                    when x"0a4" => data <= '1' & x"19"; -- reg LO
                    when x"0a5" => data <= '1' & x"f8"; -- data
                    when x"0a6" => data <= "011111111"; -- i2c stop
        
                    when x"0a7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0a8" => data <= '1' & x"36"; -- reg HI
                    when x"0a9" => data <= '1' & x"35"; -- reg LO
                    when x"0aa" => data <= '1' & x"13"; -- data
                    when x"0ab" => data <= "011111111"; -- i2c stop
        
                    when x"0ac" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0ad" => data <= '1' & x"36"; -- reg HI
                    when x"0ae" => data <= '1' & x"36"; -- reg LO
                    when x"0af" => data <= '1' & x"03"; -- data
                    when x"0b0" => data <= "011111111"; -- i2c stop
        
                    when x"0b1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0b2" => data <= '1' & x"36"; -- reg HI
                    when x"0b3" => data <= '1' & x"34"; -- reg LO
                    when x"0b4" => data <= '1' & x"40"; -- data
                    when x"0b5" => data <= "011111111"; -- i2c stop
        
                    when x"0b6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0b7" => data <= '1' & x"36"; -- reg HI
                    when x"0b8" => data <= '1' & x"22"; -- reg LO
                    when x"0b9" => data <= '1' & x"01"; -- data
                    when x"0ba" => data <= "011111111"; -- i2c stop
        
                    when x"0bb" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0bc" => data <= '1' & x"3c"; -- reg HI
                    when x"0bd" => data <= '1' & x"01"; -- reg LO
                    when x"0be" => data <= '1' & x"34"; -- data
                    when x"0bf" => data <= "011111111"; -- i2c stop
        
                    when x"0c0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0c1" => data <= '1' & x"3c"; -- reg HI
                    when x"0c2" => data <= '1' & x"04"; -- reg LO
                    when x"0c3" => data <= '1' & x"28"; -- data
                    when x"0c4" => data <= "011111111"; -- i2c stop
        
                    when x"0c5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0c6" => data <= '1' & x"3c"; -- reg HI
                    when x"0c7" => data <= '1' & x"05"; -- reg LO
                    when x"0c8" => data <= '1' & x"98"; -- data
                    when x"0c9" => data <= "011111111"; -- i2c stop
        
                    when x"0ca" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0cb" => data <= '1' & x"3c"; -- reg HI
                    when x"0cc" => data <= '1' & x"06"; -- reg LO
                    when x"0cd" => data <= '1' & x"00"; -- data
                    when x"0ce" => data <= "011111111"; -- i2c stop
        
                    when x"0cf" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0d0" => data <= '1' & x"3c"; -- reg HI
                    when x"0d1" => data <= '1' & x"07"; -- reg LO
                    when x"0d2" => data <= '1' & x"08"; -- data
                    when x"0d3" => data <= "011111111"; -- i2c stop
        
                    when x"0d4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0d5" => data <= '1' & x"3c"; -- reg HI
                    when x"0d6" => data <= '1' & x"08"; -- reg LO
                    when x"0d7" => data <= '1' & x"00"; -- data
                    when x"0d8" => data <= "011111111"; -- i2c stop
        
                    when x"0d9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0da" => data <= '1' & x"3c"; -- reg HI
                    when x"0db" => data <= '1' & x"09"; -- reg LO
                    when x"0dc" => data <= '1' & x"1c"; -- data
                    when x"0dd" => data <= "011111111"; -- i2c stop
        
                    when x"0de" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0df" => data <= '1' & x"3c"; -- reg HI
                    when x"0e0" => data <= '1' & x"0a"; -- reg LO
                    when x"0e1" => data <= '1' & x"9c"; -- data
                    when x"0e2" => data <= "011111111"; -- i2c stop
        
                    when x"0e3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0e4" => data <= '1' & x"3c"; -- reg HI
                    when x"0e5" => data <= '1' & x"0b"; -- reg LO
                    when x"0e6" => data <= '1' & x"40"; -- data
                    when x"0e7" => data <= "011111111"; -- i2c stop
        
                    when x"0e8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0e9" => data <= '1' & x"38"; -- reg HI
                    when x"0ea" => data <= '1' & x"10"; -- reg LO
                    when x"0eb" => data <= '1' & x"00"; -- data
                    when x"0ec" => data <= "011111111"; -- i2c stop
        
                    when x"0ed" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0ee" => data <= '1' & x"38"; -- reg HI
                    when x"0ef" => data <= '1' & x"11"; -- reg LO
                    when x"0f0" => data <= '1' & x"10"; -- data
                    when x"0f1" => data <= "011111111"; -- i2c stop
        
                    when x"0f2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0f3" => data <= '1' & x"38"; -- reg HI
                    when x"0f4" => data <= '1' & x"12"; -- reg LO
                    when x"0f5" => data <= '1' & x"00"; -- data
                    when x"0f6" => data <= "011111111"; -- i2c stop
        
                    when x"0f7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0f8" => data <= '1' & x"37"; -- reg HI
                    when x"0f9" => data <= '1' & x"08"; -- reg LO
                    when x"0fa" => data <= '1' & x"64"; -- data
                    when x"0fb" => data <= "011111111"; -- i2c stop
        
                    when x"0fc" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"0fd" => data <= '1' & x"40"; -- reg HI
                    when x"0fe" => data <= '1' & x"01"; -- reg LO
                    when x"0ff" => data <= '1' & x"02"; -- data
                    when x"100" => data <= "011111111"; -- i2c stop
        
                    when x"101" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"102" => data <= '1' & x"40"; -- reg HI
                    when x"103" => data <= '1' & x"05"; -- reg LO
                    when x"104" => data <= '1' & x"1a"; -- data
                    when x"105" => data <= "011111111"; -- i2c stop
        
                    when x"106" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"107" => data <= '1' & x"30"; -- reg HI
                    when x"108" => data <= '1' & x"00"; -- reg LO
                    when x"109" => data <= '1' & x"00"; -- data
                    when x"10a" => data <= "011111111"; -- i2c stop
        
                    when x"10b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"10c" => data <= '1' & x"30"; -- reg HI
                    when x"10d" => data <= '1' & x"04"; -- reg LO
                    when x"10e" => data <= '1' & x"ff"; -- data
                    when x"10f" => data <= "011111111"; -- i2c stop
        
                    when x"110" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"111" => data <= '1' & x"30"; -- reg HI
                    when x"112" => data <= '1' & x"0e"; -- reg LO
                    when x"113" => data <= '1' & x"58"; -- data
                    when x"114" => data <= "011111111"; -- i2c stop
        
                    when x"115" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"116" => data <= '1' & x"30"; -- reg HI
                    when x"117" => data <= '1' & x"2e"; -- reg LO
                    when x"118" => data <= '1' & x"00"; -- data
                    when x"119" => data <= "011111111"; -- i2c stop
        
                    when x"11a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"11b" => data <= '1' & x"43"; -- reg HI
                    when x"11c" => data <= '1' & x"00"; -- reg LO
                    when x"11d" => data <= '1' & x"30"; -- data
                    when x"11e" => data <= "011111111"; -- i2c stop
        
                    when x"11f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"120" => data <= '1' & x"50"; -- reg HI
                    when x"121" => data <= '1' & x"1f"; -- reg LO
                    when x"122" => data <= '1' & x"00"; -- data
                    when x"123" => data <= "011111111"; -- i2c stop
        
                    when x"124" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"125" => data <= '1' & x"44"; -- reg HI
                    when x"126" => data <= '1' & x"0e"; -- reg LO
                    when x"127" => data <= '1' & x"00"; -- data
                    when x"128" => data <= "011111111"; -- i2c stop
        
                    when x"129" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"12a" => data <= '1' & x"50"; -- reg HI
                    when x"12b" => data <= '1' & x"00"; -- reg LO
                    when x"12c" => data <= '1' & x"a7"; -- data
                    when x"12d" => data <= "011111111"; -- i2c stop
        
                    when x"12e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"12f" => data <= '1' & x"3a"; -- reg HI
                    when x"130" => data <= '1' & x"0f"; -- reg LO
                    when x"131" => data <= '1' & x"30"; -- data
                    when x"132" => data <= "011111111"; -- i2c stop
        
                    when x"133" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"134" => data <= '1' & x"3a"; -- reg HI
                    when x"135" => data <= '1' & x"10"; -- reg LO
                    when x"136" => data <= '1' & x"28"; -- data
                    when x"137" => data <= "011111111"; -- i2c stop
        
                    when x"138" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"139" => data <= '1' & x"3a"; -- reg HI
                    when x"13a" => data <= '1' & x"1b"; -- reg LO
                    when x"13b" => data <= '1' & x"30"; -- data
                    when x"13c" => data <= "011111111"; -- i2c stop
        
                    when x"13d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"13e" => data <= '1' & x"3a"; -- reg HI
                    when x"13f" => data <= '1' & x"1e"; -- reg LO
                    when x"140" => data <= '1' & x"26"; -- data
                    when x"141" => data <= "011111111"; -- i2c stop
        
                    when x"142" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"143" => data <= '1' & x"3a"; -- reg HI
                    when x"144" => data <= '1' & x"11"; -- reg LO
                    when x"145" => data <= '1' & x"60"; -- data
                    when x"146" => data <= "011111111"; -- i2c stop
        
                    when x"147" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"148" => data <= '1' & x"3a"; -- reg HI
                    when x"149" => data <= '1' & x"1f"; -- reg LO
                    when x"14a" => data <= '1' & x"14"; -- data
                    when x"14b" => data <= "011111111"; -- i2c stop
        
                    when x"14c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"14d" => data <= '1' & x"58"; -- reg HI
                    when x"14e" => data <= '1' & x"00"; -- reg LO
                    when x"14f" => data <= '1' & x"23"; -- data
                    when x"150" => data <= "011111111"; -- i2c stop
        
                    when x"151" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"152" => data <= '1' & x"58"; -- reg HI
                    when x"153" => data <= '1' & x"01"; -- reg LO
                    when x"154" => data <= '1' & x"14"; -- data
                    when x"155" => data <= "011111111"; -- i2c stop
        
                    when x"156" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"157" => data <= '1' & x"58"; -- reg HI
                    when x"158" => data <= '1' & x"02"; -- reg LO
                    when x"159" => data <= '1' & x"0f"; -- data
                    when x"15a" => data <= "011111111"; -- i2c stop
        
                    when x"15b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"15c" => data <= '1' & x"58"; -- reg HI
                    when x"15d" => data <= '1' & x"03"; -- reg LO
                    when x"15e" => data <= '1' & x"0f"; -- data
                    when x"15f" => data <= "011111111"; -- i2c stop
        
                    when x"160" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"161" => data <= '1' & x"58"; -- reg HI
                    when x"162" => data <= '1' & x"04"; -- reg LO
                    when x"163" => data <= '1' & x"12"; -- data
                    when x"164" => data <= "011111111"; -- i2c stop
        
                    when x"165" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"166" => data <= '1' & x"58"; -- reg HI
                    when x"167" => data <= '1' & x"05"; -- reg LO
                    when x"168" => data <= '1' & x"26"; -- data
                    when x"169" => data <= "011111111"; -- i2c stop
        
                    when x"16a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"16b" => data <= '1' & x"58"; -- reg HI
                    when x"16c" => data <= '1' & x"06"; -- reg LO
                    when x"16d" => data <= '1' & x"0c"; -- data
                    when x"16e" => data <= "011111111"; -- i2c stop
        
                    when x"16f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"170" => data <= '1' & x"58"; -- reg HI
                    when x"171" => data <= '1' & x"07"; -- reg LO
                    when x"172" => data <= '1' & x"08"; -- data
                    when x"173" => data <= "011111111"; -- i2c stop
        
                    when x"174" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"175" => data <= '1' & x"58"; -- reg HI
                    when x"176" => data <= '1' & x"08"; -- reg LO
                    when x"177" => data <= '1' & x"05"; -- data
                    when x"178" => data <= "011111111"; -- i2c stop
        
                    when x"179" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"17a" => data <= '1' & x"58"; -- reg HI
                    when x"17b" => data <= '1' & x"09"; -- reg LO
                    when x"17c" => data <= '1' & x"05"; -- data
                    when x"17d" => data <= "011111111"; -- i2c stop
        
                    when x"17e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"17f" => data <= '1' & x"58"; -- reg HI
                    when x"180" => data <= '1' & x"0a"; -- reg LO
                    when x"181" => data <= '1' & x"08"; -- data
                    when x"182" => data <= "011111111"; -- i2c stop
        
                    when x"183" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"184" => data <= '1' & x"58"; -- reg HI
                    when x"185" => data <= '1' & x"0b"; -- reg LO
                    when x"186" => data <= '1' & x"0d"; -- data
                    when x"187" => data <= "011111111"; -- i2c stop
        
                    when x"188" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"189" => data <= '1' & x"58"; -- reg HI
                    when x"18a" => data <= '1' & x"0c"; -- reg LO
                    when x"18b" => data <= '1' & x"08"; -- data
                    when x"18c" => data <= "011111111"; -- i2c stop
        
                    when x"18d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"18e" => data <= '1' & x"58"; -- reg HI
                    when x"18f" => data <= '1' & x"0d"; -- reg LO
                    when x"190" => data <= '1' & x"03"; -- data
                    when x"191" => data <= "011111111"; -- i2c stop
        
                    when x"192" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"193" => data <= '1' & x"58"; -- reg HI
                    when x"194" => data <= '1' & x"0e"; -- reg LO
                    when x"195" => data <= '1' & x"00"; -- data
                    when x"196" => data <= "011111111"; -- i2c stop
        
                    when x"197" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"198" => data <= '1' & x"58"; -- reg HI
                    when x"199" => data <= '1' & x"0f"; -- reg LO
                    when x"19a" => data <= '1' & x"00"; -- data
                    when x"19b" => data <= "011111111"; -- i2c stop
        
                    when x"19c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"19d" => data <= '1' & x"58"; -- reg HI
                    when x"19e" => data <= '1' & x"10"; -- reg LO
                    when x"19f" => data <= '1' & x"03"; -- data
                    when x"1a0" => data <= "011111111"; -- i2c stop
        
                    when x"1a1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1a2" => data <= '1' & x"58"; -- reg HI
                    when x"1a3" => data <= '1' & x"11"; -- reg LO
                    when x"1a4" => data <= '1' & x"09"; -- data
                    when x"1a5" => data <= "011111111"; -- i2c stop
        
                    when x"1a6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1a7" => data <= '1' & x"58"; -- reg HI
                    when x"1a8" => data <= '1' & x"12"; -- reg LO
                    when x"1a9" => data <= '1' & x"07"; -- data
                    when x"1aa" => data <= "011111111"; -- i2c stop
        
                    when x"1ab" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1ac" => data <= '1' & x"58"; -- reg HI
                    when x"1ad" => data <= '1' & x"13"; -- reg LO
                    when x"1ae" => data <= '1' & x"03"; -- data
                    when x"1af" => data <= "011111111"; -- i2c stop
        
                    when x"1b0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1b1" => data <= '1' & x"58"; -- reg HI
                    when x"1b2" => data <= '1' & x"14"; -- reg LO
                    when x"1b3" => data <= '1' & x"00"; -- data
                    when x"1b4" => data <= "011111111"; -- i2c stop
        
                    when x"1b5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1b6" => data <= '1' & x"58"; -- reg HI
                    when x"1b7" => data <= '1' & x"15"; -- reg LO
                    when x"1b8" => data <= '1' & x"01"; -- data
                    when x"1b9" => data <= "011111111"; -- i2c stop
        
                    when x"1ba" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1bb" => data <= '1' & x"58"; -- reg HI
                    when x"1bc" => data <= '1' & x"16"; -- reg LO
                    when x"1bd" => data <= '1' & x"03"; -- data
                    when x"1be" => data <= "011111111"; -- i2c stop
        
                    when x"1bf" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1c0" => data <= '1' & x"58"; -- reg HI
                    when x"1c1" => data <= '1' & x"17"; -- reg LO
                    when x"1c2" => data <= '1' & x"08"; -- data
                    when x"1c3" => data <= "011111111"; -- i2c stop
        
                    when x"1c4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1c5" => data <= '1' & x"58"; -- reg HI
                    when x"1c6" => data <= '1' & x"18"; -- reg LO
                    when x"1c7" => data <= '1' & x"0d"; -- data
                    when x"1c8" => data <= "011111111"; -- i2c stop
        
                    when x"1c9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1ca" => data <= '1' & x"58"; -- reg HI
                    when x"1cb" => data <= '1' & x"19"; -- reg LO
                    when x"1cc" => data <= '1' & x"08"; -- data
                    when x"1cd" => data <= "011111111"; -- i2c stop
        
                    when x"1ce" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1cf" => data <= '1' & x"58"; -- reg HI
                    when x"1d0" => data <= '1' & x"1a"; -- reg LO
                    when x"1d1" => data <= '1' & x"05"; -- data
                    when x"1d2" => data <= "011111111"; -- i2c stop
        
                    when x"1d3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1d4" => data <= '1' & x"58"; -- reg HI
                    when x"1d5" => data <= '1' & x"1b"; -- reg LO
                    when x"1d6" => data <= '1' & x"06"; -- data
                    when x"1d7" => data <= "011111111"; -- i2c stop
        
                    when x"1d8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1d9" => data <= '1' & x"58"; -- reg HI
                    when x"1da" => data <= '1' & x"1c"; -- reg LO
                    when x"1db" => data <= '1' & x"08"; -- data
                    when x"1dc" => data <= "011111111"; -- i2c stop
        
                    when x"1dd" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1de" => data <= '1' & x"58"; -- reg HI
                    when x"1df" => data <= '1' & x"1d"; -- reg LO
                    when x"1e0" => data <= '1' & x"0e"; -- data
                    when x"1e1" => data <= "011111111"; -- i2c stop
        
                    when x"1e2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1e3" => data <= '1' & x"58"; -- reg HI
                    when x"1e4" => data <= '1' & x"1e"; -- reg LO
                    when x"1e5" => data <= '1' & x"29"; -- data
                    when x"1e6" => data <= "011111111"; -- i2c stop
        
                    when x"1e7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1e8" => data <= '1' & x"58"; -- reg HI
                    when x"1e9" => data <= '1' & x"1f"; -- reg LO
                    when x"1ea" => data <= '1' & x"17"; -- data
                    when x"1eb" => data <= "011111111"; -- i2c stop
        
                    when x"1ec" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1ed" => data <= '1' & x"58"; -- reg HI
                    when x"1ee" => data <= '1' & x"20"; -- reg LO
                    when x"1ef" => data <= '1' & x"11"; -- data
                    when x"1f0" => data <= "011111111"; -- i2c stop
        
                    when x"1f1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1f2" => data <= '1' & x"58"; -- reg HI
                    when x"1f3" => data <= '1' & x"21"; -- reg LO
                    when x"1f4" => data <= '1' & x"11"; -- data
                    when x"1f5" => data <= "011111111"; -- i2c stop
        
                    when x"1f6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1f7" => data <= '1' & x"58"; -- reg HI
                    when x"1f8" => data <= '1' & x"22"; -- reg LO
                    when x"1f9" => data <= '1' & x"15"; -- data
                    when x"1fa" => data <= "011111111"; -- i2c stop
        
                    when x"1fb" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"1fc" => data <= '1' & x"58"; -- reg HI
                    when x"1fd" => data <= '1' & x"23"; -- reg LO
                    when x"1fe" => data <= '1' & x"28"; -- data
                    when x"1ff" => data <= "011111111"; -- i2c stop
        
                    when x"200" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"201" => data <= '1' & x"58"; -- reg HI
                    when x"202" => data <= '1' & x"24"; -- reg LO
                    when x"203" => data <= '1' & x"46"; -- data
                    when x"204" => data <= "011111111"; -- i2c stop
        
                    when x"205" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"206" => data <= '1' & x"58"; -- reg HI
                    when x"207" => data <= '1' & x"25"; -- reg LO
                    when x"208" => data <= '1' & x"26"; -- data
                    when x"209" => data <= "011111111"; -- i2c stop
        
                    when x"20a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"20b" => data <= '1' & x"58"; -- reg HI
                    when x"20c" => data <= '1' & x"26"; -- reg LO
                    when x"20d" => data <= '1' & x"08"; -- data
                    when x"20e" => data <= "011111111"; -- i2c stop
        
                    when x"20f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"210" => data <= '1' & x"58"; -- reg HI
                    when x"211" => data <= '1' & x"27"; -- reg LO
                    when x"212" => data <= '1' & x"26"; -- data
                    when x"213" => data <= "011111111"; -- i2c stop
        
                    when x"214" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"215" => data <= '1' & x"58"; -- reg HI
                    when x"216" => data <= '1' & x"28"; -- reg LO
                    when x"217" => data <= '1' & x"64"; -- data
                    when x"218" => data <= "011111111"; -- i2c stop
        
                    when x"219" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"21a" => data <= '1' & x"58"; -- reg HI
                    when x"21b" => data <= '1' & x"29"; -- reg LO
                    when x"21c" => data <= '1' & x"26"; -- data
                    when x"21d" => data <= "011111111"; -- i2c stop
        
                    when x"21e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"21f" => data <= '1' & x"58"; -- reg HI
                    when x"220" => data <= '1' & x"2a"; -- reg LO
                    when x"221" => data <= '1' & x"24"; -- data
                    when x"222" => data <= "011111111"; -- i2c stop
        
                    when x"223" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"224" => data <= '1' & x"58"; -- reg HI
                    when x"225" => data <= '1' & x"2b"; -- reg LO
                    when x"226" => data <= '1' & x"22"; -- data
                    when x"227" => data <= "011111111"; -- i2c stop
        
                    when x"228" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"229" => data <= '1' & x"58"; -- reg HI
                    when x"22a" => data <= '1' & x"2c"; -- reg LO
                    when x"22b" => data <= '1' & x"24"; -- data
                    when x"22c" => data <= "011111111"; -- i2c stop
        
                    when x"22d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"22e" => data <= '1' & x"58"; -- reg HI
                    when x"22f" => data <= '1' & x"2d"; -- reg LO
                    when x"230" => data <= '1' & x"24"; -- data
                    when x"231" => data <= "011111111"; -- i2c stop
        
                    when x"232" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"233" => data <= '1' & x"58"; -- reg HI
                    when x"234" => data <= '1' & x"2e"; -- reg LO
                    when x"235" => data <= '1' & x"06"; -- data
                    when x"236" => data <= "011111111"; -- i2c stop
        
                    when x"237" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"238" => data <= '1' & x"58"; -- reg HI
                    when x"239" => data <= '1' & x"2f"; -- reg LO
                    when x"23a" => data <= '1' & x"22"; -- data
                    when x"23b" => data <= "011111111"; -- i2c stop
        
                    when x"23c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"23d" => data <= '1' & x"58"; -- reg HI
                    when x"23e" => data <= '1' & x"30"; -- reg LO
                    when x"23f" => data <= '1' & x"40"; -- data
                    when x"240" => data <= "011111111"; -- i2c stop
        
                    when x"241" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"242" => data <= '1' & x"58"; -- reg HI
                    when x"243" => data <= '1' & x"31"; -- reg LO
                    when x"244" => data <= '1' & x"42"; -- data
                    when x"245" => data <= "011111111"; -- i2c stop
        
                    when x"246" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"247" => data <= '1' & x"58"; -- reg HI
                    when x"248" => data <= '1' & x"32"; -- reg LO
                    when x"249" => data <= '1' & x"24"; -- data
                    when x"24a" => data <= "011111111"; -- i2c stop
        
                    when x"24b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"24c" => data <= '1' & x"58"; -- reg HI
                    when x"24d" => data <= '1' & x"33"; -- reg LO
                    when x"24e" => data <= '1' & x"26"; -- data
                    when x"24f" => data <= "011111111"; -- i2c stop
        
                    when x"250" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"251" => data <= '1' & x"58"; -- reg HI
                    when x"252" => data <= '1' & x"34"; -- reg LO
                    when x"253" => data <= '1' & x"24"; -- data
                    when x"254" => data <= "011111111"; -- i2c stop
        
                    when x"255" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"256" => data <= '1' & x"58"; -- reg HI
                    when x"257" => data <= '1' & x"35"; -- reg LO
                    when x"258" => data <= '1' & x"22"; -- data
                    when x"259" => data <= "011111111"; -- i2c stop
        
                    when x"25a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"25b" => data <= '1' & x"58"; -- reg HI
                    when x"25c" => data <= '1' & x"36"; -- reg LO
                    when x"25d" => data <= '1' & x"22"; -- data
                    when x"25e" => data <= "011111111"; -- i2c stop
        
                    when x"25f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"260" => data <= '1' & x"58"; -- reg HI
                    when x"261" => data <= '1' & x"37"; -- reg LO
                    when x"262" => data <= '1' & x"26"; -- data
                    when x"263" => data <= "011111111"; -- i2c stop
        
                    when x"264" => data <= "011111110"; -- NOP
        
                    when x"265" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"266" => data <= '1' & x"58"; -- reg HI
                    when x"267" => data <= '1' & x"38"; -- reg LO
                    when x"268" => data <= '1' & x"44"; -- data
                    when x"269" => data <= "011111111"; -- i2c stop
        
                    when x"26a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"26b" => data <= '1' & x"58"; -- reg HI
                    when x"26c" => data <= '1' & x"39"; -- reg LO
                    when x"26d" => data <= '1' & x"24"; -- data
                    when x"26e" => data <= "011111111"; -- i2c stop
        
                    when x"26f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"270" => data <= '1' & x"58"; -- reg HI
                    when x"271" => data <= '1' & x"3a"; -- reg LO
                    when x"272" => data <= '1' & x"26"; -- data
                    when x"273" => data <= "011111111"; -- i2c stop
        
                    when x"274" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"275" => data <= '1' & x"58"; -- reg HI
                    when x"276" => data <= '1' & x"3b"; -- reg LO
                    when x"277" => data <= '1' & x"28"; -- data
                    when x"278" => data <= "011111111"; -- i2c stop
        
                    when x"279" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"27a" => data <= '1' & x"58"; -- reg HI
                    when x"27b" => data <= '1' & x"3c"; -- reg LO
                    when x"27c" => data <= '1' & x"42"; -- data
                    when x"27d" => data <= "011111111"; -- i2c stop
        
                    when x"27e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"27f" => data <= '1' & x"58"; -- reg HI
                    when x"280" => data <= '1' & x"3d"; -- reg LO
                    when x"281" => data <= '1' & x"ce"; -- data
                    when x"282" => data <= "011111111"; -- i2c stop
        
                    when x"283" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"284" => data <= '1' & x"51"; -- reg HI
                    when x"285" => data <= '1' & x"80"; -- reg LO
                    when x"286" => data <= '1' & x"ff"; -- data
                    when x"287" => data <= "011111111"; -- i2c stop
        
                    when x"288" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"289" => data <= '1' & x"51"; -- reg HI
                    when x"28a" => data <= '1' & x"81"; -- reg LO
                    when x"28b" => data <= '1' & x"f2"; -- data
                    when x"28c" => data <= "011111111"; -- i2c stop
        
                    when x"28d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"28e" => data <= '1' & x"51"; -- reg HI
                    when x"28f" => data <= '1' & x"82"; -- reg LO
                    when x"290" => data <= '1' & x"00"; -- data
                    when x"291" => data <= "011111111"; -- i2c stop
        
                    when x"292" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"293" => data <= '1' & x"51"; -- reg HI
                    when x"294" => data <= '1' & x"83"; -- reg LO
                    when x"295" => data <= '1' & x"14"; -- data
                    when x"296" => data <= "011111111"; -- i2c stop
        
                    when x"297" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"298" => data <= '1' & x"51"; -- reg HI
                    when x"299" => data <= '1' & x"84"; -- reg LO
                    when x"29a" => data <= '1' & x"25"; -- data
                    when x"29b" => data <= "011111111"; -- i2c stop
        
                    when x"29c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"29d" => data <= '1' & x"51"; -- reg HI
                    when x"29e" => data <= '1' & x"85"; -- reg LO
                    when x"29f" => data <= '1' & x"24"; -- data
                    when x"2a0" => data <= "011111111"; -- i2c stop
        
                    when x"2a1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2a2" => data <= '1' & x"51"; -- reg HI
                    when x"2a3" => data <= '1' & x"86"; -- reg LO
                    when x"2a4" => data <= '1' & x"09"; -- data
                    when x"2a5" => data <= "011111111"; -- i2c stop
        
                    when x"2a6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2a7" => data <= '1' & x"51"; -- reg HI
                    when x"2a8" => data <= '1' & x"87"; -- reg LO
                    when x"2a9" => data <= '1' & x"09"; -- data
                    when x"2aa" => data <= "011111111"; -- i2c stop
        
                    when x"2ab" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2ac" => data <= '1' & x"51"; -- reg HI
                    when x"2ad" => data <= '1' & x"88"; -- reg LO
                    when x"2ae" => data <= '1' & x"09"; -- data
                    when x"2af" => data <= "011111111"; -- i2c stop
        
                    when x"2b0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2b1" => data <= '1' & x"51"; -- reg HI
                    when x"2b2" => data <= '1' & x"89"; -- reg LO
                    when x"2b3" => data <= '1' & x"75"; -- data
                    when x"2b4" => data <= "011111111"; -- i2c stop
        
                    when x"2b5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2b6" => data <= '1' & x"51"; -- reg HI
                    when x"2b7" => data <= '1' & x"8a"; -- reg LO
                    when x"2b8" => data <= '1' & x"54"; -- data
                    when x"2b9" => data <= "011111111"; -- i2c stop
        
                    when x"2ba" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2bb" => data <= '1' & x"51"; -- reg HI
                    when x"2bc" => data <= '1' & x"8b"; -- reg LO
                    when x"2bd" => data <= '1' & x"e0"; -- data
                    when x"2be" => data <= "011111111"; -- i2c stop
        
                    when x"2bf" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2c0" => data <= '1' & x"51"; -- reg HI
                    when x"2c1" => data <= '1' & x"8c"; -- reg LO
                    when x"2c2" => data <= '1' & x"b2"; -- data
                    when x"2c3" => data <= "011111111"; -- i2c stop
        
                    when x"2c4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2c5" => data <= '1' & x"51"; -- reg HI
                    when x"2c6" => data <= '1' & x"8d"; -- reg LO
                    when x"2c7" => data <= '1' & x"42"; -- data
                    when x"2c8" => data <= "011111111"; -- i2c stop
        
                    when x"2c9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2ca" => data <= '1' & x"51"; -- reg HI
                    when x"2cb" => data <= '1' & x"8e"; -- reg LO
                    when x"2cc" => data <= '1' & x"3d"; -- data
                    when x"2cd" => data <= "011111111"; -- i2c stop
        
                    when x"2ce" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2cf" => data <= '1' & x"51"; -- reg HI
                    when x"2d0" => data <= '1' & x"8f"; -- reg LO
                    when x"2d1" => data <= '1' & x"56"; -- data
                    when x"2d2" => data <= "011111111"; -- i2c stop
        
                    when x"2d3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2d4" => data <= '1' & x"51"; -- reg HI
                    when x"2d5" => data <= '1' & x"90"; -- reg LO
                    when x"2d6" => data <= '1' & x"46"; -- data
                    when x"2d7" => data <= "011111111"; -- i2c stop
        
                    when x"2d8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2d9" => data <= '1' & x"51"; -- reg HI
                    when x"2da" => data <= '1' & x"91"; -- reg LO
                    when x"2db" => data <= '1' & x"f8"; -- data
                    when x"2dc" => data <= "011111111"; -- i2c stop
        
                    when x"2dd" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2de" => data <= '1' & x"51"; -- reg HI
                    when x"2df" => data <= '1' & x"92"; -- reg LO
                    when x"2e0" => data <= '1' & x"04"; -- data
                    when x"2e1" => data <= "011111111"; -- i2c stop
        
                    when x"2e2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2e3" => data <= '1' & x"51"; -- reg HI
                    when x"2e4" => data <= '1' & x"93"; -- reg LO
                    when x"2e5" => data <= '1' & x"70"; -- data
                    when x"2e6" => data <= "011111111"; -- i2c stop
        
                    when x"2e7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2e8" => data <= '1' & x"51"; -- reg HI
                    when x"2e9" => data <= '1' & x"94"; -- reg LO
                    when x"2ea" => data <= '1' & x"f0"; -- data
                    when x"2eb" => data <= "011111111"; -- i2c stop
        
                    when x"2ec" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2ed" => data <= '1' & x"51"; -- reg HI
                    when x"2ee" => data <= '1' & x"95"; -- reg LO
                    when x"2ef" => data <= '1' & x"f0"; -- data
                    when x"2f0" => data <= "011111111"; -- i2c stop
        
                    when x"2f1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2f2" => data <= '1' & x"51"; -- reg HI
                    when x"2f3" => data <= '1' & x"96"; -- reg LO
                    when x"2f4" => data <= '1' & x"03"; -- data
                    when x"2f5" => data <= "011111111"; -- i2c stop
        
                    when x"2f6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2f7" => data <= '1' & x"51"; -- reg HI
                    when x"2f8" => data <= '1' & x"97"; -- reg LO
                    when x"2f9" => data <= '1' & x"01"; -- data
                    when x"2fa" => data <= "011111111"; -- i2c stop
        
                    when x"2fb" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"2fc" => data <= '1' & x"51"; -- reg HI
                    when x"2fd" => data <= '1' & x"98"; -- reg LO
                    when x"2fe" => data <= '1' & x"04"; -- data
                    when x"2ff" => data <= "011111111"; -- i2c stop
        
                    when x"300" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"301" => data <= '1' & x"51"; -- reg HI
                    when x"302" => data <= '1' & x"99"; -- reg LO
                    when x"303" => data <= '1' & x"12"; -- data
                    when x"304" => data <= "011111111"; -- i2c stop
        
                    when x"305" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"306" => data <= '1' & x"51"; -- reg HI
                    when x"307" => data <= '1' & x"9a"; -- reg LO
                    when x"308" => data <= '1' & x"04"; -- data
                    when x"309" => data <= "011111111"; -- i2c stop
        
                    when x"30a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"30b" => data <= '1' & x"51"; -- reg HI
                    when x"30c" => data <= '1' & x"9b"; -- reg LO
                    when x"30d" => data <= '1' & x"00"; -- data
                    when x"30e" => data <= "011111111"; -- i2c stop
        
                    when x"30f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"310" => data <= '1' & x"51"; -- reg HI
                    when x"311" => data <= '1' & x"9c"; -- reg LO
                    when x"312" => data <= '1' & x"06"; -- data
                    when x"313" => data <= "011111111"; -- i2c stop
        
                    when x"314" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"315" => data <= '1' & x"51"; -- reg HI
                    when x"316" => data <= '1' & x"9d"; -- reg LO
                    when x"317" => data <= '1' & x"82"; -- data
                    when x"318" => data <= "011111111"; -- i2c stop
        
                    when x"319" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"31a" => data <= '1' & x"51"; -- reg HI
                    when x"31b" => data <= '1' & x"9e"; -- reg LO
                    when x"31c" => data <= '1' & x"38"; -- data
                    when x"31d" => data <= "011111111"; -- i2c stop
        
                    when x"31e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"31f" => data <= '1' & x"54"; -- reg HI
                    when x"320" => data <= '1' & x"80"; -- reg LO
                    when x"321" => data <= '1' & x"01"; -- data
                    when x"322" => data <= "011111111"; -- i2c stop
        
                    when x"323" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"324" => data <= '1' & x"54"; -- reg HI
                    when x"325" => data <= '1' & x"81"; -- reg LO
                    when x"326" => data <= '1' & x"08"; -- data
                    when x"327" => data <= "011111111"; -- i2c stop
        
                    when x"328" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"329" => data <= '1' & x"54"; -- reg HI
                    when x"32a" => data <= '1' & x"82"; -- reg LO
                    when x"32b" => data <= '1' & x"14"; -- data
                    when x"32c" => data <= "011111111"; -- i2c stop
        
                    when x"32d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"32e" => data <= '1' & x"54"; -- reg HI
                    when x"32f" => data <= '1' & x"83"; -- reg LO
                    when x"330" => data <= '1' & x"28"; -- data
                    when x"331" => data <= "011111111"; -- i2c stop
        
                    when x"332" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"333" => data <= '1' & x"54"; -- reg HI
                    when x"334" => data <= '1' & x"84"; -- reg LO
                    when x"335" => data <= '1' & x"51"; -- data
                    when x"336" => data <= "011111111"; -- i2c stop
        
                    when x"337" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"338" => data <= '1' & x"54"; -- reg HI
                    when x"339" => data <= '1' & x"85"; -- reg LO
                    when x"33a" => data <= '1' & x"65"; -- data
                    when x"33b" => data <= "011111111"; -- i2c stop
        
                    when x"33c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"33d" => data <= '1' & x"54"; -- reg HI
                    when x"33e" => data <= '1' & x"86"; -- reg LO
                    when x"33f" => data <= '1' & x"71"; -- data
                    when x"340" => data <= "011111111"; -- i2c stop
        
                    when x"341" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"342" => data <= '1' & x"54"; -- reg HI
                    when x"343" => data <= '1' & x"87"; -- reg LO
                    when x"344" => data <= '1' & x"7d"; -- data
                    when x"345" => data <= "011111111"; -- i2c stop
        
                    when x"346" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"347" => data <= '1' & x"54"; -- reg HI
                    when x"348" => data <= '1' & x"88"; -- reg LO
                    when x"349" => data <= '1' & x"87"; -- data
                    when x"34a" => data <= "011111111"; -- i2c stop
        
                    when x"34b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"34c" => data <= '1' & x"54"; -- reg HI
                    when x"34d" => data <= '1' & x"89"; -- reg LO
                    when x"34e" => data <= '1' & x"91"; -- data
                    when x"34f" => data <= "011111111"; -- i2c stop
        
                    when x"350" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"351" => data <= '1' & x"54"; -- reg HI
                    when x"352" => data <= '1' & x"8a"; -- reg LO
                    when x"353" => data <= '1' & x"9a"; -- data
                    when x"354" => data <= "011111111"; -- i2c stop
        
                    when x"355" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"356" => data <= '1' & x"54"; -- reg HI
                    when x"357" => data <= '1' & x"8b"; -- reg LO
                    when x"358" => data <= '1' & x"aa"; -- data
                    when x"359" => data <= "011111111"; -- i2c stop
        
                    when x"35a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"35b" => data <= '1' & x"54"; -- reg HI
                    when x"35c" => data <= '1' & x"8c"; -- reg LO
                    when x"35d" => data <= '1' & x"b8"; -- data
                    when x"35e" => data <= "011111111"; -- i2c stop
        
                    when x"35f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"360" => data <= '1' & x"54"; -- reg HI
                    when x"361" => data <= '1' & x"8d"; -- reg LO
                    when x"362" => data <= '1' & x"cd"; -- data
                    when x"363" => data <= "011111111"; -- i2c stop
        
                    when x"364" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"365" => data <= '1' & x"54"; -- reg HI
                    when x"366" => data <= '1' & x"8e"; -- reg LO
                    when x"367" => data <= '1' & x"dd"; -- data
                    when x"368" => data <= "011111111"; -- i2c stop
        
                    when x"369" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"36a" => data <= '1' & x"54"; -- reg HI
                    when x"36b" => data <= '1' & x"8f"; -- reg LO
                    when x"36c" => data <= '1' & x"ea"; -- data
                    when x"36d" => data <= "011111111"; -- i2c stop
        
                    when x"36e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"36f" => data <= '1' & x"54"; -- reg HI
                    when x"370" => data <= '1' & x"90"; -- reg LO
                    when x"371" => data <= '1' & x"1d"; -- data
                    when x"372" => data <= "011111111"; -- i2c stop
        
                    when x"373" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"374" => data <= '1' & x"53"; -- reg HI
                    when x"375" => data <= '1' & x"81"; -- reg LO
                    when x"376" => data <= '1' & x"1e"; -- data
                    when x"377" => data <= "011111111"; -- i2c stop
        
                    when x"378" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"379" => data <= '1' & x"53"; -- reg HI
                    when x"37a" => data <= '1' & x"82"; -- reg LO
                    when x"37b" => data <= '1' & x"5b"; -- data
                    when x"37c" => data <= "011111111"; -- i2c stop
        
                    when x"37d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"37e" => data <= '1' & x"53"; -- reg HI
                    when x"37f" => data <= '1' & x"83"; -- reg LO
                    when x"380" => data <= '1' & x"08"; -- data
                    when x"381" => data <= "011111111"; -- i2c stop
        
                    when x"382" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"383" => data <= '1' & x"53"; -- reg HI
                    when x"384" => data <= '1' & x"84"; -- reg LO
                    when x"385" => data <= '1' & x"0a"; -- data
                    when x"386" => data <= "011111111"; -- i2c stop
        
                    when x"387" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"388" => data <= '1' & x"53"; -- reg HI
                    when x"389" => data <= '1' & x"85"; -- reg LO
                    when x"38a" => data <= '1' & x"7e"; -- data
                    when x"38b" => data <= "011111111"; -- i2c stop
        
                    when x"38c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"38d" => data <= '1' & x"53"; -- reg HI
                    when x"38e" => data <= '1' & x"86"; -- reg LO
                    when x"38f" => data <= '1' & x"88"; -- data
                    when x"390" => data <= "011111111"; -- i2c stop
        
                    when x"391" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"392" => data <= '1' & x"53"; -- reg HI
                    when x"393" => data <= '1' & x"87"; -- reg LO
                    when x"394" => data <= '1' & x"7c"; -- data
                    when x"395" => data <= "011111111"; -- i2c stop
        
                    when x"396" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"397" => data <= '1' & x"53"; -- reg HI
                    when x"398" => data <= '1' & x"88"; -- reg LO
                    when x"399" => data <= '1' & x"6c"; -- data
                    when x"39a" => data <= "011111111"; -- i2c stop
        
                    when x"39b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"39c" => data <= '1' & x"53"; -- reg HI
                    when x"39d" => data <= '1' & x"89"; -- reg LO
                    when x"39e" => data <= '1' & x"10"; -- data
                    when x"39f" => data <= "011111111"; -- i2c stop
        
                    when x"3a0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3a1" => data <= '1' & x"53"; -- reg HI
                    when x"3a2" => data <= '1' & x"8a"; -- reg LO
                    when x"3a3" => data <= '1' & x"01"; -- data
                    when x"3a4" => data <= "011111111"; -- i2c stop
        
                    when x"3a5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3a6" => data <= '1' & x"53"; -- reg HI
                    when x"3a7" => data <= '1' & x"8b"; -- reg LO
                    when x"3a8" => data <= '1' & x"98"; -- data
                    when x"3a9" => data <= "011111111"; -- i2c stop
        
                    when x"3aa" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3ab" => data <= '1' & x"55"; -- reg HI
                    when x"3ac" => data <= '1' & x"80"; -- reg LO
                    when x"3ad" => data <= '1' & x"06"; -- data
                    when x"3ae" => data <= "011111111"; -- i2c stop
        
                    when x"3af" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3b0" => data <= '1' & x"55"; -- reg HI
                    when x"3b1" => data <= '1' & x"83"; -- reg LO
                    when x"3b2" => data <= '1' & x"40"; -- data
                    when x"3b3" => data <= "011111111"; -- i2c stop
        
                    when x"3b4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3b5" => data <= '1' & x"55"; -- reg HI
                    when x"3b6" => data <= '1' & x"84"; -- reg LO
                    when x"3b7" => data <= '1' & x"10"; -- data
                    when x"3b8" => data <= "011111111"; -- i2c stop
        
                    when x"3b9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3ba" => data <= '1' & x"55"; -- reg HI
                    when x"3bb" => data <= '1' & x"89"; -- reg LO
                    when x"3bc" => data <= '1' & x"10"; -- data
                    when x"3bd" => data <= "011111111"; -- i2c stop
        
                    when x"3be" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3bf" => data <= '1' & x"55"; -- reg HI
                    when x"3c0" => data <= '1' & x"8a"; -- reg LO
                    when x"3c1" => data <= '1' & x"00"; -- data
                    when x"3c2" => data <= "011111111"; -- i2c stop
        
                    when x"3c3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3c4" => data <= '1' & x"55"; -- reg HI
                    when x"3c5" => data <= '1' & x"8b"; -- reg LO
                    when x"3c6" => data <= '1' & x"f8"; -- data
                    when x"3c7" => data <= "011111111"; -- i2c stop
        
                    when x"3c8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3c9" => data <= '1' & x"50"; -- reg HI
                    when x"3ca" => data <= '1' & x"1d"; -- reg LO
                    when x"3cb" => data <= '1' & x"40"; -- data
                    when x"3cc" => data <= "011111111"; -- i2c stop
        
                    when x"3cd" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3ce" => data <= '1' & x"53"; -- reg HI
                    when x"3cf" => data <= '1' & x"00"; -- reg LO
                    when x"3d0" => data <= '1' & x"08"; -- data
                    when x"3d1" => data <= "011111111"; -- i2c stop
        
                    when x"3d2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3d3" => data <= '1' & x"53"; -- reg HI
                    when x"3d4" => data <= '1' & x"01"; -- reg LO
                    when x"3d5" => data <= '1' & x"30"; -- data
                    when x"3d6" => data <= "011111111"; -- i2c stop
        
                    when x"3d7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3d8" => data <= '1' & x"53"; -- reg HI
                    when x"3d9" => data <= '1' & x"02"; -- reg LO
                    when x"3da" => data <= '1' & x"10"; -- data
                    when x"3db" => data <= "011111111"; -- i2c stop
        
                    when x"3dc" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3dd" => data <= '1' & x"53"; -- reg HI
                    when x"3de" => data <= '1' & x"03"; -- reg LO
                    when x"3df" => data <= '1' & x"00"; -- data
                    when x"3e0" => data <= "011111111"; -- i2c stop
        
                    when x"3e1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3e2" => data <= '1' & x"53"; -- reg HI
                    when x"3e3" => data <= '1' & x"04"; -- reg LO
                    when x"3e4" => data <= '1' & x"08"; -- data
                    when x"3e5" => data <= "011111111"; -- i2c stop
        
                    when x"3e6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3e7" => data <= '1' & x"53"; -- reg HI
                    when x"3e8" => data <= '1' & x"05"; -- reg LO
                    when x"3e9" => data <= '1' & x"30"; -- data
                    when x"3ea" => data <= "011111111"; -- i2c stop
        
                    when x"3eb" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3ec" => data <= '1' & x"53"; -- reg HI
                    when x"3ed" => data <= '1' & x"06"; -- reg LO
                    when x"3ee" => data <= '1' & x"08"; -- data
                    when x"3ef" => data <= "011111111"; -- i2c stop
        
                    when x"3f0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3f1" => data <= '1' & x"53"; -- reg HI
                    when x"3f2" => data <= '1' & x"07"; -- reg LO
                    when x"3f3" => data <= '1' & x"16"; -- data
                    when x"3f4" => data <= "011111111"; -- i2c stop
        
                    when x"3f5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3f6" => data <= '1' & x"53"; -- reg HI
                    when x"3f7" => data <= '1' & x"09"; -- reg LO
                    when x"3f8" => data <= '1' & x"08"; -- data
                    when x"3f9" => data <= "011111111"; -- i2c stop
        
                    when x"3fa" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"3fb" => data <= '1' & x"53"; -- reg HI
                    when x"3fc" => data <= '1' & x"0a"; -- reg LO
                    when x"3fd" => data <= '1' & x"30"; -- data
                    when x"3fe" => data <= "011111111"; -- i2c stop
        
                    when x"3ff" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"400" => data <= '1' & x"53"; -- reg HI
                    when x"401" => data <= '1' & x"0b"; -- reg LO
                    when x"402" => data <= '1' & x"04"; -- data
                    when x"403" => data <= "011111111"; -- i2c stop
        
                    when x"404" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"405" => data <= '1' & x"53"; -- reg HI
                    when x"406" => data <= '1' & x"0c"; -- reg LO
                    when x"407" => data <= '1' & x"06"; -- data
                    when x"408" => data <= "011111111"; -- i2c stop
        
                    when x"409" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"40a" => data <= '1' & x"50"; -- reg HI
                    when x"40b" => data <= '1' & x"25"; -- reg LO
                    when x"40c" => data <= '1' & x"00"; -- data
                    when x"40d" => data <= "011111111"; -- i2c stop
        
                    when x"40e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"40f" => data <= '1' & x"30"; -- reg HI
                    when x"410" => data <= '1' & x"08"; -- reg LO
                    when x"411" => data <= '1' & x"02"; -- data
                    when x"412" => data <= "011111111"; -- i2c stop
        
                    when x"413" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"414" => data <= '1' & x"47"; -- reg HI
                    when x"415" => data <= '1' & x"40"; -- reg LO
                    when x"416" => data <= '1' & x"21"; -- data
                    when x"417" => data <= "011111111"; -- i2c stop
        
                    -----------------RGB565 MODE 720p 15fps---------------------
        
                    when x"418" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"419" => data <= '1' & x"43"; -- reg HI
                    when x"41a" => data <= '1' & x"00"; -- reg LO
                    when x"41b" => data <= '1' & x"61"; -- data
                    when x"41c" => data <= "011111111"; -- i2c stop
        
                    when x"41d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"41e" => data <= '1' & x"50"; -- reg HI
                    when x"41f" => data <= '1' & x"1f"; -- reg LO
                    when x"420" => data <= '1' & x"01"; -- data
                    when x"421" => data <= "011111111"; -- i2c stop
        
                    when x"422" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"423" => data <= '1' & x"30"; -- reg HI
                    when x"424" => data <= '1' & x"35"; -- reg LO
                    when x"425" => data <= '1' & x"41"; -- data
                    when x"426" => data <= "011111111"; -- i2c stop
        
                    when x"427" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"428" => data <= '1' & x"30"; -- reg HI
                    when x"429" => data <= '1' & x"36"; -- reg LO
                    when x"42a" => data <= '1' & x"69"; -- data
                    when x"42b" => data <= "011111111"; -- i2c stop
        
                    when x"42c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"42d" => data <= '1' & x"3c"; -- reg HI
                    when x"42e" => data <= '1' & x"07"; -- reg LO
                    when x"42f" => data <= '1' & x"07"; -- data
                    when x"430" => data <= "011111111"; -- i2c stop
        
                    when x"431" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"432" => data <= '1' & x"38"; -- reg HI
                    when x"433" => data <= '1' & x"20"; -- reg LO
                    when x"434" => data <= '1' & x"46"; -- data
                    when x"435" => data <= "011111111"; -- i2c stop
        
                    when x"436" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"437" => data <= '1' & x"38"; -- reg HI
                    when x"438" => data <= '1' & x"21"; -- reg LO
                    when x"439" => data <= '1' & x"00"; -- data
                    when x"43a" => data <= "011111111"; -- i2c stop
        
                    when x"43b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"43c" => data <= '1' & x"38"; -- reg HI
                    when x"43d" => data <= '1' & x"14"; -- reg LO
                    when x"43e" => data <= '1' & x"31"; -- data
                    when x"43f" => data <= "011111111"; -- i2c stop
        
                    when x"440" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"441" => data <= '1' & x"38"; -- reg HI
                    when x"442" => data <= '1' & x"15"; -- reg LO
                    when x"443" => data <= '1' & x"31"; -- data
                    when x"444" => data <= "011111111"; -- i2c stop
        
                    when x"445" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"446" => data <= '1' & x"38"; -- reg HI
                    when x"447" => data <= '1' & x"00"; -- reg LO
                    when x"448" => data <= '1' & x"00"; -- data
                    when x"449" => data <= "011111111"; -- i2c stop
        
                    when x"44a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"44b" => data <= '1' & x"38"; -- reg HI
                    when x"44c" => data <= '1' & x"01"; -- reg LO
                    when x"44d" => data <= '1' & x"00"; -- data
                    when x"44e" => data <= "011111111"; -- i2c stop
        
                    when x"44f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"450" => data <= '1' & x"38"; -- reg HI
                    when x"451" => data <= '1' & x"02"; -- reg LO
                    when x"452" => data <= '1' & x"00"; -- data
                    when x"453" => data <= "011111111"; -- i2c stop
        
                    when x"454" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"455" => data <= '1' & x"38"; -- reg HI
                    when x"456" => data <= '1' & x"03"; -- reg LO
                    when x"457" => data <= '1' & x"00"; -- data
                    when x"458" => data <= "011111111"; -- i2c stop
        
                    when x"459" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"45a" => data <= '1' & x"38"; -- reg HI
                    when x"45b" => data <= '1' & x"04"; -- reg LO
                    when x"45c" => data <= '1' & x"0a"; -- data
                    when x"45d" => data <= "011111111"; -- i2c stop
        
                    when x"45e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"45f" => data <= '1' & x"38"; -- reg HI
                    when x"460" => data <= '1' & x"05"; -- reg LO
                    when x"461" => data <= '1' & x"3f"; -- data
                    when x"462" => data <= "011111111"; -- i2c stop
        
                    when x"463" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"464" => data <= '1' & x"38"; -- reg HI
                    when x"465" => data <= '1' & x"06"; -- reg LO
                    when x"466" => data <= '1' & x"06"; -- data
                    when x"467" => data <= "011111111"; -- i2c stop
        
                    when x"468" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"469" => data <= '1' & x"38"; -- reg HI
                    when x"46a" => data <= '1' & x"07"; -- reg LO
                    when x"46b" => data <= '1' & x"a9"; -- data
                    when x"46c" => data <= "011111111"; -- i2c stop
        
                    when x"46d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"46e" => data <= '1' & x"38"; -- reg HI
                    when x"46f" => data <= '1' & x"08"; -- reg LO
                    when x"470" => data <= '1' & x"05"; -- data
                    when x"471" => data <= "011111111"; -- i2c stop
        
                    when x"472" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"473" => data <= '1' & x"38"; -- reg HI
                    when x"474" => data <= '1' & x"09"; -- reg LO
                    when x"475" => data <= '1' & x"00"; -- data
                    when x"476" => data <= "011111111"; -- i2c stop
        
                    when x"477" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"478" => data <= '1' & x"38"; -- reg HI
                    when x"479" => data <= '1' & x"0a"; -- reg LO
                    when x"47a" => data <= '1' & x"02"; -- data
                    when x"47b" => data <= "011111111"; -- i2c stop
        
                    when x"47c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"47d" => data <= '1' & x"38"; -- reg HI
                    when x"47e" => data <= '1' & x"0b"; -- reg LO
                    when x"47f" => data <= '1' & x"d0"; -- data
                    when x"480" => data <= "011111111"; -- i2c stop
        
                    when x"481" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"482" => data <= '1' & x"38"; -- reg HI
                    when x"483" => data <= '1' & x"0c"; -- reg LO
                    when x"484" => data <= '1' & x"05"; -- data
                    when x"485" => data <= "011111111"; -- i2c stop
        
                    when x"486" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"487" => data <= '1' & x"38"; -- reg HI
                    when x"488" => data <= '1' & x"0d"; -- reg LO
                    when x"489" => data <= '1' & x"f8"; -- data
                    when x"48a" => data <= "011111111"; -- i2c stop
        
                    when x"48b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"48c" => data <= '1' & x"38"; -- reg HI
                    when x"48d" => data <= '1' & x"0e"; -- reg LO
                    when x"48e" => data <= '1' & x"03"; -- data
                    when x"48f" => data <= "011111111"; -- i2c stop
        
                    when x"490" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"491" => data <= '1' & x"38"; -- reg HI
                    when x"492" => data <= '1' & x"0f"; -- reg LO
                    when x"493" => data <= '1' & x"84"; -- data
                    when x"494" => data <= "011111111"; -- i2c stop
        
                    when x"495" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"496" => data <= '1' & x"38"; -- reg HI
                    when x"497" => data <= '1' & x"13"; -- reg LO
                    when x"498" => data <= '1' & x"04"; -- data
                    when x"499" => data <= "011111111"; -- i2c stop
        
                    when x"49a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"49b" => data <= '1' & x"36"; -- reg HI
                    when x"49c" => data <= '1' & x"18"; -- reg LO
                    when x"49d" => data <= '1' & x"00"; -- data
                    when x"49e" => data <= "011111111"; -- i2c stop
        
                    when x"49f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4a0" => data <= '1' & x"36"; -- reg HI
                    when x"4a1" => data <= '1' & x"12"; -- reg LO
                    when x"4a2" => data <= '1' & x"29"; -- data
                    when x"4a3" => data <= "011111111"; -- i2c stop
        
                    when x"4a4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4a5" => data <= '1' & x"37"; -- reg HI
                    when x"4a6" => data <= '1' & x"09"; -- reg LO
                    when x"4a7" => data <= '1' & x"52"; -- data
                    when x"4a8" => data <= "011111111"; -- i2c stop
        
                    when x"4a9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4aa" => data <= '1' & x"37"; -- reg HI
                    when x"4ab" => data <= '1' & x"0c"; -- reg LO
                    when x"4ac" => data <= '1' & x"03"; -- data
                    when x"4ad" => data <= "011111111"; -- i2c stop
        
                    when x"4ae" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4af" => data <= '1' & x"3a"; -- reg HI
                    when x"4b0" => data <= '1' & x"02"; -- reg LO
                    when x"4b1" => data <= '1' & x"02"; -- data
                    when x"4b2" => data <= "011111111"; -- i2c stop
        
                    when x"4b3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4b4" => data <= '1' & x"3a"; -- reg HI
                    when x"4b5" => data <= '1' & x"03"; -- reg LO
                    when x"4b6" => data <= '1' & x"e0"; -- data
                    when x"4b7" => data <= "011111111"; -- i2c stop
        
                    when x"4b8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4b9" => data <= '1' & x"3a"; -- reg HI
                    when x"4ba" => data <= '1' & x"14"; -- reg LO
                    when x"4bb" => data <= '1' & x"02"; -- data
                    when x"4bc" => data <= "011111111"; -- i2c stop
        
                    when x"4bd" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4be" => data <= '1' & x"3a"; -- reg HI
                    when x"4bf" => data <= '1' & x"15"; -- reg LO
                    when x"4c0" => data <= '1' & x"e0"; -- data
                    when x"4c1" => data <= "011111111"; -- i2c stop
        
                    when x"4c2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4c3" => data <= '1' & x"40"; -- reg HI
                    when x"4c4" => data <= '1' & x"04"; -- reg LO
                    when x"4c5" => data <= '1' & x"02"; -- data
                    when x"4c6" => data <= "011111111"; -- i2c stop
        
                    when x"4c7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4c8" => data <= '1' & x"30"; -- reg HI
                    when x"4c9" => data <= '1' & x"02"; -- reg LO
                    when x"4ca" => data <= '1' & x"1c"; -- data
                    when x"4cb" => data <= "011111111"; -- i2c stop
        
                    when x"4cc" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4cd" => data <= '1' & x"30"; -- reg HI
                    when x"4ce" => data <= '1' & x"06"; -- reg LO
                    when x"4cf" => data <= '1' & x"c3"; -- data
                    when x"4d0" => data <= "011111111"; -- i2c stop
        
                    when x"4d1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4d2" => data <= '1' & x"47"; -- reg HI
                    when x"4d3" => data <= '1' & x"13"; -- reg LO
                    when x"4d4" => data <= '1' & x"01"; -- data
                    when x"4d5" => data <= "011111111"; -- i2c stop
        
                    when x"4d6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4d7" => data <= '1' & x"44"; -- reg HI
                    when x"4d8" => data <= '1' & x"07"; -- reg LO
                    when x"4d9" => data <= '1' & x"04"; -- data
                    when x"4da" => data <= "011111111"; -- i2c stop
        
                    when x"4db" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4dc" => data <= '1' & x"46"; -- reg HI
                    when x"4dd" => data <= '1' & x"0b"; -- reg LO
                    when x"4de" => data <= '1' & x"37"; -- data
                    when x"4df" => data <= "011111111"; -- i2c stop
        
                    when x"4e0" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4e1" => data <= '1' & x"46"; -- reg HI
                    when x"4e2" => data <= '1' & x"0c"; -- reg LO
                    when x"4e3" => data <= '1' & x"20"; -- data
                    when x"4e4" => data <= "011111111"; -- i2c stop
        
                    when x"4e5" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4e6" => data <= '1' & x"48"; -- reg HI
                    when x"4e7" => data <= '1' & x"37"; -- reg LO
                    when x"4e8" => data <= '1' & x"16"; -- data
                    when x"4e9" => data <= "011111111"; -- i2c stop
        
                    when x"4ea" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4eb" => data <= '1' & x"38"; -- reg HI
                    when x"4ec" => data <= '1' & x"24"; -- reg LO
                    when x"4ed" => data <= '1' & x"04"; -- data
                    when x"4ee" => data <= "011111111"; -- i2c stop
        
                    when x"4ef" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4f0" => data <= '1' & x"50"; -- reg HI
                    when x"4f1" => data <= '1' & x"01"; -- reg LO
                    when x"4f2" => data <= '1' & x"a3"; -- data
                    when x"4f3" => data <= "011111111"; -- i2c stop
        
                    when x"4f4" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4f5" => data <= '1' & x"35"; -- reg HI
                    when x"4f6" => data <= '1' & x"03"; -- reg LO
                    when x"4f7" => data <= '1' & x"00"; -- data
                    when x"4f8" => data <= "011111111"; -- i2c stop
                    
                    ----------------------light mode---------------------------
                    
                    when x"4f9" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4fa" => data <= '1' & x"32"; -- reg HI
                    when x"4fb" => data <= '1' & x"12"; -- reg LO
                    when x"4fc" => data <= '1' & x"03"; -- data
                    when x"4fd" => data <= "011111111"; -- i2c stop
        
                    when x"4fe" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"4ff" => data <= '1' & x"34"; -- reg HI
                    when x"500" => data <= '1' & x"00"; -- reg LO
                    when x"501" => data <= '1' & x"04"; -- data
                    when x"502" => data <= "011111111"; -- i2c stop
        
                    when x"503" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"504" => data <= '1' & x"34"; -- reg HI
                    when x"505" => data <= '1' & x"01"; -- reg LO
                    when x"506" => data <= '1' & x"00"; -- data
                    when x"507" => data <= "011111111"; -- i2c stop
        
                    when x"508" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"509" => data <= '1' & x"34"; -- reg HI
                    when x"50a" => data <= '1' & x"02"; -- reg LO
                    when x"50b" => data <= '1' & x"04"; -- data
                    when x"50c" => data <= "011111111"; -- i2c stop
        
                    when x"50d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"50e" => data <= '1' & x"34"; -- reg HI
                    when x"50f" => data <= '1' & x"03"; -- reg LO
                    when x"510" => data <= '1' & x"00"; -- data
                    when x"511" => data <= "011111111"; -- i2c stop
        
                    when x"512" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"513" => data <= '1' & x"34"; -- reg HI
                    when x"514" => data <= '1' & x"04"; -- reg LO
                    when x"515" => data <= '1' & x"04"; -- data
                    when x"516" => data <= "011111111"; -- i2c stop
        
                    when x"517" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"518" => data <= '1' & x"34"; -- reg HI
                    when x"519" => data <= '1' & x"05"; -- reg LO
                    when x"51a" => data <= '1' & x"00"; -- data
                    when x"51b" => data <= "011111111"; -- i2c stop
        
                    when x"51c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"51d" => data <= '1' & x"34"; -- reg HI
                    when x"51e" => data <= '1' & x"06"; -- reg LO
                    when x"51f" => data <= '1' & x"00"; -- data
                    when x"520" => data <= "011111111"; -- i2c stop
        
                    when x"521" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"522" => data <= '1' & x"32"; -- reg HI
                    when x"523" => data <= '1' & x"12"; -- reg LO
                    when x"524" => data <= '1' & x"13"; -- data
                    when x"525" => data <= "011111111"; -- i2c stop
        
                    when x"526" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"527" => data <= '1' & x"32"; -- reg HI
                    when x"528" => data <= '1' & x"12"; -- reg LO
                    when x"529" => data <= '1' & x"a3"; -- data
                    when x"52a" => data <= "011111111"; -- i2c stop
        
                    when x"52b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"52c" => data <= '1' & x"32"; -- reg HI
                    when x"52d" => data <= '1' & x"12"; -- reg LO
                    when x"52e" => data <= '1' & x"03"; -- data
                    when x"52f" => data <= "011111111"; -- i2c stop
        
                    when x"530" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"531" => data <= '1' & x"53"; -- reg HI
                    when x"532" => data <= '1' & x"81"; -- reg LO
                    when x"533" => data <= '1' & x"1c"; -- data
                    when x"534" => data <= "011111111"; -- i2c stop
        
                    when x"535" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"536" => data <= '1' & x"53"; -- reg HI
                    when x"537" => data <= '1' & x"82"; -- reg LO
                    when x"538" => data <= '1' & x"5a"; -- data
                    when x"539" => data <= "011111111"; -- i2c stop
        
                    when x"53a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"53b" => data <= '1' & x"53"; -- reg HI
                    when x"53c" => data <= '1' & x"83"; -- reg LO
                    when x"53d" => data <= '1' & x"06"; -- data
                    when x"53e" => data <= "011111111"; -- i2c stop
        
                    when x"53f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"540" => data <= '1' & x"53"; -- reg HI
                    when x"541" => data <= '1' & x"84"; -- reg LO
                    when x"542" => data <= '1' & x"1a"; -- data
                    when x"543" => data <= "011111111"; -- i2c stop
        
                    when x"544" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"545" => data <= '1' & x"53"; -- reg HI
                    when x"546" => data <= '1' & x"85"; -- reg LO
                    when x"547" => data <= '1' & x"66"; -- data
                    when x"548" => data <= "011111111"; -- i2c stop
        
                    when x"549" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"54a" => data <= '1' & x"53"; -- reg HI
                    when x"54b" => data <= '1' & x"86"; -- reg LO
                    when x"54c" => data <= '1' & x"80"; -- data
                    when x"54d" => data <= "011111111"; -- i2c stop
        
                    when x"54e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"54f" => data <= '1' & x"53"; -- reg HI
                    when x"550" => data <= '1' & x"87"; -- reg LO
                    when x"551" => data <= '1' & x"82"; -- data
                    when x"552" => data <= "011111111"; -- i2c stop
        
                    when x"553" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"554" => data <= '1' & x"53"; -- reg HI
                    when x"555" => data <= '1' & x"88"; -- reg LO
                    when x"556" => data <= '1' & x"80"; -- data
                    when x"557" => data <= "011111111"; -- i2c stop
        
                    when x"558" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"559" => data <= '1' & x"53"; -- reg HI
                    when x"55a" => data <= '1' & x"89"; -- reg LO
                    when x"55b" => data <= '1' & x"02"; -- data
                    when x"55c" => data <= "011111111"; -- i2c stop
        
                    when x"55d" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"55e" => data <= '1' & x"53"; -- reg HI
                    when x"55f" => data <= '1' & x"8b"; -- reg LO
                    when x"560" => data <= '1' & x"98"; -- data
                    when x"561" => data <= "011111111"; -- i2c stop
        
                    when x"562" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"563" => data <= '1' & x"53"; -- reg HI
                    when x"564" => data <= '1' & x"8a"; -- reg LO
                    when x"565" => data <= '1' & x"01"; -- data
                    when x"566" => data <= "011111111"; -- i2c stop
        
                    when x"567" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"568" => data <= '1' & x"32"; -- reg HI
                    when x"569" => data <= '1' & x"12"; -- reg LO
                    when x"56a" => data <= '1' & x"13"; -- data
                    when x"56b" => data <= "011111111"; -- i2c stop
        
                    when x"56c" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"56d" => data <= '1' & x"32"; -- reg HI
                    when x"56e" => data <= '1' & x"12"; -- reg LO
                    when x"56f" => data <= '1' & x"a3"; -- data
                    when x"570" => data <= "011111111"; -- i2c stop
        
                    when x"571" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"572" => data <= '1' & x"32"; -- reg HI
                    when x"573" => data <= '1' & x"12"; -- reg LO
                    when x"574" => data <= '1' & x"03"; -- data
                    when x"575" => data <= "011111111"; -- i2c stop
        
                    when x"576" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"577" => data <= '1' & x"55"; -- reg HI
                    when x"578" => data <= '1' & x"87"; -- reg LO
                    when x"579" => data <= '1' & x"00"; -- data
                    when x"57a" => data <= "011111111"; -- i2c stop
        
                    when x"57b" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"57c" => data <= '1' & x"55"; -- reg HI
                    when x"57d" => data <= '1' & x"88"; -- reg LO
                    when x"57e" => data <= '1' & x"01"; -- data
                    when x"57f" => data <= "011111111"; -- i2c stop
        
                    when x"580" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"581" => data <= '1' & x"32"; -- reg HI
                    when x"582" => data <= '1' & x"12"; -- reg LO
                    when x"583" => data <= '1' & x"13"; -- data
                    when x"584" => data <= "011111111"; -- i2c stop
        
                    when x"585" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"586" => data <= '1' & x"32"; -- reg HI
                    when x"587" => data <= '1' & x"12"; -- reg LO
                    when x"588" => data <= '1' & x"a3"; -- data
                    when x"589" => data <= "011111111"; -- i2c stop
        
                    when x"58a" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"58b" => data <= '1' & x"32"; -- reg HI
                    when x"58c" => data <= '1' & x"12"; -- reg LO
                    when x"58d" => data <= '1' & x"03"; -- data
                    when x"58e" => data <= "011111111"; -- i2c stop
        
                    when x"58f" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"590" => data <= '1' & x"55"; -- reg HI
                    when x"591" => data <= '1' & x"85"; -- reg LO
                    when x"592" => data <= '1' & x"00"; -- data
                    when x"593" => data <= "011111111"; -- i2c stop
        
                    when x"594" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"595" => data <= '1' & x"55"; -- reg HI
                    when x"596" => data <= '1' & x"86"; -- reg LO
                    when x"597" => data <= '1' & x"20"; -- data
                    when x"598" => data <= "011111111"; -- i2c stop
        
                    when x"599" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"59a" => data <= '1' & x"32"; -- reg HI
                    when x"59b" => data <= '1' & x"12"; -- reg LO
                    when x"59c" => data <= '1' & x"13"; -- data
                    when x"59d" => data <= "011111111"; -- i2c stop
        
                    when x"59e" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"59f" => data <= '1' & x"32"; -- reg HI
                    when x"5a0" => data <= '1' & x"12"; -- reg LO
                    when x"5a1" => data <= '1' & x"a3"; -- data
                    when x"5a2" => data <= "011111111"; -- i2c stop
        
                    when x"5a3" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5a4" => data <= '1' & x"53"; -- reg HI
                    when x"5a5" => data <= '1' & x"08"; -- reg LO
                    when x"5a6" => data <= '1' & x"25"; -- data
                    when x"5a7" => data <= "011111111"; -- i2c stop
        
                    when x"5a8" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5a9" => data <= '1' & x"53"; -- reg HI
                    when x"5aa" => data <= '1' & x"00"; -- reg LO
                    when x"5ab" => data <= '1' & x"08"; -- data
                    when x"5ac" => data <= "011111111"; -- i2c stop
        
                    when x"5ad" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5ae" => data <= '1' & x"53"; -- reg HI
                    when x"5af" => data <= '1' & x"01"; -- reg LO
                    when x"5b0" => data <= '1' & x"30"; -- data
                    when x"5b1" => data <= "011111111"; -- i2c stop
        
                    when x"5b2" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5b3" => data <= '1' & x"53"; -- reg HI
                    when x"5b4" => data <= '1' & x"02"; -- reg LO
                    when x"5b5" => data <= '1' & x"10"; -- data
                    when x"5b6" => data <= "011111111"; -- i2c stop
        
                    when x"5b7" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5b8" => data <= '1' & x"53"; -- reg HI
                    when x"5b9" => data <= '1' & x"03"; -- reg LO
                    when x"5ba" => data <= '1' & x"00"; -- data
                    when x"5bb" => data <= "011111111"; -- i2c stop
        
                    when x"5bc" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5bd" => data <= '1' & x"53"; -- reg HI
                    when x"5be" => data <= '1' & x"09"; -- reg LO
                    when x"5bf" => data <= '1' & x"08"; -- data
                    when x"5c0" => data <= "011111111"; -- i2c stop
        
                    when x"5c1" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5c2" => data <= '1' & x"53"; -- reg HI
                    when x"5c3" => data <= '1' & x"0a"; -- reg LO
                    when x"5c4" => data <= '1' & x"30"; -- data
                    when x"5c5" => data <= "011111111"; -- i2c stop
        
                    when x"5c6" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5c7" => data <= '1' & x"53"; -- reg HI
                    when x"5c8" => data <= '1' & x"0b"; -- reg LO
                    when x"5c9" => data <= '1' & x"04"; -- data
                    when x"5ca" => data <= "011111111"; -- i2c stop
        
                    when x"5cb" => data <= '1' & x"78"; -- OV5640 ADDR (0x78)
                    when x"5cc" => data <= '1' & x"53"; -- reg HI
                    when x"5cd" => data <= '1' & x"0c"; -- reg LO
                    when x"5ce" => data <= '1' & x"06"; -- data
                    when x"5cf" => data <= "011111111"; -- i2c stop 
        
                    -----------------FINISH REGISTER SETUP----------------------
                    when x"5d0" => data <= "010110000"; -- SET LED
                    when x"5d1" => data <= "010000000"; ------SKIP (pc = 0101 1101 0001)
                    when x"5d2" => data <= "000000000"; -- End loop, waiting to reset reg
                    when x"5d3" => data <= "000101110"; ------ JUMP to 0x5d1... when others => data <= "000000000";
        
                    when others => data <= "011111110"; -- NOP
                end case;
                if (counter = x"5d3") then
                    init_done <= '1';
                    counter <= std_logic_vector(unsigned(counter) + 1);
                elsif (counter = x"5d4") then
                    init_done <= '1';
                else
                    counter <= std_logic_vector(unsigned(counter) + 1);
                end if;
            end if;
            
        end if;
    end process;

end Behavioral;
