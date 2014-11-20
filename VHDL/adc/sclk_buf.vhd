----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:35:14 11/20/2014 
-- Design Name: 
-- Module Name:    sclk_buf - Behavioral 
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
LIBRARY IEEE;
Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sclk_buf is
    Port ( sclk : in  STD_LOGIC;
           clk_pos : out  STD_LOGIC;
           clk_neg : out  STD_LOGIC);
end sclk_buf;

architecture Behavioral of sclk_buf is

begin

-- Clock Out Single -> LVDS
OBUFDS2_inst : OBUFDS
	 generic map (
      IOSTANDARD => "DEFAULT"
		)
   port map (
      O   => clk_pos ,     -- Diff_p output (connect directly to top-level port)
      OB  => clk_neg ,   -- Diff_n output (connect directly to top-level port)
      I   => sclk      -- Buffer input 
   );

end Behavioral;

