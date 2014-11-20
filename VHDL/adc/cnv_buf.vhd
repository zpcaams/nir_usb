----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:30 11/20/2014 
-- Design Name: 
-- Module Name:    cnv_buf - Behavioral 
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

entity cnv_buf is
    Port ( cnv : in  STD_LOGIC;
           cnv_pos : out  STD_LOGIC;
           cnv_neg : out  STD_LOGIC);
end cnv_buf;

architecture Behavioral of cnv_buf is

begin
OBUFDS2_inst : OBUFDS
	 generic map (
      IOSTANDARD => "DEFAULT"
		)
   port map (
      O   => cnv_pos ,     -- Diff_p output (connect directly to top-level port)
      OB  => cnv_neg ,   -- Diff_n output (connect directly to top-level port)
      I   => cnv     -- Buffer input 
   );

end Behavioral;

