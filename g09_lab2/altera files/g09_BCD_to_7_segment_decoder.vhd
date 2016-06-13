-- this circuit converts a 6-bit binary number to a 2-digit BCD representation
--
-- entity name: g00_binary_to_BCD
--
-- Copyright (C) 2014 James Clark
-- Version 1.0
-- Author: James J. Clark; clark@cim.mcgill.ca
-- Date: January 19, 2014
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- allows use of the unsigned type
library lpm; -- allows use of the Altera library modules
use lpm.lpm_components.all;

entity g09_BCD_to_7_segment_decoder is

port ( 
clock : in std_logic; -- to clock the lpm_rom register
bin : in unsigned(5 downto 0);
output : out std_logic_vector(27 downto 0));

end g09_BCD_to_7_segment_decoder;

architecture implementation of g09_BCD_to_7_segment_decoder is

component g09_7_segment_decoder 
	port ( 
	code : in std_logic_vector(3 downto 0); 
	RippleBlank_In : in std_logic; 
	RippleBlank_Out : out std_logic; 
	segments : out std_logic_vector(6 downto 0));
end component;

component g09_binary_to_BCD 
port ( 
clock : in std_logic; -- to clock the lpm_rom register
bin : in unsigned(5 downto 0);
BCD : out std_logic_vector(7 downto 0));

end component;

signal C1, C2, C3, C4, C5, C6, C7, C8 : std_logic;
signal outputBCD : std_logic_vector (7 downto 0);

begin 
C1<= '1';
C4<= '0';
C6<= '1';
C5 <= '1';

inst1: g09_binary_to_BCD PORT MAP (BCD => outputBCD, bin => bin, clock => clock);
inst2: g09_7_segment_decoder PORT MAP (code => outputBCD(7 downto 4), RippleBlank_In => C1, RippleBlank_Out => C3, segments => output(13 downto 7));
inst3: g09_7_segment_decoder PORT MAP (code => outputBCD(3 downto 0), RippleBlank_In => C2, RippleBlank_Out => C4, segments =>output(6 downto 0));
inst4: g09_7_segment_decoder PORT MAP (code => "0000", RippleBlank_In => C5, RippleBlank_Out => C7, segments => output(27 downto 21));
inst5: g09_7_segment_decoder PORT MAP (code => "0000", RippleBlank_In => C6, RippleBlank_Out => C8, segments => output(20 downto 14));


end implementation;