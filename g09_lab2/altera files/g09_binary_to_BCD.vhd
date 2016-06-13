-- this circuit converts a 6-bit binary number to a 2-digit BCD representation
--
-- entity name: g31_binary_to_BCD
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

entity g09_binary_to_BCD is
	port(	clock	: in std_logic;
			bin		: in unsigned(5 downto 0);
			BCD		: out std_logic_vector(7 downto 0));
end g09_binary_to_BCD;

Architecture impl of g09_binary_to_BCD is

begin
	
	crc_rom: lpm_rom
	GENERIC MAP (
		lpm_file => "g09_lookuptable.mif",
		lpm_outdata => "UNREGISTERED",
		lpm_address_control => "REGISTERED",
		lpm_numwords => 64,
		lpm_widthad => 6,
		lpm_width => 8
	)
	PORT MAP (
		inclock => clock,
		address => std_logic_vector(bin),
		q => BCD
	);
	
	
end impl;