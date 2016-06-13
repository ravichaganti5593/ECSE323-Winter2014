--Ravi Chaganti - 260469339
--Rohit Agarwal - 260465642
library ieee; 
use ieee.std_logic_1164.all;

library ieee;
use ieee.numeric_std.all; 

library lpm;   
use lpm.lpm_components.all;
entity g09_Test_Bed is --defined entity
		port( clock, reset: in std_logic;
		      LED3, LED2, LED1, LED0: out std_logic_vector(6 downto 0));
		end g09_Test_Bed;

architecture behavior of g09_Test_Bed is --defined architecture
signal enable : std_logic;
signal EPULSE : std_logic;
signal MPULSE : std_logic;
signal EARTH05ENABLE: std_logic;
signal MARS05ENABLE: std_logic;
signal EARTH09RESET: std_logic;
signal EARTH05RESET: std_logic;
signal MARS09RESET: std_logic;
signal MARS05RESET: std_logic;
signal EARTH_0_9_TEMP: std_logic_vector(3 downto 0);
signal MARS_0_9_TEMP: std_logic_vector(3 downto 0);
signal counter_reset: std_logic;
signal EARTH_1_9: std_logic;
signal MARS_1_9: std_logic;
signal Ripple_HIGH: std_logic;
signal Ripple_LOW: std_logic;
signal EARTH_0_9: std_logic_vector (3 downto 0);
signal MARS_0_9: std_logic_vector (3 downto 0);
signal EARTH_0_5: std_logic_vector (3 downto 0);
signal MARS_0_5: std_logic_vector (3 downto 0);
signal EARTH_0_5_TEMP: std_logic_vector(2 downto 0);
signal MARS_0_5_TEMP: std_logic_vector(2 downto 0);
signal temp: std_logic;

component g09_Basic_Timer is
port( clock, reset, enable : in std_logic;
		      EPULSE, MPULSE: out std_logic);
		end component;

component g09_7_segment_decoder		
port ( code            : in std_logic_vector(3 downto 0);
	   RippleBlank_In  : in std_logic;
	   RippleBlank_Out : out std_logic;
	   segments        : out std_logic_vector(6 downto 0));
	   
	   end component;

begin 
Ripple_HIGH <= '1';
Ripple_LOW <= '0';

enable<= '1';
counter_reset <= '0';

EARTH09RESET <= '1' when (EARTH_0_9_TEMP = "1010" or reset = '1') else '0';
EARTH_0_9 <= EARTH_0_9_TEMP;


EARTH_1_9 <= '1' when (EARTH_0_9_TEMP = "1001") else '0';
EARTH05ENABLE <= EARTH_1_9 AND EPULSE;

EARTH05RESET<= '1' when (EARTH_0_5_TEMP = "110" or reset = '1') else '0';
EARTH_0_5 <= '0' & EARTH_0_5_TEMP;



MARS09RESET <= '1' when (MARS_0_9_TEMP = "1010" or reset = '1') else '0';
MARS_0_9 <= MARS_0_9_TEMP;

MARS_1_9 <= '1' when (MARS_0_9_TEMP = "1001") else '0';
MARS05ENABLE <= MARS_1_9 AND MPULSE;

MARS05RESET<= '1' when (MARS_0_5_TEMP = "110" or reset = '1') else '0';
MARS_0_5 <= '0' & MARS_0_5_TEMP;





pulse_creator : g09_Basic_Timer
PORT MAP (
		reset => reset,
		clock => clock,
		enable => enable,
		EPULSE => EPULSE,
		MPULSE=> MPULSE
	);
	
Earth_0_9_Decoder : g09_7_segment_decoder
PORT MAP (
		code=>EARTH_0_9,
		RippleBlank_In=>Ripple_LOW,
		RippleBlank_Out=>,
		segments=>LED2
);
Earth_0_5_Decoder : g09_7_segment_decoder
PORT MAP (
		code=>EARTH_0_5,
		RippleBlank_In=>Ripple_HIGH,
		RippleBlank_Out=>temp,
		segments=>LED3
);

Mars_0_9_Decoder : g09_7_segment_decoder
PORT MAP (
		code=>MARS_0_9,
		RippleBlank_In=>Ripple_LOW,
		RippleBlank_Out=>temp,
		segments=>LED0
);

Mars_0_5_Decoder : g09_7_segment_decoder
PORT MAP (
		code=>MARS_0_5,
		RippleBlank_In=>Ripple_HIGH,
		RippleBlank_Out=>temp,
		segments=>LED1
);
	

Earth_0to9: lpm_counter
	GENERIC MAP (
		lpm_direction => "UP",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 4
	)
	PORT MAP (
		clk_en => EPULSE,
		aclr => EARTH09RESET,
		clock => clock,
		q => EARTH_0_9_TEMP
	);
	
Earth_0to5 : lpm_counter
	GENERIC MAP (
		lpm_direction => "UP",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 3
	)
	PORT MAP (
		clk_en => EARTH05ENABLE,
		aclr => EARTH05RESET,
		clock => clock,
		q => EARTH_0_5_TEMP
	);
Mars_0to9: lpm_counter
	GENERIC MAP (
		lpm_direction => "UP",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 4
	)
	PORT MAP (
		clk_en => MPULSE,
		aclr => MARS09RESET,
		clock => clock,
		q => MARS_0_9_TEMP
	);
	
Mars_0to5 : lpm_counter
	GENERIC MAP (
		lpm_direction => "UP",
		lpm_port_updown => "PORT_UNUSED",
		lpm_type => "LPM_COUNTER",
		lpm_width => 3
	)
	PORT MAP (
		clk_en => MARS05ENABLE,
		aclr => MARS05RESET,
		clock => clock,
		q => MARS_0_5_TEMP
	);
	
	
	
	
end behavior;

