----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:13 11/20/2014 
-- Design Name: 
-- Module Name:    dco_buf - Behavioral 
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

entity dco_buf is
    Port ( dco_pos : in  STD_LOGIC;
           dco_neg : in  STD_LOGIC;
           dco : out  STD_LOGIC);
end dco_buf;

architecture Behavioral of dco_buf is

begin
 IBUFDS2_inst : IBUFDS
   generic map (
      DIFF_TERM => FALSE, -- Differential Termination
      IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, 
                               -- "0"-"16" 
      IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, 
                                 -- "AUTO", "0"-"8" 
      IOSTANDARD => "DEFAULT")
   port map (
		O  => dco      ,  -- Buffer output
      I  => dco_pos  ,  -- Diff_p buffer input (connect directly to top-level port)
      IB => dco_neg   -- Diff_n buffer input (connect directly to top-level port)
   );


end Behavioral;

