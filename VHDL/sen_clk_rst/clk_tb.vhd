--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:47 11/06/2014
-- Design Name:   
-- Module Name:   E:/Xilinx Test/clk/clk_tb.vhd
-- Project Name:  clk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clk
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY clk_tb IS
END clk_tb;
 
ARCHITECTURE behavior OF clk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clk
    PORT(
         m_clk_i : IN  std_logic;
         m_rst_i : IN  std_logic;
         sen_tri : IN  std_logic;
         sen_clk : OUT  std_logic;
         sen_rst : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal m_clk_i : std_logic := '0';
   signal m_rst_i : std_logic := '0';
   signal sen_tri : std_logic := '0';

 	--Outputs
   signal sen_clk : std_logic;
   signal sen_rst : std_logic;
	--others
	signal cnt3 : integer range 0 to 7;
	signal cnt4 : integer range 0 to 2079;
	signal cnt5 : integer range 0 to 256;
	Type states is(rst_state,tri_state,idle_state);
	signal pr_state,nx_state:states;
	signal tri_signal:std_logic;

   -- Clock period definitions
   constant m_clk_i_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clk PORT MAP (
          m_clk_i => m_clk_i,
          m_rst_i => m_rst_i,
          sen_tri => sen_tri,
          sen_clk => sen_clk,
          sen_rst => sen_rst
        );

   -- Clock process definitions
   sen_clk_process :process
   begin
		m_clk_i <= '0';
		wait for m_clk_i_period/2;
		m_clk_i <= '1';
		wait for m_clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		m_rst_i <='0';
      wait for 100 ns;	
		m_rst_i <='1';
      wait for 9999 ns;

      -- insert stimulus here 

      wait;
   end process;
	
	--定义触发指示计数cnt3
	process(sen_clk,m_rst_i)
	begin
	if falling_edge(sen_clk) then
		if sen_rst='1' then
			cnt3<=0;
			elsif cnt3=7 then
				cnt3<=0;
			else cnt3<=cnt3+1;
			end if;
		end if;
	end process;
	--定义触发sen_tri
	process(sen_clk,tri_signal)
	begin
		if falling_edge(sen_clk) then	
			if tri_signal='1' then
				if cnt3=6 then
					sen_tri<='1';
				else 
					sen_tri<='0';
				end if;
			end if;
		end if;
	end process;
	--定义状态机计数器
	process(sen_clk,sen_rst)
	begin
	if falling_edge(sen_clk) then
		if m_rst_i='0' then
			cnt4<=0;
			elsif cnt4=2079 then 
					cnt4<=0;
					else 
					cnt4<=cnt4+1;
			end if;
		end if;
	end process;
	--定义状态机
		process(sen_clk,sen_rst,cnt4)
	begin
	if falling_edge(sen_clk) then
			pr_state<=nx_state;
		if m_rst_i='0' then
			pr_state<=rst_state;
			end if;
		case pr_state is 
			when rst_state =>
				if sen_rst<='0' then
					nx_state<=tri_state;
				end if;
			when tri_state =>
				if cnt4=2059 then
					nx_state<=idle_state;
				end if;
			when idle_state =>
				if cnt4=0 then
					nx_state<=rst_state;
				end if;
		end case;
		end if;
	end process;	
	
	process(sen_clk,pr_state)
	begin
	if falling_edge(sen_clk) then
		case pr_state is 
			when rst_state =>
				 tri_signal<='0';
			when tri_state =>
				 tri_signal<='1';
			when idle_state =>
			    tri_signal<='0';
		end case;
		end if;
	end process;	
				
END;
