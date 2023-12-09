library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity camera is
    generic (
        -- Base addresses of target slave
        IMAGE_SIZE_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000000";
        -- This one is equal to:
        --  IMAGE_SIZE_SLAVE_BASE_ADDR + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8))
        --  AXI_BURST_LEN = 64
        --  AXI_DATA_WIDTH = 32
        IMAGE_DATA_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000100"
    );
    port (
        clk : in std_logic;
        nreset : in std_logic;
--        camera_idle : in std_logic;
        operation   : in std_logic;--take a picture
        
        xclk_en      : out std_logic;
        cam_reset    : out std_logic;
        cam_pwdn     : out std_logic;
--        take_pic : out std_logic;
        sioc : out std_logic;
        siod : inout std_logic;
        
        
        
--        sys_clk : in std_logic;
--        nreset  : in std_logic;
        -- Camera ports
        pclk    : in std_logic;
        vsync   : in std_logic;
        href    : in std_logic;
        data_in : in std_logic_vector(7 downto 0);
        -- Control/Status ports
--        take_pic    : in std_logic;
--        camera_idle : out std_logic;
        -- AXI ports
        -- Common signals
        -- Global Clock Signal.
		M0_AXI_aclk	    : in std_logic;
		-- Global Reset Singal. This Signal is Active Low
		M0_AXI_aresetn	: in std_logic;
		-- Remaining ports
        M0_AXI_awid      : out std_logic;
        M0_AXI_awaddr    : out std_logic_vector(31 downto 0);
        M0_AXI_awlen     : out std_logic_vector(7 downto 0);
        M0_AXI_awsize    : out std_logic_vector(2 downto 0);
        M0_AXI_awburst   : out std_logic_vector(1 downto 0);
        M0_AXI_awlock    : out std_logic;
        M0_AXI_awcache   : out std_logic_vector(3 downto 0);
        M0_AXI_awprot    : out std_logic_vector(2 downto 0);
        M0_AXI_awqos     : out std_logic_vector(3 downto 0);
        M0_AXI_awvalid   : out std_logic;
        M0_AXI_awready   : in std_logic;
        M0_AXI_wdata     : out std_logic_vector(31 downto 0);
        M0_AXI_wstrb     : out std_logic_vector(3 downto 0);
        M0_AXI_wlast     : out std_logic;
        M0_AXI_wvalid    : out std_logic;
        M0_AXI_wready    : in std_logic;
        M0_AXI_bid       : in std_logic;
        M0_AXI_bresp     : in std_logic_vector(1 downto 0);
        M0_AXI_bvalid    : in std_logic;
        M0_AXI_bready    : out std_logic
    );

end entity;

architecture Behavioral of camera is

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
            siod : inout std_logic
--            next_data_o : out std_logic
        );
    end component;

    component top_camera_dma is
        generic (
            -- Base addresses of target slave
            IMAGE_SIZE_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000000";
            -- This one is equal to:
            --  IMAGE_SIZE_SLAVE_BASE_ADDR + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8))
            --  AXI_BURST_LEN = 64
            --  AXI_DATA_WIDTH = 32
            IMAGE_DATA_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000100"
        );
        port (
    --        sys_clk : in std_logic;
    --        nreset  : in std_logic;
            -- Camera ports
            pclk    : in std_logic;
            vsync   : in std_logic;
            href    : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            -- Control/Status ports
            take_pic    : in std_logic;
            camera_idle : out std_logic;
            -- AXI ports
            -- Common signals
            -- Global Clock Signal.
            M0_AXI_aclk	    : in std_logic;
            -- Global Reset Singal. This Signal is Active Low
            M0_AXI_aresetn	: in std_logic;
            -- Remaining ports
            M0_AXI_awid      : out std_logic;
            M0_AXI_awaddr    : out std_logic_vector(31 downto 0);
            M0_AXI_awlen     : out std_logic_vector(7 downto 0);
            M0_AXI_awsize    : out std_logic_vector(2 downto 0);
            M0_AXI_awburst   : out std_logic_vector(1 downto 0);
            M0_AXI_awlock    : out std_logic;
            M0_AXI_awcache   : out std_logic_vector(3 downto 0);
            M0_AXI_awprot    : out std_logic_vector(2 downto 0);
            M0_AXI_awqos     : out std_logic_vector(3 downto 0);
            M0_AXI_awvalid   : out std_logic;
            M0_AXI_awready   : in std_logic;
            M0_AXI_wdata     : out std_logic_vector(31 downto 0);
            M0_AXI_wstrb     : out std_logic_vector(3 downto 0);
            M0_AXI_wlast     : out std_logic;
            M0_AXI_wvalid    : out std_logic;
            M0_AXI_wready    : in std_logic;
            M0_AXI_bid       : in std_logic;
            M0_AXI_bresp     : in std_logic_vector(1 downto 0);
            M0_AXI_bvalid    : in std_logic;
            M0_AXI_bready    : out std_logic
        );
    end component;
    signal take_pic, camera_idle : std_logic;
begin
    controller : camera_controller_top port map (
        clk => clk,
        nreset => nreset,
        camera_idle => camera_idle,
        operation => operation,
        xclk_en => xclk_en,
        cam_reset => cam_reset,
        cam_pwdn => cam_pwdn,
        take_pic => take_pic,
        sioc => sioc,
        siod => siod
--        next_data_o => next_data
    );
    
    dma : top_camera_dma
    generic map(
        IMAGE_SIZE_SLAVE_BASE_ADDR => IMAGE_SIZE_SLAVE_BASE_ADDR,
        IMAGE_DATA_SLAVE_BASE_ADDR => IMAGE_DATA_SLAVE_BASE_ADDR
    )
    port map(
        pclk  => pclk,
        vsync => vsync,
        href  => href,
        data_in => data_in,
        -- Control/Status ports
        take_pic => take_pic,
        camera_idle => camera_idle,
        -- AXI ports
        -- Common signals
        -- Global Clock Signal.
		M0_AXI_aclk => M0_AXI_aclk,
		-- Global Reset Singal. This Signal is Active Low
		M0_AXI_aresetn => M0_AXI_aresetn,
		-- Remaining ports
        M0_AXI_awid => M0_AXI_awid,
        M0_AXI_awaddr => M0_AXI_awaddr,
        M0_AXI_awlen => M0_AXI_awlen,
        M0_AXI_awsize => M0_AXI_awsize,
        M0_AXI_awburst => M0_AXI_awburst,
        M0_AXI_awlock => M0_AXI_awlock,
        M0_AXI_awcache => M0_AXI_awcache,
        M0_AXI_awprot => M0_AXI_awprot,
        M0_AXI_awqos => M0_AXI_awqos,
        M0_AXI_awvalid => M0_AXI_awvalid,
        M0_AXI_awready => M0_AXI_awready,
        M0_AXI_wdata => M0_AXI_wdata,
        M0_AXI_wstrb => M0_AXI_wstrb,
        M0_AXI_wlast => M0_AXI_wlast,
        M0_AXI_wvalid => M0_AXI_wvalid,
        M0_AXI_wready => M0_AXI_wready,
        M0_AXI_bid => M0_AXI_bid,
        M0_AXI_bresp => M0_AXI_bresp,
        M0_AXI_bvalid => M0_AXI_bvalid,
        M0_AXI_bready => M0_AXI_bready
    );
    

end Behavioral;