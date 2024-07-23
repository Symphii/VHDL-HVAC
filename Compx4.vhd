library ieee;
use ieee.std_logic_1164.all;

ENTITY Compx4 IS
	port( 
		A : in std_logic_vector(3 downto 0);
		B : in std_logic_vector(3 downto 0); 
		AGTB : out std_logic;
		AEQB : out std_logic;
		ALTB : out std_logic
	);
END Compx4;

ARCHITECTURE logic OF Compx4 IS

	component Compx1 port(
		a : in std_logic;
		b: in std_logic; 
		greater : out std_logic; 
		equal : out std_logic;
		lesser : out std_logic
		);
	END component;
	
	-- Results vector
	-- 3: 11-9 
	-- 2: 8-6 
	-- 1: 5-3
	-- 0: 2-0
	signal r : std_logic_vector(11 downto 0);
	
	begin 
		
		-- Create 4 1bit comparators
		INST1: Compx1 port map(A(0), B(0), r(2), r(1), r(0));
		INST2: Compx1 port map(A(1), B(1), r(5), r(4), r(3));
		INST3: Compx1 port map(A(2), B(2), r(8), r(7), r(6));
		INST4: Compx1 port map(A(3), B(3), r(11), r(10), r(9));
		
		-- Sum of products
		AGTB <= (r(11) OR (r(10) AND r(8)) OR (r(10) AND r(7) AND r(5)) OR (r(10) AND r(7) AND r(4) AND r(2)));
		AEQB <= (r(10) AND r(7) AND r(4) AND r(1));
		ALTB <= (r(9) OR (r(10) AND r(6)) OR (r(10) AND r(7) AND r(3)) OR (r(10) AND r(7) AND r(4) AND r(0)));
	
END logic;
