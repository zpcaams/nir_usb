----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:46 11/20/2014 
-- Design Name: 
-- Module Name:    adc - Behavioral 
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

entity adc is
    Port ( fast_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  trig  : in STD_LOGIC;
           data : in  STD_LOGIC;
           dco : in  STD_LOGIC;
           cnv : out  STD_LOGIC;
           sclk : out  STD_LOGIC;
			  data_reg : out STD_LOGIC_vector(15 downto 0));
end adc;

architecture Behavioral of adc is

signal clk_s,buffer_reset,read_s : std_logic;
signal tri_reg : std_logic_vector(1 downto 0);
signal cnv_cnt : integer range 0 to 18;
signal sclk_cnt,dco_cnt : integer range 0 to 16;
signal serial_buf : std_logic_vector(15 downto 0); 
type state_type is (serial_idle, serial_cnv,serial_read,serial_fifo); 
signal pr_state, nx_state : state_type; 
   
begin

sclk<=(fast_clk and clk_s);

--trig移位寄存器变化，用来指示状态机变化
process(fast_clk,reset)        
begin
if rising_edge(fast_clk) then
      if reset = '0' then
			tri_reg<="00";
			else
			tri_reg(1 downto 0)<= tri_reg(0) & trig;
      end if; 
   end if;
end process;


--cnv_cnt用来指示CNV状态变化
process(fast_clk,tri_reg)
begin
if rising_edge(fast_clk) then
	if tri_reg="01" then
		cnv_cnt<=18;
		elsif cnv_cnt>0 then
		cnv_cnt<=cnv_cnt-1;
	end if;
end if;
end process;

--CNV上升沿变化
process(cnv_cnt)
begin
if cnv_cnt>0 then
	cnv<='1';
	else 
	cnv<='0';
end if;
end process;

--状态机变化
 process (fast_clk,reset)
   begin
      if rising_edge(fast_clk) then
         if reset = '0' then
				read_s<='0';
            pr_state <= serial_idle;
         else
            pr_state <= nx_state;
			case pr_state is 
				when serial_idle =>
					read_s<='0';
				when serial_cnv =>
					read_s<='0';
				when serial_read =>
					read_s<='1';
				when serial_fifo =>
					read_s<='0';
				when others =>
					read_s<='0';
			end case;
		
         end if;        
      end if;
   end process;
	
--状态机变化条件
 process (pr_state, nx_state,cnv_cnt,sclk_cnt)
   begin
      nx_state <= serial_idle; 
       case pr_state is
         when serial_idle =>
            if tri_reg = "01" then              --trig触发
               nx_state <= serial_cnv;
            end if;
         when serial_cnv =>
            if cnv_cnt = 0 then
               nx_state <= serial_read;
            end if;
         when serial_read =>
				if sclk_cnt = 0 then
               nx_state <= serial_fifo;
            end if;
			when serial_fifo =>
				nx_state <= serial_idle;
         when others =>
            nx_state <= serial_idle;
      end case;      
   end process;
	
--buffer_reset变化准备以为寄存器存储数据
process(fast_clk,cnv_cnt)
begin
if rising_edge(fast_clk) then
	if cnv_cnt=1 then
		buffer_reset<='1';
		else
		buffer_reset<='0';
		end if;
	end if;
end process;

--SCLK_CNT
process(fast_clk,buffer_reset)
begin
if rising_edge(fast_clk) then
	if buffer_reset='1' then
		sclk_cnt <=16;
		elsif sclk_cnt >0 then
		sclk_cnt<=sclk_cnt-1;
	end if;
end if;
end process;
--clks变化
process(fast_clk ,sclk_cnt,buffer_reset)
begin
if rising_edge(fast_clk) then
	if (sclk_cnt>0 and buffer_reset='0') then
		clk_s<='1';
		else clk_s<='0';
	end if;
end if;
end process;
				
--移位寄存器存储
process(dco,buffer_reset)
begin
if rising_edge(dco) then
	if buffer_reset='1' then
		serial_buf<="0000000000000000";
		dco_cnt<=16;
		elsif dco_cnt>0 then
		dco_cnt<=dco_cnt-1;
		serial_buf<=serial_buf(14 downto 0)&data;
	end if;
end if;
end process;
data_reg<=serial_buf;
end Behavioral;

