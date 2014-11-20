----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:25 11/20/2014 
-- Design Name: 
-- Module Name:    ad - Architecture 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad is
    Port ( fast_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  trig : in STD_LOGIC;
           d_pos : in  STD_LOGIC;
           d_neg : in  STD_LOGIC;
           dco_pos : in  STD_LOGIC;
           dco_neg : in  STD_LOGIC;
           cnv_pos : out  STD_LOGIC;
           cnv_neg : out  STD_LOGIC;
           clk_pos : out  STD_LOGIC;
           clk_neg : out  STD_LOGIC);
end ad;

Architecture ad of ad is
--第一层 单端&差分	
    component d_buf                      --数据端口
          port(d_pos : in std_logic;
               d_neg : in std_logic;
               data : out std_logic);
    end component;
                             
      component dco_buf                  --回波时钟
          port(dco_pos : in std_logic;
               dco_neg : in std_logic;
               dco: out std_logic);
    end component;
   
      component cnv_buf                  --转换信号CNV
          port( cnv : in std_logic;
			cnv_pos : out std_logic;
               cnv_neg : out std_logic);
	 end component;    
    
     component sclk_buf                   --adc_clk
          port(sclk : in std_logic;
			      clk_pos : out std_logic;
               clk_neg : out std_logic);
    end component; 
    
 --第二层 adc控制模块
	    
     component adc                   --adc_clk
          port(fast_clk : in std_logic;
               reset : in std_logic;
					trig : in STD_LOGIC;
					data : in std_logic;
               dco : in std_logic;
					cnv : out std_logic;
               sclk : out std_logic;
					data_reg : out std_logic_vector(15 downto 0));
    end component; 
    
 --第三层 adc控制模块	    
	COMPONENT fifo
	  PORT (
	    clk : IN STD_LOGIC;
	    din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	    wr_en : IN STD_LOGIC;
	    rd_en : IN STD_LOGIC;
	    dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	    full : OUT STD_LOGIC;
	    empty : OUT STD_LOGIC
	  );
	END COMPONENT;
signal data,dco,cnv,sclk,wr_en,rd_en : std_logic;
signal data_reg : std_logic_vector(15 downto 0);
    


begin
u1_d_buf    :   d_buf   port map(d_pos,d_neg,data);
u2_dco_buf  :   dco_buf  port map(dco_pos,dco_neg,dco);
u3_cnv_buf  :   cnv_buf  port map(cnv,cnv_pos,cnv_neg);
u4_sclk_buf :   sclk_buf port map(sclk,clk_pos,clk_neg);
u5_adc      :   adc      port map(fast_clk,reset,trig,data,dco,cnv,sclk,data_reg);
u6_fifo     :   fifo     port map(fast_clk,data_reg,wr_en,rd_en,open,open,open);

end Architecture;

