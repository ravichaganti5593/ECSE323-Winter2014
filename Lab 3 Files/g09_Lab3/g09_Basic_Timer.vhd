--Ravi Chaganti - 260469339
--Rohit Agarwal - 260465642
library ieee; 
use ieee.std_logic_1164.all;

library ieee;
use ieee.numeric_std.all; 

library lpm; 
use lpm.lpm_components.all;
entity g09_Basic_Timer is --defined entity
		port( clock, reset, enable : in std_logic;
		      EPULSE, MPULSE: out std_logic);
		end g09_Basic_Timer;
	
architecture behavior of g09_Basic_Timer is --defined architecture
signal const_mars: std_logic_vector(25 downto 0);
signal TEMP_PULSE_mars: std_logic;
signal const_earth: std_logic_vector(25 downto 0);
signal TEMP_PULSE_earth: std_logic;
signal counter_output_mars: std_logic_vector(25 downto 0);
signal counter_load_mars: std_logic;
signal counter_output_earth: std_logic_vector(25 downto 0);
signal counter_load_earth: std_logic;
begin
TEMP_PULSE_earth <= '1' when (counter_output_earth = "00000000000000000000000000") else '0';
counter_load_earth <= reset OR TEMP_PULSE_earth;
EPULSE <= TEMP_PULSE_earth;
TEMP_PULSE_mars <= '1' when (counter_output_mars = "00000000000000000000000000") else '0';
counter_load_mars <= reset OR TEMP_PULSE_mars;
MPULSE <= TEMP_PULSE_mars;

g09_lpm_counter_earth : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 26
	)
	PORT MAP (
		sload => counter_load_earth,
		clock => clock,
		data => const_earth,
		cnt_en => enable,
		q => counter_output_earth
	);
	
	g09_constant_earth : lpm_constant
	GENERIC MAP (
		lpm_cvalue => 49999999,
		--lpm_cvalue=>20,
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "LPM_CONSTANT",
		lpm_width => 26
	)
	PORT MAP (
		result => const_earth
	);
	
	g09_lpm_counter_mars : lpm_counter
	GENERIC MAP (
		lpm_direction => "DOWN",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 26
	)
	PORT MAP (
		sload => counter_load_mars,
		clock => clock,
		data => const_mars,
		cnt_en => enable,
		q => counter_output_mars
	);
	
	g09_constant_mars : lpm_constant
	GENERIC MAP (
		--lpm_cvalue => 23,
		lpm_cvalue => 51374562,
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "LPM_CONSTANT",
		lpm_width => 26
	)
	PORT MAP (
		result => const_mars
	);
end behavior;	
	