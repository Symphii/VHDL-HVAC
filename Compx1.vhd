library ieee;
use ieee.std_logic_1164.all;

ENTITY Compx1 is port(
	-- Inputs
	a : in std_logic;
	b : in std_logic;
	
	-- Outputs
	greater : out std_logic;
	equal   : out std_logic;
	lesser  : out std_logic
);
end Compx1;

ARCHITECTURE logic of Compx1 is
	
	-- Choose output 
	BEGIN
			greater <= (a AND (NOT b));
			equal <= (a XNOR b);
			lesser <= ((NOT a) AND b);
	
END logic;

		
	
		