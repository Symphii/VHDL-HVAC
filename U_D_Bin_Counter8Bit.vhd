library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY U_D_Bin_Counter8bit IS port (
		CLK				: in std_logic;
		RESET				: in std_logic;
		CLK_EN			: in std_logic;
		UP1_DOWN0		: in std_logic;
		COUNTER_BITS	: out std_logic_vector(7 downto 0)
	);
end ENTITY;

ARCHITECTURE one OF U_D_Bin_Counter8bit IS
	signal ud_bin_counter	: UNSIGNED(7 downto 0);
	
	BEGIN
	
		process(CLK) is 
		begin
			
			if (rising_edge(CLK)) then
				if (RESET = '1') then
					ud_bin_counter <= "00000000";
					
				elsif(CLK_EN = '1') then
					if(UP1_DOWN0 = '1') then
						ud_bin_counter <= (ud_bin_counter + 1);
					
					else
						ud_bin_counter <= (ud_bin_counter - 1);
					
					end if;
					
				end if;
				
			end if;
			
			
			COUNTER_BITS <= std_logic_vector(ud_bin_counter);
			
		end process;
	
END one;

				
			