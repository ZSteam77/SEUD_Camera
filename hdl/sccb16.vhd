library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity sccb is
   port(clk,nreset:iN std_logic;
--        ce:IN std_logic;
        R_W:IN std_logic;
--		address:std_logic_vector(0 downto 0);
		data_in:IN std_logic_vector(31 downto 0);
		data_out:OUT std_logic_vector(31 downto 0);
		s_clk:IN std_logic;
		s_clk_90:IN std_logic;
        sioc:OUT std_logic;
		siod:INOUT std_logic;
		
		-- new port
		next_data:OUT std_logic;
		write_config:IN std_logic
		);
end sccb;

architecture behave of sccb is
   signal read_data:std_logic_vector(7 downto 0);
   signal write_data:std_logic_vector(33 downto 0); -- 31 downto 0 = data_in
   signal count:std_logic_vector(7 downto 0); -- 127 downto 0
   alias state:std_logic_vector(5 downto 0) is count (7 downto 2);
   signal index:std_logic_vector(5 downto 0);
   signal flag,busy_n,old_busy_n,read,enable_clk_n,data_valid,sioc_int,siod_int,siod_en_data:std_logic;
   signal s_test:std_logic_vector(1 downto 0);
   -- constant sioc_data:std_logic_vector(127 downto 0);
   -- constant siod_en_data:std_logic_vector(127 downto 0):=(others=>'0');
begin
CTRL:process(clk,nreset)
      variable read_address:std_logic_vector(5 downto 0);
   begin
      if (nreset='0') then
	     write_data<=(others=>'0');
		   data_out<=(others=>'Z');
		   busy_n<='1';
		   data_valid<='0';
		   next_data <= '0';
		   flag <= '0';
	  elsif rising_edge(clk) then
        if CONV_INTEGER(count) = 0 and flag = '0' then
            next_data <= '1';
            flag <= '1';
        else
            next_data <= '0';
            if CONV_INTEGER(count) /= 0  then
                flag <= '0';
            end if;
         end if;
	     if (write_config = '1') then
             if (count="11111000") then -- 248
                  busy_n<='1';
               end if;
               -- 126
               if (count="11111100") then -- 252
                   data_valid<='0';
               end if;
             if (R_W='1') then -- read operation
                 data_out<="00000000" & "00000000" & "00000000" & read_data;
               else -- write operation
                 -- Reads are twice as long as write operations...
                 -- write_data<=H'78 & '1' & 'Z' & data_in(23 downto 8) & H'78 '1'  & 'X' & "ZZZZ_ZZZZ"
                 -- How to distinguish a three cycle operation from a two cycle operation????
                  write_data<="1111000" & '0' & 'Z' & data_in(23 downto 8) & 'Z' & data_in(7 downto 0); -- followed by a 'Z'
                  data_out<=(others=>'Z');
                   data_valid<='1';
                   busy_n<='0';
               end if;
         else
         end if;
	  end if;
   end process;
   
SEND:process(s_clk,nreset)
      variable test:integer range 0 to 255;
   begin
      if (nreset='0') then
		     count<="10001100"; -- count=140 
--		     siod_int<='1';
		     read<='1';
		     read_data<=(others=>'0');
             enable_clk_n<='0';
--             next_data <= '0';
	  elsif falling_edge(s_clk) then
	       if write_config = '1' then
                 if (busy_n='0') then -- detect falling_edge on busy_n
                    count<=count-1;
                    test:=conv_integer(count);
                    case test is
                       when 255 downto 252 =>
                           enable_clk_n<='0';
                           read<='1';
                       when 250 =>
                           read<='1';
                           enable_clk_n<='1';
                       when 140 to 148 =>
                           read<='1';
                           enable_clk_n<='1';
                       when 139 =>
                           enable_clk_n<='0';
                           read<='1';
                       when 106 downto 104 => -- index 26
                           read<=write_data(26);
                       when 31 downto 0 => -- index 7 to 0
                          if (read='1') then
                               read_data(conv_integer(state))<=siod_int;
                          end if;
                       when others => -- do nothing
                     end case;
                else
                   count<="10001100"; -- 140
--                   siod_int<='Z';
                end if;
           else
           end if;
	   end if;
   end process;
   s_test<=s_clk & s_clk_90;
   index<=state;
   process(count)
      variable test:integer range 0 to 255;
   begin
	  case count(1 downto 0) is
	     when "00" => sioc_int<='0';
		 when "01" => sioc_int<='1';
		 when "10" => sioc_int<='1';
		 when "11" => sioc_int<='0';
		 when others => sioc_int<='Z';
	   end case;
       test:=conv_integer(count);
	   case test is
	      when 255 downto 252 =>  siod_en_data<='0'; -- index 63
		  when 251 downto 249 =>   siod_en_data<='1'; -- index 62
	      when 248 downto 140 => siod_en_data<='0'; -- index 61 downto 35
		  when 103 downto 100 => siod_en_data<='0'; -- index 25
		  when 35 downto 32 => siod_en_data<='0';  -- index 8
		  when others => siod_en_data<='1';
	   end case;
	   case test is
		  when 255 downto 252 =>
			 siod_int<='Z'; 
      	  when 251 downto 250 =>
		     siod_int<='0'; 
          when 249 =>
	         siod_int<='1';
          when 140 to 248 =>
		     siod_int<='Z';
	      when 139 =>
		     siod_int<='1';
		  when 137 =>
	          siod_int<='0';
		  when 136 =>
			 siod_int<='0';
          when 135 downto 32 => -- index 33 to 8
              siod_int<=write_data(conv_integer(state));
		  when 31 downto 0 => -- index 7 to 0
              if (read='1') then
		          siod_int<='Z';
   			  else
                  siod_int<=write_data(conv_integer(state));
   		      end if;
     	   when others => -- do nothing
	   end case;
   end process;
   sioc<=sioc_int OR enable_clk_n;
   siod<='Z' when siod_en_data='0' else siod_int;
end behave;