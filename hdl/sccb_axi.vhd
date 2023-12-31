-------------------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2006-present Johnny �berg, KTH Royal Institute of Technology, Sweden. 
-- All rights reserved. 
-- 
-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
-- following conditions are met: 
--
-- 1.Redistributions of source code must retain the above copyright notice, this list of conditions and the following
-- disclaimer. 
--
-- 2.Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
-- disclaimer in the documentation and/or other materials provided with the distribution. 
-- 
-- 3.The name of the author may not be used to endorse or promote products derived from this software without specific
-- prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE AUTHOR �AS IS� AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
-- AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-- LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
-- OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sccb_axi is
  port
  (
     -- Users to add ports here
	 sioc: OUT std_logic;
	 siod: INOUT std_logic;
	-- User ports ends
	-- Do not modify the ports beyond this line

	-- Global Clock Signal
	S_AXI_ACLK	: in std_logic;
	-- Global Reset Signal. This Signal is Active LOW
	S_AXI_ARESETN	: in std_logic;
	-- Write address (issued by master, acceped by Slave)
	S_AXI_AWADDR	: in std_logic_vector(2 downto 2); -- (C_S_AXI_ADDR_WIDTH-1 downto 0);
	-- Write channel Protection type. This signal indicates the
	-- privilege and security level of the transaction, and whether
   	-- the transaction is a data access or an instruction access.
	S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
	-- Write address valid. This signal indicates that the master signaling
   	-- valid write address and control information.
	S_AXI_AWVALID	: in std_logic;
	-- Write address ready. This signal indicates that the slave is ready
   	-- to accept an address and associated control signals.
	S_AXI_AWREADY	: out std_logic;
	-- Write data (issued by master, acceped by Slave) 
	S_AXI_WDATA	: in std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
	-- Write strobes. This signal indicates which byte lanes hold
   	-- valid data. There is one write strobe bit for each eight
   	-- bits of the write data bus.    
	S_AXI_WSTRB	: in std_logic_vector(3 downto 0); -- ((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
	-- Write valid. This signal indicates that valid write
   	-- data and strobes are available.
	S_AXI_WVALID	: in std_logic;
	-- Write ready. This signal indicates that the slave
   	-- can accept the write data.
	S_AXI_WREADY	: out std_logic;
	-- Write response. This signal indicates the status
   	-- of the write transaction.
	S_AXI_BRESP	: out std_logic_vector(1 downto 0);
	-- Write response valid. This signal indicates that the channel
   	-- is signaling a valid write response.
	S_AXI_BVALID	: out std_logic;
	-- Response ready. This signal indicates that the master
   		-- can accept a write response.
	S_AXI_BREADY	: in std_logic;
	-- Read address (issued by master, acceped by Slave)
	S_AXI_ARADDR	: in std_logic_vector(2 downto 2); -- (C_S_AXI_ADDR_WIDTH-1 downto 0);
	-- Protection type. This signal indicates the privilege
   	-- and security level of the transaction, and whether the
   	-- transaction is a data access or an instruction access.
	S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
	-- Read address valid. This signal indicates that the channel
   	-- is signaling valid read address and control information.
	S_AXI_ARVALID	: in std_logic;
	-- Read address ready. This signal indicates that the slave is
   	-- ready to accept an address and associated control signals.
	S_AXI_ARREADY	: out std_logic;
	-- Read data (issued by slave)
	S_AXI_RDATA	: out std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
	-- Read response. This signal indicates the status of the
   	-- read transfer.
	S_AXI_RRESP	: out std_logic_vector(1 downto 0);
	-- Read valid. This signal indicates that the channel is
    	-- signaling the required read data.
	S_AXI_RVALID	: out std_logic;
	-- Read ready. This signal indicates that the master can
   	-- accept the read data and response information.
	S_AXI_RREADY	: in std_logic
 );
end sccb_axi;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture arch_imp of sccb_axi is

   component tmr_clk_gen
      generic(N:integer:=250);
      port(clk,reset:IN std_logic;
            clk_div1:OUT std_logic;
            clk_div2:OUT std_logic);
   end component;
   component sccb 
      port(clk,reset:IN std_logic;
           ce:IN std_logic;
           R_W:IN std_logic;
		   address:IN std_logic_vector(0 downto 0);
		   data_in:IN std_logic_vector(31 downto 0);
		   data_out:OUT std_logic_vector(31 downto 0);
		   s_clk:IN std_logic;
		   s_clk_90:IN std_logic;
	       sioc:OUT std_logic;
		   siod:INOUT std_logic);
   end component;


   -- constant C_S_AXI_DATA_WIDTH:integer:=32;

   -- AXI4LITE signals
   signal axi_awaddr	: std_logic_vector(2 downto 2);
   signal axi_awready	: std_logic;
   signal axi_wready	: std_logic;
   signal axi_bresp	: std_logic_vector(1 downto 0);
   signal axi_bvalid	: std_logic;
   signal axi_araddr	: std_logic_vector(2 downto 2);
   signal axi_arready	: std_logic;
   signal axi_rdata	: std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
   signal axi_wdata	: std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
   signal axi_rresp	: std_logic_vector(1 downto 0);
   signal axi_rvalid	: std_logic;

   -- Example-specific design signals
   -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
   -- ADDR_LSB is used for addressing 32/64 bit registers/memories
   -- ADDR_LSB = 2 for 32 bits (n downto 2)
   -- ADDR_LSB = 3 for 64 bits (n downto 3)
   -- constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
   -- constant OPT_MEM_ADDR_BITS : integer := 15;
   ------------------------------------------------
   ---- Signals for user logic register space example
   --------------------------------------------------
   signal slv_reg_rden  :std_logic;
   signal slv_reg_wren  :std_logic;
   signal slave_chipselect:std_logic;
   signal slave_address   :std_logic_vector(2 downto 2); -- (C_S_AXI_ADDR_WIDTH-1 downto 0);
   signal slave_byteenable:std_logic_vector(3 downto 0); -- ((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
   signal slave_clk	  :std_logic;
   signal slave_rw	  :std_logic;
   signal slave_reset	  :std_logic;
   signal slave_readdata  :std_logic_vector(31 downto 0);

--   signal inport : outpacket;
--   signal outport : inpacket;
   --signal ce:std_logic;
   --signal R_W:std_logic;
   --signal address:std_logic_vector(0 downto 0);
   --signal data_in:std_logic_vector(31 downto 0);
   --signal data_out:std_logic_vector(31 downto 0);
   signal s_clk:std_logic;
   signal s_clk_90:std_logic;
--   signal sioc:std_logic;
--   signal siod:std_logic;

begin

   -- Mapping AXI to slave primitives
   slave_address    <= S_AXI_AWADDR(2 downto 2) when slv_reg_wren='1' else S_AXI_ARADDR(2 downto 2);
   slave_byteenable <= S_AXI_WSTRB;
   slave_chipselect <= slv_reg_rden OR slv_reg_wren;
   slave_clk        <= S_AXI_ACLK;
   slave_reset      <= not(S_AXI_ARESETN);
   slave_rw	<= '0' when slv_reg_wren='1' else '1'; 
 
   -- I/O Connections assignments

   S_AXI_AWREADY<= axi_awready;
   S_AXI_WREADY	<= axi_wready;
   S_AXI_BRESP	<= axi_bresp;  -- this signal is always 00 after reset... why bother to reset it???
   S_AXI_BVALID	<= axi_bvalid;
   S_AXI_ARREADY<= axi_arready;
   S_AXI_RDATA	<= axi_rdata;
   axi_wdata	<= S_AXI_WDATA;
   S_AXI_RRESP	<= axi_rresp;  -- this signal is always 00 after reset... why bother to reset it???
   S_AXI_RVALID	<= axi_rvalid;

   -- Implement axi_awready generation
   -- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
   -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
   -- de-asserted when reset is low.

   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then 
         if S_AXI_ARESETN = '0' then
            axi_awready <= '0';
         else
            if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
               -- slave is ready to accept write address when
               -- there is a valid write address and write data
               -- on the write address and data bus. This design 
               -- expects no outstanding transactions. 
               axi_awready <= '1';
            else
               axi_awready <= '0';
            end if;
         end if;
      end if;
   end process;

   -- Implement axi_awaddr latching
   -- This process is used to latch the address when both 
   -- S_AXI_AWVALID and S_AXI_WVALID are valid. 

   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then 
         if S_AXI_ARESETN = '0' then
            axi_awaddr <= (others => '0');
         else
            if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
               -- Write Address latching
               axi_awaddr <= S_AXI_AWADDR;
            end if;
         end if;
      end if;                   
   end process; 

   -- Implement axi_wready generation
   -- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
   -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
   -- de-asserted when reset is low. 

   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then 
         if S_AXI_ARESETN = '0' then
            axi_wready <= '0';
         else
            if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
               -- slave is ready to accept write data when 
               -- there is a valid write address and write data
               -- on the write address and data bus. This design 
               -- expects no outstanding transactions.           
               axi_wready <= '1';
            else
              axi_wready <= '0';
            end if;
         end if;
      end if;
   end process; 

   -- Implement memory mapped register select and write logic generation
   -- The write data is accepted and written to memory mapped registers when
   -- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
   -- select byte enables of slave registers while writing.
   -- These registers are cleared when reset (active low) is applied.
   -- Slave register write enable is asserted when valid address and data are available
   -- and the slave is ready to accept the write address and write data.

   slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;


   -- Implement write response logic generation
   -- The write response and response valid signals are asserted by the slave 
   -- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
   -- This marks the acceptance of address and indicates the status of 
   -- write transaction.

   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then 
         if S_AXI_ARESETN = '0' then
       	    axi_bvalid  <= '0';
            axi_bresp   <= "00"; --need to work more on the responses
	 else
            if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
               axi_bvalid <= '1';
               axi_bresp  <= "00"; 
            elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
               axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
            end if;
         end if;
      end if;                   
   end process; 

   -- Implement axi_arready generation
   -- axi_arready is asserted for one S_AXI_ACLK clock cycle when
   -- S_AXI_ARVALID is asserted. axi_awready is 
   -- de-asserted when reset (active low) is asserted. 
   -- The read address is also latched when S_AXI_ARVALID is 
   -- asserted. axi_araddr is reset to zero on reset assertion.

   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then 
         if S_AXI_ARESETN = '0' then
            axi_arready <= '0';
            axi_araddr  <= (others => '1');
         else
            if (axi_arready = '0' and S_AXI_ARVALID = '1') then
               -- indicates that the slave has acceped the valid read address
               axi_arready <= '1';
               -- Read Address latching 
               axi_araddr  <= S_AXI_ARADDR;           
            else
               axi_arready <= '0';
            end if;
         end if;
      end if;           
   end process; 

   -- Implement axi_arvalid generation
   -- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
   -- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
   -- data are available on the axi_rdata bus at this instance. The 
   -- assertion of axi_rvalid marks the validity of read data on the 
   -- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
   -- is deasserted on reset (active low). axi_rresp and axi_rdata are 
   -- cleared to zero on reset (active low).  
   process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_rvalid <= '0';
            axi_rresp  <= "00";
	    -- axi_rdata <= (others=>'0');
         else
            if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
               -- Valid read data is available at the read data bus
               axi_rvalid <= '1';
               axi_rresp  <= "00"; -- 'OKAY' response
            elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
               -- Read data is accepted by the master
               axi_rvalid <= '0';
            end if;            
         end if;
      end if;
   end process;
   axi_rdata<=slave_readdata; -- forward data immediately to match rvalid...

   -- Implement memory mapped register select and read logic generation
   -- Slave register read enable is asserted when valid address is available
   -- and the slave is ready to accept the read address.

   slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

  -- Add user logic here
   USER_LOGIC_0:tmr_clk_gen port map(clk=>slave_clk,
                       reset=>slave_reset,
                       clk_div1=>s_clk,
                       clk_div2=>s_clk_90);
   USER_LOGIC_1:sccb port map(clk=>slave_clk,
					reset=>slave_reset,
					ce=> slave_chipselect,
					R_W=>slave_rw,
					address=>slave_address,
					data_in=>axi_wdata,
					data_out=>axi_rdata,
					s_clk=>s_clk,
					s_clk_90=>s_clk_90,
					sioc=>sioc,
					siod=>siod);

	-- User logic ends


end arch_imp;
