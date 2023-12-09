library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_camera_dma is
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
end entity;

architecture structural of top_camera_dma is
    -- Component declaration
    component dvp_capture is
        port (
            nreset      : in std_logic;                         -- Active low reset
            sys_clk     : in std_logic;                         -- System clock
            pclk        : in std_logic;                         -- OV5640 Pixel clock
            vsync       : in std_logic;                         -- OV5640 Vsync signal
            href        : in std_logic;                         -- OV5640 Href signal
            data_in     : in std_logic_vector (7 downto 0);     -- OV5640 8-bit data output
            wen_out     : out std_logic;                        -- High when 'data_out' updates
            data_out    : out std_logic_vector (31 downto 0);   -- 32-bit packed image data
            capture_img : in std_logic;             -- Initiates the image capture process
            new_image   : out std_logic;            -- Signals the start of the capture process
            end_image   : out std_logic;            -- Signal the end of the capture process
            image_size  : out std_logic_vector (31 downto 0)    -- Num of bytes of the captured image
        );
    end component;

    component dma_controller is
        port(
           -- Common ports
            clk         : in std_logic;
            nreset      : in std_logic;
            -- Camera DVP related ports
            new_image   : in std_logic;
            end_image   : in std_logic;
            dvp_wen     : in std_logic;
            dvp_din     : in std_logic_vector(31 downto 0);
            dvp_capture : out std_logic;
            -- AXI Master related ports
            axi_dout    : out std_logic_vector(31 downto 0);
            axi_ack     : in std_logic;
            axi_eoi     : in std_logic;
            start_axi   : out std_logic;
            stop_axi    : out std_logic;
            start_burst : out std_logic;
            -- DMA control/status ports
            take_pic    : in std_logic;
            camera_idle : out std_logic
        );
    end component;

    component axi_master is
        generic (
            -- Base addresses of targeted slave
            IMAGE_SIZE_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000000";
            -- This one is equal to:
            --  IMAGE_SIZE_SLAVE_BASE_ADDR + (AXI_BURST_LEN * (AXI_DATA_WIDTH / 8))
            IMAGE_DATA_SLAVE_BASE_ADDR	: std_logic_vector	:= x"80000100";
            -- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
            AXI_BURST_LEN	: integer	:= 64;
            --
            BEAT_COUNTER_WIDTH : integer := 6; --log2(AXI_BURST_LEN)
            -- Width of Address Bus
            AXI_ADDR_WIDTH	: integer	:= 32;
            -- Width of Data Bus
            AXI_DATA_WIDTH	: integer	:= 32
        );
        port (
            -- Common ports
            m_axi_aclk	    : in std_logic;
            m_axi_aresetn	: in std_logic;
            -- AXI ports
            m_axi_awid	    : out std_logic;
            m_axi_awaddr	: out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
            m_axi_awlen	    : out std_logic_vector(7 downto 0);
            m_axi_awsize	: out std_logic_vector(2 downto 0);
            m_axi_awburst	: out std_logic_vector(1 downto 0);
            m_axi_awlock	: out std_logic;
            m_axi_awcache	: out std_logic_vector(3 downto 0);
            m_axi_awprot	: out std_logic_vector(2 downto 0);
            m_axi_awqos	    : out std_logic_vector(3 downto 0);
            m_axi_awvalid	: out std_logic;
            m_axi_awready	: in std_logic;
            m_axi_wdata	    : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
            m_axi_wstrb	    : out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
            m_axi_wlast	    : out std_logic;
            m_axi_wvalid	: out std_logic;
            m_axi_wready	: in std_logic;
            m_axi_bid	    : in std_logic;
            m_axi_bresp	    : in std_logic_vector(1 downto 0);
            m_axi_bvalid	: in std_logic;
            m_axi_bready	: out std_logic;
            -- Custom interface ports
            start_axi       : in std_logic;
            stop_axi        : in std_logic;
            start_burst     : in std_logic;
            data_in         : in std_logic_vector (AXI_DATA_WIDTH-1 downto 0);
            data_ack        : out std_logic;
            image_size      : in std_logic_vector(31 downto 0);
            end_of_image    : out std_logic
        );
    end component;

    signal wen_dvp2dma  : std_logic;
    signal data_dvp2dma : std_logic_vector(31 downto 0);
    signal new_image    : std_logic;
    signal end_image    : std_logic;
    signal image_size   : std_logic_vector(31 downto 0);
    signal data_dma2axi : std_logic_vector(31 downto 0);
    signal ack_axi2dma  : std_logic;
    signal start_axi    : std_logic;
    signal stop_axi     : std_logic;
    signal start_burst  : std_logic;
    signal end_of_image : std_logic;
    signal capture_img  : std_logic;

