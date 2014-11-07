--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:25:47 11/06/2014
-- Design Name:   
-- Module Name:   E:/Xilinx Test/adc/adc_tb.vhd
-- Project Name:  adc
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
LIBRARY IEEE;
Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY adc_tb IS
END adc_tb;
 
ARCHITECTURE behavior OF adc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adc
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
	
	--
signal cnv_s : std_logic;
signal sdi_s : std_logic;
signal sclk_s : std_logic;
signal adc_clk,data_s: std_logic;
signal serial_buffer:std_logic_vector(15 downto 0);
signal clk_s : std_logic;
signal tmsb_done_s : std_logic;
signal buffer_reset_s : std_logic;
signal sclk_cnt : integer range 0 to 17;
signal sclk_echo_cnt : integer range 0 to 17;
signal serial_read_done_s : std_logic;                        -- 126行
signal adc_tcyc_cnt : integer range 0 to 19;    
TYPE states is(serial_idle,serial_read,serial_done);  --ADC控制引脚定义
signal serial_pstate,serial_nstate:states;
   -- Clock period definitions
   --constant clk_pos_o_period : time := 10 ns;
   --constant clk_neg_o_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adc PORT MAP (
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
   m_clk_i_process :process
   begin
		m_clk_i <= '0';
		wait for 10 ns;
		m_clk_i <= '1';
		wait for 10 ns;
   end process;
	
	--fast_clk_i
    fast_clk_i_process :process
   begin
		fast_clk_i <= '0';
		wait for 2.5 ns;
		fast_clk_i <= '1';
		wait for 2.5 ns;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		m_rst_i <='0';
      wait for 100 ns;	
		m_rst_i <='1';
      wait for 999999 ns;

      -- insert stimulus here 
      wait;
   end process;
	
	sclk_s<=(clk_s and fast_clk_i);
	sdi_s<=(data_s and fast_clk_i);
	
	process(m_clk_i,clk_s)
	begin
		if rising_edge(m_clk_i) then
			if clk_s='1'then
				data_s<='1';
				else data_s<='0';
			end if;
		end if;
	end process;


--定义buffer_reset_s
process(adc_tcyc_cnt)  --过4个时钟后，buffer reset置零，准备发送数据
begin
	if (adc_tcyc_cnt=11)then
		buffer_reset_s<='1';
		else
		buffer_reset_s<='0';
	end if;
end process;
		
--定义clk_s
process(m_rst_i,serial_read_done_s,sclk_cnt,buffer_reset_s)
begin
	if m_rst_i='0' then
		clk_s<='0';
	elsif (serial_read_done_s='0' and sclk_cnt>0  and buffer_reset_s/='1')then
		clk_s<='1';
		else clk_s<='0';
	end if;
end process;



--adc_tcyc_cnt计数变化
process(m_clk_i,m_rst_i)
begin
if rising_edge(m_clk_i) then		
	 if rising_edge(sen_tri) then
			adc_tcyc_cnt<=19;
		end if;
		if adc_tcyc_cnt>0 then
			adc_tcyc_cnt<= adc_tcyc_cnt-1;
		   else
			adc_tcyc_cnt<=19;
		end if;
end if;
end process;


--ADC状态转换条件
process(serial_pstate,tmsb_done_s,sclk_echo_cnt,sclk_cnt)
begin
	case serial_pstate is
			when serial_idle => 
				if tmsb_done_s <= '1' then
					serial_nstate<= serial_read;
				end if;
			when serial_read =>
				if (sclk_echo_cnt=0 and sclk_cnt=0) then
					serial_nstate<= serial_done;
					else
					serial_nstate<= serial_read; 
				end if;
			when serial_done => 
				serial_nstate<= serial_idle;
	end case;
end process;
		
--fast_clk条件下，状态转移指示
process(fast_clk_i)
begin
	if rising_edge(fast_clk_i) then
		if m_rst_i='0' then
			serial_read_done_s<='0';
			serial_pstate<=serial_idle;
			else
			serial_pstate<=serial_nstate;
			case serial_pstate is
				when serial_idle => 
					 serial_read_done_s<='1'; 
				when serial_read =>
					 serial_read_done_s<='0'; 
            when serial_done => 
					 serial_read_done_s<='1'; 
            when others =>
					 serial_read_done_s<='0'; 
			end case;
		end if;
	end if;
end process;

process(fast_clk_i)             --FPGA读取计数器计数变化
begin
	if fast_clk_i'EVENT and fast_clk_i='1' then
		if buffer_reset_s='1' then
			sclk_cnt<=17;
		elsif (sclk_cnt>0 and clk_s='1')then
				sclk_cnt<=sclk_cnt-1;
			end if;
	end if;
end process;



-- Data In LVDS -> Single
   
  OBUFDS1_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT")
   port map (
     	I  => sdi_s   ,  -- Buffer output
     	O  => d_pos_i ,  -- Diff_p buffer input (connect directly to top-level port)
      OB => d_neg_i -- Diff_n buffer input (connect directly to top-level port)
   );

	
-- Serial Clock In LVDS -> Single  
  OBUFDS2_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT")
   port map (
		I  => sclk_s      ,  -- Buffer output
      O  => dco_pos_i   ,  -- Diff_p buffer input (connect directly to top-level port)
      OB => dco_neg_i   -- Diff_n buffer input (connect directly to top-level port)
   );

END;
