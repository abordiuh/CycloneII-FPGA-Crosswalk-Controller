-- PROGRAM		"ARTEM BORDIUH LAB10"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Full Version"
-- CREATED		"Wed April 12 12:40:00 2017"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library altera;
use altera.altera_syn_attributes.all;

entity ABordiuh_Lab10 is
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		Button : in std_logic;
		CLK : in std_logic;
		Green : out std_logic;
		Red : out std_logic;
		SevenSeg : out std_logic_vector(0 to 6);
		SevenSeg1 : out std_logic_vector(0 to 6);
		Yellow : out std_logic
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
	);
-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end ABordiuh_Lab10;

architecture CrossWalk of ABordiuh_Lab10 is
-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
constant ClockTicks : integer:= 27000000;
constant tenBase : integer:= 10;
signal counter: integer range 0 to ClockTicks-1:=0;
signal onesecond: std_logic:='0';
signal Rled: std_logic:='0';
signal YLed: std_logic:='0';
signal Gled: std_logic:='0';
signal traffic: integer range 0 to 2:=0;
signal seven0:integer range 9 downto 0:=4;
signal seven1:integer range 9 downto 0:=1;
signal pressedButton:std_logic:='0';
signal inprogress:std_logic:='0';	

procedure DISPLAY_NUMBER_SEVSEG(
signal sev_numb : in integer range 14 downto 0;
signal sev_leds_out : out std_logic_vector(0 to 6)
 ) is
begin
	case sev_numb is 
		when 0 => sev_leds_out <= "0000001"; --"0" 
		when 1 => sev_leds_out <= "1001111"; --"1"
		when 2 => sev_leds_out <= "0010010"; --"2"
		when 3 => sev_leds_out <= "0000110"; --"3"
		when 4 => sev_leds_out <= "1001100"; --"4"
		when 5 => sev_leds_out <= "0100100"; --"5"
		when 6 => sev_leds_out <= "0100000"; --"6"
		when 7 => sev_leds_out <= "0001111"; --"7"
		when 8 => sev_leds_out <= "0000000"; --"8"
		when 9 => sev_leds_out <= "0000100"; --"9"
		when others => sev_leds_out <= "XXXXXXX"; 
	end case;
end DISPLAY_NUMBER_SEVSEG;	

begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!								  

delaysec:process(CLK) 
begin
if(rising_edge(CLK)) then 

	--Counter 
	if(counter = ClockTicks-1) then 
	counter <= 0;
	else
	counter <= counter + 1;
	end if;

	if(Button='0') then
	pressedButton<='1';
	end if;

	if(inprogress='1') then
		if(counter=0) then
			
			DISPLAY_NUMBER_SEVSEG(seven0, SevenSeg);
			DISPLAY_NUMBER_SEVSEG(seven1, SevenSeg1);
			
			if(seven1>0) then		
				if(seven0>0) then
					seven0<=seven0-1;
				else
					seven0<=9;
					seven1<=0;
				end if;
			else
			if(seven0>0) then
				seven0<=seven0-1;
			else
			pressedButton<='0';
			seven0<=4;
			seven1<=1;
			end if;
			end if;
		end if;
	end if;
	
	if(pressedButton='1') then
	
		if(counter=0) then	
			if(traffic=0) then
				Rled<='0';
				YLed<='0';
				Gled<='1';
			elsif (traffic=1) then
				Gled<='0';
				Rled<='0';
				YLed<='1';
			elsif(traffic=2) then
				Gled<='0';
				Rled<='1';
				YLed<='0';
				inprogress<='1';
			end if;
			
			if(traffic<2) then
			traffic<=traffic+1;
			end if;
		end if;
		
	else 
	Rled<='0';
	YLed<='0';
	Gled<='1';
	traffic<=0;
	SevenSeg<="1111111";
	SevenSeg1<="1111111";
	inprogress<='0';
	end if;
end if;
end process delaysec;

Red<=Rled;
Green<=Gled;
Yellow<=Yled;

end;

