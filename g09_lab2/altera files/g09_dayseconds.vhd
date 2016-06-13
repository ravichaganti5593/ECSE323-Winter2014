
library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type

library lpm;
use lpm.lpm_components.all; -- allows use of the Altera library modules

entity g09_dayseconds is
port (  Hours : in unsigned(4 downto 0);
		Minutes, Seconds : in unsigned(5 downto 0);
		DaySeconds : out unsigned(16 downto 0));
end g09_dayseconds;


architecture implementation of g09_dayseconds is

signal multiplication1  : std_logic_vector(10 downto 0);
signal add1   : std_logic_vector(10 downto 0);
signal multiplication2   : std_logic_vector(16 downto 0);
signal add2   : std_logic_vector(16 downto 0);
signal totalseconds : std_logic_vector(16 downto 0);

begin

lpm_multiplier1 : lpm_mult
GENERIC MAP (
	lpm_representation => "UNSIGNED",
	lpm_type => "LPM_MULT",
	lpm_widtha => 6,
	lpm_widthb => 5,
	lpm_widthp => 11
)
PORT MAP (
	dataa => "111100",
	datab => std_logic_vector(Hours),
	result => multiplication1);    

lpm_adder1 : lpm_add_sub
GENERIC MAP (
	lpm_direction => "ADD",
	lpm_representation => "UNSIGNED",
	lpm_type => "LPM_ADD_SUB",
	lpm_width => 11
)
PORT MAP (
	dataa => multiplication1,
	datab => std_logic_vector("00000" & Minutes),
	result => add1 );

 
lpm_multiplier2 : lpm_mult
GENERIC MAP (
	lpm_representation => "UNSIGNED",
	lpm_type => "LPM_MULT",
	lpm_widtha => 11,
	lpm_widthb => 6,
	lpm_widthp => 17
)
PORT MAP (
	dataa => add1,
	datab => "111100",
	result => multiplication2  );    
 
 
lpm_adder2 : lpm_add_sub
GENERIC MAP (
	lpm_direction => "ADD",
	lpm_representation => "UNSIGNED",
	lpm_type => "LPM_ADD_SUB",
	lpm_width => 17
)
PORT MAP (
	dataa => multiplication2 ,
	datab => std_logic_vector("00000000000" & Seconds),
	result => totalseconds );

DaySeconds <= unsigned (totalseconds);
  
end implementation;