----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:26 11/20/2014 
-- Design Name: 
-- Module Name:    d_buf - Behavioral 
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

entity d_buf is
    Port ( d_pos : in  STD_LOGIC;
           d_neg : in  STD_LOGIC;
           data : out  STD_LOGIC);
end d_buf;

architecture Behavioral of d_buf is

begin




-- Data In LVDS -> Single
   
  IBUFDS1_inst : IBUFDS
   generic map (
      DIFF_TERM => FALSE, -- Differential Termination
      IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, 
                               -- "0"-"16" 
      IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, 
                                 -- "AUTO", "0"-"8" 
      IOSTANDARD => "DEFAULT")
   port map (
     	O  => data   ,  -- Buffer output
     	I  => d_pos  ,  -- Diff_p buffer input (connect directly to top-level port)
      IB => d_neg  -- Diff_n buffer input (connect directly to top-level port)
   );

end Behavioral;

