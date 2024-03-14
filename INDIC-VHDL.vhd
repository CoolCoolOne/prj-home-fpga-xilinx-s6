library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;

entity melt01 is
  port( sys_clk : in std_logic; 
        sys_rst_n : in std_logic;
        led_1 : out std_logic;
		  led_2 : out std_logic;
		  
		  --Ucc     : out std_logic;
		  --GNDmelt     : out std_logic;
	     E         : out std_logic;
	     RW         : out std_logic;
		  A0         : out std_logic;
	     DB0         : out std_logic;
	     DB1         : out std_logic;
	     DB2         : out std_logic;
	     DB3         : out std_logic;
		  DB4         : out std_logic;
		  DB5         : out std_logic;
		  DB6         : out std_logic;
		  DB7         : out std_logic
	  );
      end melt01;

architecture A_melt01 of melt01 is

signal r_led: std_logic:= '1';
signal l_led: std_logic:= '1';

signal s_mute: std_logic:= '0';

signal s_o_Ucc: std_logic:= '1';
signal s_o_E: std_logic:= '1';
signal s_o_RW: std_logic:= '1';
signal s_o_A0: std_logic:= '1';

signal s_o_DB7to0: std_logic_vector(7 downto 0):= (others => '1');

signal counter : std_logic_vector(31 downto 0):= (others => '0');

type   SEQuenced_STATES is (wait1,wait2,wait3 ,set_capacity1, set_capacity2, set_capacity3, set_param, down_displ, 
         						clear_displ,set_mode,wait4,symb_x,symb_A,symb_B,symb7,symb8,symb9,symb10,symb11,symb12);
							 
signal SEQ_STATE : SEQuenced_STATES;



begin

count : process(sys_clk,sys_rst_n) -- первый процесс счетчика
  begin
    if(sys_rst_n = '0') then -- обнуляем счетчик, когда res = 1, как видно сброс асинхронный
      counter <= (others => '0');
    elsif(rising_edge(sys_clk)) then -- здесь ждем фронта сигнала и увеличиваем на единицу значение в счетчике, если будет фронт
      if (counter = 5000000) then
		counter <= (others => '0');
		else
		counter <= counter +1;
		end if;
    end if;
  end process;
  
leds : process(sys_clk,sys_rst_n, s_mute) -- первый процесс счетчика
--leds : process(sys_clk,sys_rst_n) -- первый процесс счетчика
  begin
    if(sys_rst_n = '0') then -- обнуляем счетчик, когда res = 1, как видно сброс асинхронный
      l_led <= '0';
		r_led <= '0';
		s_o_E  <= '1';
    elsif(rising_edge(sys_clk)) then -- здесь ждем фронта сигнала и увеличиваем на единицу значение в счетчике, если будет фронт
	   if (s_mute = '0') then
        if (counter < 2500000) then
		  l_led <= '0';
		  r_led <= '1';
		  s_o_E  <= '1';
		  else
		  l_led <= '1';
		  r_led <= '0';
		  s_o_E  <= '0';
		  end if;
		else
       s_o_E  <= '0';  
      end if;		  
    end if;
  end process;
  
  
segments : process(sys_clk,sys_rst_n,counter) -- первый процесс счетчика
  begin
    if(sys_rst_n = '0') then -- обнуляем счетчик, когда res = 1, как видно сброс асинхронный
      s_o_DB7to0 <= "00000000";
        s_o_A0 <='0';
		  s_o_RW <='0';
		  	  
		  --s_o_Ucc <='1';
		  s_mute  <= '0';
		  SEQ_STATE  <= wait1;
    elsif(rising_edge(sys_clk)) then -- здесь ждем фронта сигнала и увеличиваем на единицу значение в счетчике, если будет фронт
      case SEQ_STATE is
when wait1 =>
         --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= wait2;
		   else
		   SEQ_STATE  <= wait1;
		   end if;
when wait2 =>
         --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= wait3;
		   else
		   SEQ_STATE  <= wait2;
		   end if;
when wait3 =>
         --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= set_capacity1;
		   else
		   SEQ_STATE  <= wait3;
		   end if;
