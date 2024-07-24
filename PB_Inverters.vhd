library ieee;
use ieee.std_logic_1164.all;

entity PB_Inverters is
port (
	pb_n 	: in std_logic_vector(3 downto 0);
	pb		: out std_logic_vector(3 downto 0)		
);

end PB_Inverters;

architecture gates of PB_Inverters is

begin

pb <= not(pb_n);
				  
end gates;
