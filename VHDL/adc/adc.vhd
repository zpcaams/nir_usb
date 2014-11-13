----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:24:44 11/06/2014 
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
    Port ( m_clk_i   :   in  STD_LOGIC;        --FPGA输入时钟@50MHz
           m_rst_i   :   in  STD_LOGIC;        --全局复位，低电平有效
           sen_tri   :   in  STD_LOGIC;        --传感器反馈信号，触发ADC采集
	    --  sen_clk   :   out  STD_LOGIC;       --ADC忽略此行
       --  sen_rst   :   out  STD_LOGIC;       --ADC忽略此行
			  
			  fast_clk_i:   in  STD_LOGIC;
		 --  en_i      :   in  STD_LOGIC_VECTOR(3 downto 0);
			  d_pos_i   :   in  STD_LOGIC;
			  d_neg_i   :   in  STD_LOGIC;
			  dco_pos_i :   in  STD_LOGIC;
			  dco_neg_i :   in  STD_LOGIC;
		 --  en_o      :   out STD_LOGIC_VECTOR(3 downto 0);
			  cnv_pos_o :   out STD_LOGIC;
			  cnv_neg_o :   out STD_LOGIC;
			  clk_pos_o :   out STD_LOGIC;
			  clk_neg_o :   out STD_LOGIC;
		     data_rd_rdy_o:out STD_LOGIC;                --数据来临指示,待删除
		     data_o     :  out STD_LOGIC_VECTOR(15 DOWNTO 0));--连接串行输入buffer,测试时观察数据输出用
end adc;

ARCHITECTURE Behavioral of adc is

signal cnv_s : std_logic;
signal sdi_s : std_logic;
signal sclk_s : std_logic;
signal adc_clk: std_logic;
signal serial_buffer:std_logic_vector(15 downto 0);
signal clk_s : std_logic;
signal tmsb_done_s : std_logic;
signal buffer_reset_s : std_logic;
signal sclk_cnt : integer range 0 to 17;
signal sclk_echo_cnt : integer range 0 to 17;
signal serial_read_done_s : std_logic;                        -- 126行
signal adc_tcyc_cnt : integer range 0 to 20;    
TYPE states is(serial_idle,serial_read,serial_done);  --ADC控制引脚定义
signal serial_pstate,serial_nstate:states;
 

begin


--定义clk_s
process(serial_read_done_s,sclk_cnt,buffer_reset_s)
begin
	if (serial_read_done_s='0' and sclk_cnt>0  and buffer_reset_s/='1')then
		clk_s<='1';
		else
		clk_s<='0';
	end if;
end process;

--定义data_rd_rdy_o
process(serial_read_done_s,adc_tcyc_cnt)
begin
	if adc_tcyc_cnt=12 then
		data_rd_rdy_o<='1';
		else
		data_rd_rdy_o<='0';
	end if;
end process;

--定义cnv_s
process(adc_tcyc_cnt)  --启动转换，保持两个主时钟，
begin
	if m_rst_i='0' then
		cnv_s<='0';
	elsif (adc_tcyc_cnt>17)then
			cnv_s<='1';
			else
			cnv_s<='0';
		end if;
end process;

--定义tmsb_done_s
process(adc_tcyc_cnt)
begin
	if (adc_tcyc_cnt=18)then
		tmsb_done_s<='1';
		else
		tmsb_done_s<='0';
	end if;
end process;

--定义buffer_reset_s
process(adc_tcyc_cnt)  --过4个时钟后，buffer reset置零，准备发送数据
begin
	if (adc_tcyc_cnt=12)then
		buffer_reset_s<='1';
		else
		buffer_reset_s<='0';
	end if;
end process;


--adc_tcyc_cnt计数变化
process(m_clk_i,m_rst_i)
begin
if rising_edge(m_clk_i) then		
	 if m_rst_i='0' then					--若需触发rising_edge(sen_tri)
			adc_tcyc_cnt<=20;
		elsif adc_tcyc_cnt>0 then
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

process(sclk_s,buffer_reset_s)                --FPGA读取数据阶段
begin
	if(sclk_s'EVENT and sclk_s='1') then
		if buffer_reset_s='1' then
			serial_buffer<="0000000000000000";
			sclk_echo_cnt<=17;
		elsif sclk_echo_cnt>0 then
			sclk_echo_cnt<=sclk_echo_cnt-1;
			serial_buffer(15 downto 0)<=serial_buffer(14 downto 0)&sdi_s;
		end if;
	end if;
end process;
	
data_o<=serial_buffer;


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
     	O  => sdi_s   ,  -- Buffer output
     	I  => d_pos_i ,  -- Diff_p buffer input (connect directly to top-level port)
      IB => d_neg_i -- Diff_n buffer input (connect directly to top-level port)
   );

	
-- Serial Clock In LVDS -> Single  
 IBUFDS2_inst : IBUFDS
   generic map (
      DIFF_TERM => FALSE, -- Differential Termination
      IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, 
                               -- "0"-"16" 
      IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, 
                                 -- "AUTO", "0"-"8" 
      IOSTANDARD => "DEFAULT")
   port map (
		O  => sclk_s      ,  -- Buffer output
      I  => dco_pos_i   ,  -- Diff_p buffer input (connect directly to top-level port)
      IB => dco_neg_i   -- Diff_n buffer input (connect directly to top-level port)
   );

	
-- Single -> LVDS
  OBUFDS1_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT")
   port map (
      O   => cnv_pos_o   ,     -- Diff_p output (connect directly to top-level port)
      OB  => cnv_neg_o  ,   -- Diff_n output (connect directly to top-level port)
      I   => cnv_s      -- Buffer input 
   );


-- Clock Out Single -> LVDS
OBUFDS2_inst : OBUFDS
	 generic map (
      IOSTANDARD => "DEFAULT"
		)
   port map (
      O   => clk_pos_o ,     -- Diff_p output (connect directly to top-level port)
      OB  => clk_neg_o ,   -- Diff_n output (connect directly to top-level port)
      I   => adc_clk      -- Buffer input 
   );
	adc_clk<=fast_clk_i and clk_s;


end Behavioral;