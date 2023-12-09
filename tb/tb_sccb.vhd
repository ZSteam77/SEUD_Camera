----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2023 21:12:56
-- Design Name: 
-- Module Name: tb_sccb - Behavioral
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
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_sccb is
--  Port ( );
end tb_sccb;

architecture Behavioral of tb_sccb is

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
--                write_config :in std_logic;
--		        next_data:OUT std_logic
                done : out std_logic
		        );
    end component;
    component tmr_clk_gen
          generic(N:integer:=250);
          port(clk,nreset:IN std_logic;
                clk_div1:OUT std_logic;
                clk_div2:OUT std_logic);
    end component;
    signal sioc, siod, clk, done, init_done, read_controller, write_config, R_W, nreset : std_logic := '0';
    signal data_in_cfg  : std_logic_vector(8 downto 0) := (others => '0');
    signal data_to_send, data_out : std_logic_vector(31 downto 0) := (others => '0');
    signal clk_div1,clk_div2 : std_logic := '0';
    
    type arra is array (296 downto 0) of std_logic_vector(31 downto 0);
    signal reference_reg : arra := (
        (x"78310311"),
        (x"78300882"),
        (x"78300842"),
        (x"78310303"),
        (x"783017ff"),
        (x"783018ff"),
        (x"7830341a"),
        (x"78303713"),
        (x"78310801"),
        (x"78363036"),
        (x"7836310e"),
        (x"783632e2"),
        (x"78363312"),
        (x"783621e0"),
        (x"783704a0"),
        (x"7837035a"),
        (x"78371578"),
        (x"78371701"),
        (x"78370b60"),
        (x"7837051a"),
        (x"78390502"),
        (x"78390610"),
        (x"7839010a"),
        (x"78373112"),
        (x"78360008"),
        (x"78360133"),
        (x"78302d60"),
        (x"78362052"),
        (x"78371b20"),
        (x"78471c50"),
        (x"783a1343"),
        (x"783a1800"),
        (x"783a19f8"),
        (x"78363513"),
        (x"78363603"),
        (x"78363440"),
        (x"78362201"),
        (x"783c0134"),
        (x"783c0428"),
        (x"783c0598"),
        (x"783c0600"),
        (x"783c0708"),
        (x"783c0800"),
        (x"783c091c"),
        (x"783c0a9c"),
        (x"783c0b40"),
        (x"78381000"),
        (x"78381110"),
        (x"78381200"),
        (x"78370864"),
        (x"78400102"),
        (x"7840051a"),
        (x"78300000"),
        (x"783004ff"),
        (x"78300e58"),
        (x"78302e00"),
        (x"78430030"),
        (x"78501f00"),
        (x"78440e00"),
        (x"785000a7"),
        (x"783a0f30"),
        (x"783a1028"),
        (x"783a1b30"),
        (x"783a1e26"),
        (x"783a1160"),
        (x"783a1f14"),
        (x"78580023"),
        (x"78580114"),
        (x"7858020f"),
        (x"7858030f"),
        (x"78580412"),
        (x"78580526"),
        (x"7858060c"),
        (x"78580708"),
        (x"78580805"),
        (x"78580905"),
        (x"78580a08"),
        (x"78580b0d"),
        (x"78580c08"),
        (x"78580d03"),
        (x"78580e00"),
        (x"78580f00"),
        (x"78581003"),
        (x"78581109"),
        (x"78581207"),
        (x"78581303"),
        (x"78581400"),
        (x"78581501"),
        (x"78581603"),
        (x"78581708"),
        (x"7858180d"),
        (x"78581908"),
        (x"78581a05"),
        (x"78581b06"),
        (x"78581c08"),
        (x"78581d0e"),
        (x"78581e29"),
        (x"78581f17"),
        (x"78582011"),
        (x"78582111"),
        (x"78582215"),
        (x"78582328"),
        (x"78582446"),
        (x"78582526"),
        (x"78582608"),
        (x"78582726"),
        (x"78582864"),
        (x"78582926"),
        (x"78582a24"),
        (x"78582b22"),
        (x"78582c24"),
        (x"78582d24"),
        (x"78582e06"),
        (x"78582f22"),
        (x"78583040"),
        (x"78583142"),
        (x"78583224"),
        (x"78583326"),
        (x"78583424"),
        (x"78583522"),
        (x"78583622"),
        (x"78583726"),
        (x"78583844"),
        (x"78583924"),
        (x"78583a26"),
        (x"78583b28"),
        (x"78583c42"),
        (x"78583dce"),
        (x"785180ff"),
        (x"785181f2"),
        (x"78518200"),
        (x"78518314"),
        (x"78518425"),
        (x"78518524"),
        (x"78518609"),
        (x"78518709"),
        (x"78518809"),
        (x"78518975"),
        (x"78518a54"),
        (x"78518be0"),
        (x"78518cb2"),
        (x"78518d42"),
        (x"78518e3d"),
        (x"78518f56"),
        (x"78519046"),
        (x"785191f8"),
        (x"78519204"),
        (x"78519370"),
        (x"785194f0"),
        (x"785195f0"),
        (x"78519603"),
        (x"78519701"),
        (x"78519804"),
        (x"78519912"),
        (x"78519a04"),
        (x"78519b00"),
        (x"78519c06"),
        (x"78519d82"),
        (x"78519e38"),
        (x"78548001"),
        (x"78548108"),
        (x"78548214"),
        (x"78548328"),
        (x"78548451"),
        (x"78548565"),
        (x"78548671"),
        (x"7854877d"),
        (x"78548887"),
        (x"78548991"),
        (x"78548a9a"),
        (x"78548baa"),
        (x"78548cb8"),
        (x"78548dcd"),
        (x"78548edd"),
        (x"78548fea"),
        (x"7854901d"),
        (x"7853811e"),
        (x"7853825b"),
        (x"78538308"),
        (x"7853840a"),
        (x"7853857e"),
        (x"78538688"),
        (x"7853877c"),
        (x"7853886c"),
        (x"78538910"),
        (x"78538a01"),
        (x"78538b98"),
        (x"78558006"),
        (x"78558340"),
        (x"78558410"),
        (x"78558910"),
        (x"78558a00"),
        (x"78558bf8"),
        (x"78501d40"),
        (x"78530008"),
        (x"78530130"),
        (x"78530210"),
        (x"78530300"),
        (x"78530408"),
        (x"78530530"),
        (x"78530608"),
        (x"78530716"),
        (x"78530908"),
        (x"78530a30"),
        (x"78530b04"),
        (x"78530c06"),
        (x"78502500"),
        (x"78300802"),
        (x"78474021"),
        (x"78430061"),
        (x"78501f01"),
        (x"78303541"),
        (x"78303669"),
        (x"783c0707"),
        (x"78382046"),
        (x"78382100"),
        (x"78381431"),
        (x"78381531"),
        (x"78380000"),
        (x"78380100"),
        (x"78380200"),
        (x"78380300"),
        (x"7838040a"),
        (x"7838053f"),
        (x"78380606"),
        (x"783807a9"),
        (x"78380805"),
        (x"78380900"),
        (x"78380a02"),
        (x"78380bd0"),
        (x"78380c05"),
        (x"78380df8"),
        (x"78380e03"),
        (x"78380f84"),
        (x"78381304"),
        (x"78361800"),
        (x"78361229"),
        (x"78370952"),
        (x"78370c03"),
        (x"783a0202"),
        (x"783a03e0"),
        (x"783a1402"),
        (x"783a15e0"),
        (x"78400402"),
        (x"7830021c"),
        (x"783006c3"),
        (x"78471301"),
        (x"78440704"),
        (x"78460b37"),
        (x"78460c20"),
        (x"78483716"),
        (x"78382404"),
        (x"785001a3"),
        (x"78350300"),
        (x"78321203"),
        (x"78340004"),
        (x"78340100"),
        (x"78340204"),
        (x"78340300"),
        (x"78340404"),
        (x"78340500"),
        (x"78340600"),
        (x"78321213"),
        (x"783212a3"),
        (x"78321203"),
        (x"7853811c"),
        (x"7853825a"),
        (x"78538306"),
        (x"7853841a"),
        (x"78538566"),
        (x"78538680"),
        (x"78538782"),
        (x"78538880"),
        (x"78538902"),
        (x"78538b98"),
        (x"78538a01"),
        (x"78321213"),
        (x"783212a3"),
        (x"78321203"),
        (x"78558700"),
        (x"78558801"),
        (x"78321213"),
        (x"783212a3"),
        (x"78321203"),
        (x"78558500"),
        (x"78558620"),
        (x"78321213"),
        (x"783212a3"),
        (x"78530825"),
        (x"78530008"),
        (x"78530130"),
        (x"78530210"),
        (x"78530300"),
        (x"78530908"),
        (x"78530a30"),
        (x"78530b04"),
        (x"78530c06")
    );
    signal sioc_data, siod_data : std_logic_vector(40 downto 0) := (others => '0');
    signal flag : std_logic := '0';
begin
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
--        write_config => write_config,
--        next_data => done
        done => done
    );
    clk_gen : tmr_clk_gen port map(
        clk => clk,
        nreset => nreset,
        clk_div1 => clk_div1,
        clk_div2 => clk_div2
    );
    clk <= not clk after 5 ns;
    
    process begin
        nreset <= '0';
        wait for 10 ns;
        nreset <= '1';
        for i in 0 to 296 loop
            wait until (falling_edge(clk));
            flag <= '1';
            data_to_send <= reference_reg(296-i);
            R_W <= '0';
            write_config <= '1';
            wait until (done = '1');
            write_config <= '0';
        end loop;
    end process;
    process (sioc, done) begin
        if rising_edge(sioc) then
--            if (flag = '1') then
--                sioc_data <= sioc_data(299 downto 0) & sioc;
                siod_data <= siod_data(39 downto 0) & siod;
--            end if;
            
        end if;
        if done = '1' then
                sioc_data <= (others => '0');
                siod_data <= (others => '0');
        end if;
    end process;
end Behavioral;
