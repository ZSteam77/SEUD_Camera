library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_emulator is
    generic (
        IMG_WIDTH   : integer := 320;
        IMG_HEIGHT  : integer := 60;
        LOG2_WIDTH  : integer := 9;
        LOG2_HEIGHT : integer := 6;
        TEST_BAR_WIDTH      : integer := 40;    -- IMG_WIDTH / 8
        LOG2_TEST_BAR_WIDTH : integer := 6      -- log2(TEST_BAR_WIDTH)
    );
    port (
        sel_pattern : in std_logic;
        -- DVP interface
        pclk_in     : in std_logic;
        pclk_out    : out std_logic;   
        vsync       : out std_logic := '0';
        href        : out std_logic := '0';
        data        : out std_logic_vector(7 downto 0) := (others => '0')
    );
end camera_emulator;

architecture behavioural of camera_emulator is
    constant TEST_WHITE     : std_logic_vector(15 downto 0) := B"11111_111111_11111"; -- RGB565 0xFFFF
    constant TEST_YELLOW    : std_logic_vector(15 downto 0) := B"11100_111001_00000"; -- RGB565 0xE720
    constant TEST_CIAN      : std_logic_vector(15 downto 0) := B"00000_011001_11001"; -- RGB565 0x0659
    constant TEST_GREEN     : std_logic_vector(15 downto 0) := B"00000_111111_00000"; -- RGB565 0x07E0
    constant TEST_MAGENTA   : std_logic_vector(15 downto 0) := B"11001_001100_11001"; -- RGB565 0xC999
    constant TEST_RED       : std_logic_vector(15 downto 0) := B"11111_000000_00000"; -- RGB565 0xF800
    constant TEST_BLUE      : std_logic_vector(15 downto 0) := B"00000_000000_11111"; -- RGB565 0x001F
    constant TEST_BLACK     : std_logic_vector(15 downto 0) := B"00000_000000_00000"; -- RGB565 0x0000

    type dvp_states is (VSYNC_LOW, PRE_VSYNC_HIGH, HREF_HIGH, HREF_LOW, POST_VSYNC_HIGH); 
    signal pres_dvp_state   : dvp_states := VSYNC_LOW;
    signal clk_counts       : unsigned(19 downto 0) := (others => '0');
    signal line_count       : unsigned(LOG2_HEIGHT-1 downto 0) := (others => '0');
    signal pixelxline_count : unsigned(LOG2_WIDTH-1 downto 0) := (others => '0');
    signal pixel_data       : std_logic_vector(15 downto 0) := (others => '0');
    signal byte_select      : std_logic := '1';
    signal test_pattern     : std_logic := '0';
    signal colour_select : unsigned(2 downto 0) := (others => '0');
    signal test_bar_counter : unsigned(LOG2_TEST_BAR_WIDTH-1 downto 0) := to_unsigned(TEST_BAR_WIDTH-1, LOG2_TEST_BAR_WIDTH);
