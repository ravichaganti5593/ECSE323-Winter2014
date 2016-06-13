--Ravi Chaganti - 260469339
--Rohit Agarwal - 260465642
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	   entity g09_7_segment_decoder is --defined entity
port ( code            : in std_logic_vector(3 downto 0);
	   RippleBlank_In  : in std_logic;
	   RippleBlank_Out : out std_logic;
	   segments        : out std_logic_vector(6 downto 0));
	   end g09_7_segment_decoder;
	  
	   architecture behavior of g09_7_segment_decoder is --defined architecture
	   signal concat_input : std_logic_vector(4 downto 0);
	   signal concat_segments : std_logic_vector(7 downto 0);
	   begin
	   concat_input<= (RippleBlank_In & code);	
	   with concat_input select
	   concat_segments <= 
		
		"01000000" when "00000",
		"01111001" when "00001",
		"00100100" when "00010",
		"00110000" when "00011",
		"00011001" when "00100",
		"00010010" when "00101",
		"00000010" when "00110",
		"01111000" when "00111",
		"00000000" when "01000",
		"00011000" when "01001",
		"00001000" when "01010",
		"00000011" when "01011",
		"01000110" when "01100",
		"00100001" when "01101",
		"00000110" when "01110",
		"00001110" when "01111",
		"11111111" when "10000",
	    "01111001" when "10001",
		"00100100" when "10010",
		"00110000" when "10011",
		"00011001" when "10100",
		"00010010" when "10101",
		"00000010" when "10110",
		"01111000" when "10111",
		"00000000" when "11000",
		"00011000" when "11001",
		"00001000" when "11010",
		"00000011" when "11011",
		"01000110" when "11100",
		"00100001" when "11101",
		"00000110" when "11110",
		"00001110" when "11111",
		"11111111" when others;
	
		RippleBlank_Out<=concat_segments(7);
		segments<=concat_segments(6) & concat_segments(5) &concat_segments(4) & concat_segments(3) & concat_segments(2) & concat_segments(1) & concat_segments(0) ;
			
		end behavior;			