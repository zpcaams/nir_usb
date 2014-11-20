--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:36:01 11/20/2014
-- Design Name:   
-- Module Name:   E:/Xilinx Test/ad/ad_tb.vhd
-- Project Name:  ad
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adc
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
 
ENTITY ad_tb IS
END ad_tb;
 
ARCHITECTURE behavior OF ad_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adc
    PORT(
         fast_clk : IN  std_logic;
         reset : IN  std_logic;
         trig : IN  std_logic;
         data : IN  std_logic;
         dco : IN  std_logic;
         cnv : OUT  std_logic;
         sclk : OUT  std_logic;
         data_reg : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal fast_clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal trig : std_logic := '0';
   signal data : std_logic := '0';
   signal dco : std_logic := '0';

 	--Outputs
   signal cnv : std_logic;
   signal sclk : std_logic;
   signal data_reg : std_logic_vector(15 downto 0);


 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adc PORT MAP (
          fast_clk => fast_clk,
          reset => reset,
          trig => trig,
          data => data,
          dco => dco,
          cnv => cnv,
          sclk => sclk,
          data_reg => data_reg
        );

   -- Clock process definitions
   fast_clk_process :process
   begin
		fast_clk <= '0';
		wait for 2.5 ns;
		fast_clk <= '1';
		wait for 2.5 ns;
   end process;
	
	   trig_process :process
   begin
		wait for 200 ns;
		trig <= '1';
		wait for 10 ns;
		trig <= '0';
		wait for 390 ns;
		
   end process;
 


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset<= '0';
      wait for 100 ns;	
      reset<= '1';
      wait for 9999999 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
