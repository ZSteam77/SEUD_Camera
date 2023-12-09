library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tmr_clk_gen is
   generic(N:integer:=250);
   port(clk,nreset:IN std_logic;
        clk_div1,clk_div2:OUT std_logic);
end tmr_clk_gen;

architecture behave of tmr_clk_gen is
  subtype tmr_logic is std_logic_vector(2 downto 0);
  type tmr_logic_vector_8 is array (0 to 2) of std_logic_vector(7 downto 0);
  signal q1,q2:tmr_logic;
  signal count,count_plus:tmr_logic_vector_8;
  function maj(a,b,c:std_logic) return std_logic is
  begin
     return (A and B) OR (A and C) OR (B and C);
  end;
begin
   U0:for i in 0 to 2 generate
      process(clk,nreset)
	  begin
	    if (nreset='0') then
		    q1(i)<='0';
			  count(i)<=(others=>'0');
		  elsif rising_edge(clk) then
		    if (count(i)<128) then
			    q1(i)<='0';
			  else
			    q1(i)<='1';
			  end if;
			  if (count(i)>66) and (count(i)<128+66) then -- 90 degress two clock cyles late...
			     q2(i)<='1';
			  else
			     q2(i)<='0';
			  end if;
			  for j in 7 downto 0 loop
			    count(i)(j)<=maj(count_plus(0)(j),count_plus(1)(j),count_plus(2)(j));
		    end loop;
		 end if;
	  end process;
	  count_plus(i)<=count(i)+1;
   end generate;
   clk_div1<=maj(q1(0),q1(1),q1(2));
   clk_div2<=maj(q2(0),q2(1),q2(2));
end behave;

