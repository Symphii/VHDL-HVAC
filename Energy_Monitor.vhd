library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Energy_Monitor IS port(
		AGTB 				: in std_logic;
		AEQB 				: in std_logic;
		ALTB 				: in std_logic;
		vacation_mode 	: in std_logic;
		MC_test_mode 	: in std_logic;
		window_open 	: in std_logic;
		door_open		: in std_logic;
		
		furnace			: out std_logic;
		at_temp			: out std_logic;
		AC					: out std_logic;
		blower			: out std_logic;
		window			: out std_logic;
		door				: out std_logic;
		vacation			: out std_logic;
		run				: out std_logic;
		increase			: out std_logic;
		decrease			: out std_logic
	);
	
end ENTITY;

ARCHITECTURE logic OF Energy_Monitor IS

	BEGIN
		
		-- HVAC
		run <= NOT(MC_test_mode OR window_open OR door_open OR AEQB);
		increase <= AGTB;
		decrease <= ALTB;
		
		-- LEDS
		AC <= ALTB;
		furnace <= AGTB;
		at_temp <= AEQB;
		blower <= NOT(MC_test_mode OR window_open OR door_open OR AEQB);
		door <= door_open;
		window <= window_open;
		vacation <= vacation_mode;
		
end logic;
		
		