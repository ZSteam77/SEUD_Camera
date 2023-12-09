----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2023 15:40:08
-- Design Name: 
-- Module Name: camera_controller_top - Behavioral
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
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity camera_controller_top is
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
        siod : inout std_logic
--        next_data_o : out std_logic
    );
end camera_controller_top;

architecture Behavioral of camera_controller_top is
    component camera_controller is
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
    end component;
    
    component camera_configuration is
        Port ( 
    --           address : in std_logic_vector (11 downto 0);
               read_controller : in std_logic;
               nreset : in std_logic;
               sys_clk : in std_logic;
               data : out std_logic_vector (8 downto 0);
               init_done : out std_logic
               );
    end component;
    component sccb is
        port(clk,nreset:iN std_logic;
--                ce:IN std_logic;
                R_W:IN std_logic;
--                address:std_logic_vector(0 downto 0);
                data_in:IN std_logic_vector(31 downto 0);
                data_out:OUT std_logic_vector(31 downto 0);
                s_clk:IN std_logic;
                s_clk_90:IN std_logic;
                sioc:OUT std_logic;
                siod:INOUT std_logic;
		        next_data:OUT std_logic;
		        write_config:IN std_logic);
    end component;
    component tmr_clk_gen
          generic(N:integer:=250);
          port(clk,nreset:IN std_logic;
                clk_div1:OUT std_logic;
                clk_div2:OUT std_logic);
    end component;
    signal next_data, init_done, read_controller, write_config, R_W : std_logic := '0';
    signal data_in_cfg  : std_logic_vector(8 downto 0) := (others => '0');
    signal data_to_send, data_out : std_logic_vector(31 downto 0) := (others => '0');
    signal clk_div1,clk_div2 : std_logic := '0';
begin
    control : camera_controller port map(
        nreset => nreset,
        clk => clk,
        camera_idle => camera_idle,
        next_data => next_data,
        data_in_cfg => data_in_cfg,
        init_done => init_done,
        operation => operation,
        read_controller => read_controller,
        write_config => write_config,
        data_to_send => data_to_send,
        xclk_en => xclk_en,
        cam_reset => cam_reset,
        cam_pwdn => cam_pwdn,
        take_pic => take_pic,
        R_W => R_W
    );
    
    config : camera_configuration port map(
        read_controller => read_controller,
        nreset => nreset,
        sys_clk => clk,
        data => data_in_cfg,
        init_done => init_done
    );
    sccb_send : sccb port map(
        clk => clk,
        nreset => nreset,
        R_W => R_W,
        data_in => data_to_send,
        data_out => data_out,
        s_clk => clk_div1,
        s_clk_90 => clk_div2,
        sioc => sioc,
        siod => siod,
        next_data => next_data,
        write_config => write_config
    );
    clk_gen : tmr_clk_gen port map(
        clk => clk,
        nreset => nreset,
        clk_div1 => clk_div1,
        clk_div2 => clk_div2
    );
--    next_data_o <= next_data;
end Behavioral;