begin
    inst_dvp_capture: dvp_capture
    port map(
        nreset      => m0_AXI_aresetn, -- nreset,
        sys_clk     => m0_AXI_aclk, -- sys_clk,
        pclk        => pclk,
        vsync       => vsync,
        href        => href,
        capture_img => capture_img,
        data_in     => data_in,
        wen_out     => wen_dvp2dma,
        data_out    => data_dvp2dma,
        new_image   => new_image,
        end_image   => end_image,
        image_size  => image_size
    );

    inst_dma_controller: dma_controller
    port map(
        -- Common ports
        clk         => m0_AXI_aclk, -- sys_clk,
        nreset      => m0_AXI_aresetn, -- nreset,
        -- Camera DVP related ports
        new_image   => new_image,
        end_image   => end_image,
        dvp_wen     => wen_dvp2dma,
        dvp_din     => data_dvp2dma,
        dvp_capture => capture_img,
        -- AXI Master related ports
        axi_dout    => data_dma2axi,
        axi_ack     => ack_axi2dma,
        axi_eoi     => end_of_image,
        start_axi   => start_axi,
        stop_axi    => stop_axi,
        start_burst => start_burst,
        -- DMA control/status ports
        take_pic    => take_pic,
        camera_idle => camera_idle
    );

    inst_axi_master: axi_master
    generic map(
        IMAGE_SIZE_SLAVE_BASE_ADDR => IMAGE_SIZE_SLAVE_BASE_ADDR,
        IMAGE_DATA_SLAVE_BASE_ADDR => IMAGE_DATA_SLAVE_BASE_ADDR
    )
    port map(
        -- Common ports
        m_axi_aclk      => m0_AXI_aclk, --sys_clk,
        m_axi_aresetn   => m0_AXI_aresetn, -- nreset,
        -- AXI ports
        m_axi_awid      => M0_AXI_awid, 
        m_axi_awaddr    => M0_AXI_awaddr,
        m_axi_awlen     => M0_AXI_awlen,
        m_axi_awsize    => M0_AXI_awsize,
        m_axi_awburst   => M0_AXI_awburst,
        m_axi_awlock    => M0_AXI_awlock,
        m_axi_awcache   => M0_AXI_awcache,
        m_axi_awprot    => M0_AXI_awprot,
        m_axi_awqos     => M0_AXI_awqos,
        m_axi_awvalid   => M0_AXI_awvalid,
        m_axi_awready   => M0_AXI_awready,
        m_axi_wdata     => M0_AXI_wdata,
        m_axi_wstrb     => M0_AXI_wstrb,
        m_axi_wlast     => M0_AXI_wlast,
        m_axi_wvalid    => M0_AXI_wvalid,
        m_axi_wready    => M0_AXI_wready,
        m_axi_bid       => M0_AXI_bid,
        m_axi_bresp     => M0_AXI_bresp,
        m_axi_bvalid    => M0_AXI_bvalid,
        m_axi_bready    => M0_AXI_bready,
        -- Custom interface ports
        start_axi       => start_axi,
        stop_axi        => stop_axi,
        start_burst     => start_burst,
        data_in         => data_dma2axi,
        data_ack        => ack_axi2dma,
        image_size      => image_size,
        end_of_image    => end_of_image
    );
end structural;