begin
    pclk_out <= pclk_in;

    signal_generator: process(pclk_in)  
    begin
        if rising_edge(pclk_in) then
            clk_counts <= clk_counts + 1;
            case pres_dvp_state is
                when VSYNC_LOW =>
                    --if clk_counts = 5880 then -- 140us @ 42MHz => 5880
                    if clk_counts = 840 then -- 20us @ 42MHz => 840
                        test_pattern <= sel_pattern; -- Sample pattern selection input
                        pres_dvp_state <= PRE_VSYNC_HIGH;
                        clk_counts <= (others => '0');
                        vsync <= '1';
                        href <= '0';
                    else
                        clk_counts <= clk_counts + 1;
                    end if;                
                when PRE_VSYNC_HIGH =>
                    line_count <= (others => '0');
                    pixelxline_count <= (others => '0');
                    if test_pattern = '0' then
                        pixel_data <= (others => '0');
                    else
                        pixel_data <= TEST_WHITE;
                        test_bar_counter <= to_unsigned(TEST_BAR_WIDTH-1, LOG2_TEST_BAR_WIDTH);
                        colour_select <= (others => '0');
                    end if;
                    byte_select <= '1';
                    --if clk_counts = 134820 then -- 3210us @ 42MHz => 134820
                    if clk_counts = 4200 then -- 100us @ 42MHz => 4200
                        pres_dvp_state <= HREF_HIGH;
                        clk_counts <= (others => '0');
                        vsync <= '1';
                        href <= '1';
                        -- Need to avoid duplicated output in next HREF high
                        data <= pixel_data(15 downto 8);
                        byte_select <= '0';
                    else
                        clk_counts <= clk_counts + 1;
                    end if;
                when HREF_HIGH =>
                    if pixelxline_count < IMG_WIDTH then
                        if byte_select = '1' then -- MSB
                            data <= pixel_data(15 downto 8);
                            byte_select <= '0';

                            if test_pattern = '1' then
                                if test_bar_counter = 0 then
                                    test_bar_counter <= to_unsigned(TEST_BAR_WIDTH-1, LOG2_TEST_BAR_WIDTH);
                                    colour_select <= colour_select + 1;
                                else
                                    test_bar_counter <= test_bar_counter - 1;
                                end if;
                            end if;
                        else -- LSB
                            data <= pixel_data(7 downto 0);
                            byte_select <= '1';
                            if test_pattern = '0' then
                                pixel_data <= std_logic_vector(unsigned(pixel_data) + 1);
                            else
                                case colour_select is
                                when "001" =>
                                    pixel_data <= TEST_YELLOW;
                                when "010" =>
                                    pixel_data <= TEST_CIAN;
                                when "011" =>
                                    pixel_data <= TEST_GREEN;
                                when "100" =>
                                    pixel_data <= TEST_MAGENTA;
                                when "101" =>
                                    pixel_data <= TEST_RED;
                                when "110" =>
                                    pixel_data <= TEST_BLUE;
                                when "111" =>
                                    pixel_data <= TEST_BLACK;
                                when others =>
                                    pixel_data <= TEST_WHITE;
                                end case;
                            end if;
                            pixelxline_count <= pixelxline_count + 1;
                        end if;
                    else
                        if test_pattern = '1' then
                            pixel_data <= TEST_WHITE;
                            test_bar_counter <= to_unsigned(TEST_BAR_WIDTH-1, LOG2_TEST_BAR_WIDTH);
                            colour_select <= (others => '0');
                        end if;
                        pixelxline_count <= (others => '0');
                        clk_counts <= (others => '0');
                        line_count <= line_count + 1;
                        vsync <= '1';
                        href <= '0';
                        pres_dvp_state <= HREF_LOW;
                    end if;
                when HREF_LOW =>
                    if line_count < IMG_HEIGHT then
                        if clk_counts = 210 then -- 5us @ 42MHz => 210
                            pres_dvp_state <= HREF_HIGH;
                            clk_counts <= (others => '0');
                            vsync <= '1';
                            href <= '1';
                            -- Need to avoid duplicated output in next HREF high
                            data <= pixel_data(15 downto 8);
                            byte_select <= '0';
                        else 
                            clk_counts <= clk_counts + 1;
                        end if; 
                    else
                        pres_dvp_state <= POST_VSYNC_HIGH;
                        clk_counts <= (others => '0');
                        vsync <= '1';
                        href <= '0';
                    end if;
                when POST_VSYNC_HIGH =>
                    --if clk_counts = 23940 then -- 570us @ 42MHz => 23940
                    if clk_counts = 2100 then -- 50us @ 42MHz => 2100
                        pres_dvp_state <= VSYNC_LOW;
                        clk_counts <= (others => '0');
                        vsync <= '0';
                        href <= '0';
                    else 
                        clk_counts <= clk_counts + 1;
                    end if;
                when others =>
                    pres_dvp_state <= VSYNC_LOW;
                    clk_counts <= (others => '0');
                    vsync <= '0';
                    href <= '0';
            end case;
        end if;
    end process signal_generator;
end behavioural;