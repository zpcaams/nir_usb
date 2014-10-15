--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:42:38 10/14/2014
-- Design Name:   
-- Module Name:   E:/Xilinx Test/AA/aa_tb.vhd
-- Project Name:  AA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clkdivider
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
 
ENTITY aa_tb IS
END aa_tb;
 
ARCHITECTURE behavior OF aa_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clkdivider
    PORT(
         m_clk_i : IN  std_logic;
         m_rst_i : IN  std_logic;
         sen_tri : IN  std_logic;
         fast_clk_i : IN  std_logic;
         d_pos_i : IN  std_logic;
         d_neg_i : IN  std_logic;
         dco_pos_i : IN  std_logic;
         dco_neg_i : IN  std_logic;
         cnv_pos_o : OUT  std_logic;
         cnv_neg_o : OUT  std_logic;
         clk_pos_o : OUT  std_logic;
         clk_neg_o : OUT  std_logic;
         data_rd_rdy_o : OUT  std_logic;
         data_o : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal m_clk_i : std_logic := '0';
   signal m_rst_i : std_logic := '0';
   signal sen_tri : std_logic := '0';
   signal fast_clk_i : std_logic := '0';
   signal d_pos_i : std_logic := '0';
   signal d_neg_i : std_logic := '0';
   signal dco_pos_i : std_logic := '0';
   signal dco_neg_i : std_logic := '0';

 	--Outputs
   signal cnv_pos_o : std_logic;
   signal cnv_neg_o : std_logic;
   signal clk_pos_o : std_logic;
   signal clk_neg_o : std_logic;
   signal data_rd_rdy_o : std_logic;
   signal data_o : std_logic_vector(15 downto 0);


BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clkdivider PORT MAP (
          m_clk_i => m_clk_i,
          m_rst_i => m_rst_i,
          sen_tri => sen_tri,
          fast_clk_i => fast_clk_i,
          d_pos_i => d_pos_i,
          d_neg_i => d_neg_i,
          dco_pos_i => dco_pos_i,
          dco_neg_i => dco_neg_i,
          cnv_pos_o => cnv_pos_o,
          cnv_neg_o => cnv_neg_o,
          clk_pos_o => clk_pos_o,
          clk_neg_o => clk_neg_o,
          data_rd_rdy_o => data_rd_rdy_o,
          data_o => data_o
        );

   -- Clock process definitions
	--定义主时钟m_clk100MHz@10 ns
 process
   begin
	  loop
		m_clk_i <= '0';
		wait for 5 ns;
		m_clk_i <= '1';
		wait for 5 ns;
		end loop;
   end process;
  --定义数据转移时钟fast_clk 125MHz@8 ns
process
   begin
		loop
		fast_clk_i <= '1';
		wait for 4 ns;
		fast_clk_i <= '0';
		wait for 4 ns;
		end loop;
   end process;
 --定义传感器触发信号 
process
   begin
		loop
		sen_tri <= '1';
		wait for 20 ns;
		sen_tri <= '0';
		wait for 180 ns;
		end loop;
   end process;
	
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		m_rst_i <='0';
      wait for 40 ns;	
		m_rst_i <='1';
      wait for 9999 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
