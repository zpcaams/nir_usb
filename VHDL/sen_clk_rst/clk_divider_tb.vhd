--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:59:59 10/15/2014
-- Design Name:   
-- Module Name:   E:/Xilinx Test/afff/tb.vhd
-- Project Name:  afff
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: odd_div2
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT odd_div2
    PORT(
         m_clk_i : IN  std_logic;
         m_rst_i : IN  std_logic;
         sen_clk : OUT  std_logic;
         sen_rst : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal m_clk_i : std_logic := '0';
   signal m_rst_i : std_logic := '0';

 	--Outputs
   signal sen_clk : std_logic;
   signal sen_rst : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: odd_div2 PORT MAP (
          m_clk_i => m_clk_i,
          m_rst_i => m_rst_i,
          sen_clk => sen_clk,
          sen_rst => sen_rst
        );

   -- Clock process definitions
process
   begin
		m_clk_i <= '0';
		wait for 10 ns;
		m_clk_i <= '1';
		wait for 10 ns;
   end process;
 

   -- Stimulus process
process
   begin		
      -- hold reset state for 100 ns.
		m_rst_i<='0';
      wait for 30 ns;	
		m_rst_i<='1';
      wait for 9999 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