when set_capacity1 =>
         s_o_DB7to0 <= "00111100";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= set_capacity2;
		   else
		   SEQ_STATE  <= set_capacity1;
		   end if;	
when set_capacity2 =>
         s_o_DB7to0 <= "00111100";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= set_capacity3;
		   else
		   SEQ_STATE  <= set_capacity2;
		   end if;			
when set_capacity3 =>
         s_o_DB7to0 <= "00001100";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= set_param;
		   else
		   SEQ_STATE  <= set_capacity3;
		   end if;			
when set_param =>
         s_o_DB7to0 <= "00000001";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= down_displ;
		   else
		   SEQ_STATE  <= set_param;
		   end if;
when down_displ =>
         s_o_DB7to0 <= "00000110";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= clear_displ;
		   else
		   SEQ_STATE  <= down_displ;
		   end if;
when clear_displ =>
         s_o_DB7to0 <= "00111100";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= set_mode;
		   else
		   SEQ_STATE  <= clear_displ;
		   end if;	
when set_mode =>
         s_o_DB7to0 <= "10100100";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= wait4;
		   else
		   SEQ_STATE  <= set_mode;
		   end if;
when wait4 =>
         s_o_DB7to0 <= "01100001";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb_x;
		   else
		   SEQ_STATE  <= wait4;
		   end if;				
when symb_x =>
         s_o_DB7to0 <= "01110000";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb_A;
		   else
		   SEQ_STATE  <= symb_x;
		   end if;	
when symb_A =>
         s_o_DB7to0 <= "01100001";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb_B;
		   else
		   SEQ_STATE  <= symb_A;
		   end if;	
when symb_B =>
         s_o_DB7to0 <= "10110010";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   s_o_Ucc <='1';
			if (counter = 5000000) then
		   --s_mute  <= '1';
			SEQ_STATE  <= symb7;
		   else
		   SEQ_STATE  <= symb_B;
		   end if;
when symb7 =>
         s_o_DB7to0 <= "01101111";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb8;
		   else
		   SEQ_STATE  <= symb7;
		   end if;	
when symb8 =>
         s_o_DB7to0 <= "10111111";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb9;
		   else
		   SEQ_STATE  <= symb8;
		   end if;	
when symb9 =>
         s_o_DB7to0 <= "01100001";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb10;
		   else
		   SEQ_STATE  <= symb9;
		   end if;		
when symb10 =>
         s_o_DB7to0 <= "10111011";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb11;
		   else
		   SEQ_STATE  <= symb10;
		   end if;	
when symb11 =>
         s_o_DB7to0 <= "01101111";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   SEQ_STATE  <= symb12;
		   else
		   SEQ_STATE  <= symb11;
		   end if;	
when symb12 =>
         s_o_DB7to0 <= "00111110";
         s_o_A0 <='1';
		   s_o_RW <='0';
		   --s_o_Ucc <='1';
			if (counter = 5000000) then
		   --SEQ_STATE  <= symb12;
			s_mute  <= '1';
		   else
		   SEQ_STATE  <= symb12;
		   end if;				
when others =>
         s_o_DB7to0 <= "00000000";
         s_o_A0 <='0';
		   s_o_RW <='0';
		   s_o_Ucc <='1';
			s_mute  <= '1';
end case;
		end if;
    
  end process;
  
--GNDmelt     <='0';  
--Ucc     <= '1';
E       <= s_o_E;
RW      <= s_o_RW;
A0      <= s_o_A0;
DB0     <= s_o_DB7to0(0);
DB1     <= s_o_DB7to0(1);
DB2     <= s_o_DB7to0(2);
DB3     <= s_o_DB7to0(3);
DB4     <= s_o_DB7to0(4);
DB5     <= s_o_DB7to0(5);
DB6     <= s_o_DB7to0(6);
DB7     <= s_o_DB7to0(7);

--Ucc     <= '1';
--E       <= '1';
--RW      <= '1';
--A0      <= '1';
--DB0     <= '1';
--DB1     <= '1';
--DB2     <= '1';
--DB3     <= '0';
--DB4     <= '0';
--DB5     <= '0';
--DB6     <= '1';
--DB7     <= '1';

 led_1 <= l_led;
 led_2 <= r_led;
 
 end A_melt01;

