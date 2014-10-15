----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:09 10/13/2014 
-- Design Name: 
-- Module Name:    clk_divider25 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity odd_div2 is
	 generic(N:integer:=25);
	 port(	m_clk_i: in std_logic;
				m_rst_i:in std_logic;
			   sen_clk: out std_logic;
				sen_rst:out std_logic);
end odd_div2;
 
architecture Behavioral of odd_div2 is
	 signal temp_clk1,temp_clk2 :std_logic:='0';
	 signal cnt1,cnt2:integer range 0 to 255;
	 signal M:integer range 0 to 199;
	 
begin
process(m_clk_i,m_rst_i)
	begin
	if rising_edge(m_clk_i) then
		if m_rst_i='0' then
			cnt1<=0;
		else		 
		cnt1<=cnt1+1;
			 if cnt1=(N-1)/2 then
				 temp_clk1<='1';
			 elsif cnt1=(N-1) then
				 temp_clk1<='0';
				 cnt1<=0;
			 end if;
		end if;
	end if;
	 end process;
 
process(m_clk_i,m_rst_i)
begin
	if falling_edge(m_clk_i) then
		if m_rst_i='0' then
			cnt2<=0;
		else
			 cnt2<=cnt2+1;
			 if cnt2=(N-1)/2 then
				 temp_clk2<='1';
			 elsif cnt2=(N-1) then
				 temp_clk2<='0';
				 cnt2<=0;
			 end if;
		end if;
	end if;
end process;
 
process(temp_clk1,temp_clk2)
	 begin
		 sen_clk<=temp_clk1 or temp_clk2;
	 end process;
	 
--sen_rst¸´Î»	 
process(m_clk_i,m_rst_i)
	begin
	if rising_edge(m_clk_i) then
		if m_rst_i='0' then
			M<=0;
		else		 
			M<=M+1;
			if M=199 then
			   M<=0;
			   elsif M<40 then
					sen_rst<='1';
				else 
					sen_rst<='0';
				end if;
			end if;
	end if;
	 end process; 
end Behavioral;

