-- Jeffrey Jiang and Dennis Chen

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- [ENTITY]

ENTITY multiplexer_2_to_1 IS
	PORT(
		in_0 		: in std_logic_vector(3 downto 0);	-- multiplexer inputs
		in_1 		: in std_logic_vector(3 downto 0);
		switch 	: in std_logic;							-- selector input
		output	: out std_logic_vector(3 downto 0)	-- multiplexer output
	);
END multiplexer_2_to_1;

-- [ARCHITECTURE]

ARCHITECTURE multiplexer_logic OF multiplexer_2_to_1 IS
	
	-- CIRCUIT
	BEGIN
		
		-- Toggle output depending on switch to be in_0 or in_1
		with switch select
		output <= in_0 when '0',
					 in_1 when '1';
					 
END multiplexer_logic;