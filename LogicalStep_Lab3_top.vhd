library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
	--HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;

component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------

component Compx4 port( 
		A : in std_logic_vector(3 downto 0);
		B : in std_logic_vector(3 downto 0); 
		AGTB : out std_logic;
		AEQB : out std_logic;
		ALTB : out std_logic
	);
end component Compx4;

component Bidir_shift_reg port(
		CLK				: in std_logic;
		RESET				: in std_logic;
		CLK_EN			: in std_logic;
		LEFT0_RIGHT1	: in std_logic;
		REG_BITS 		: out std_logic_vector(7 downto 0)
		);
	
end component Bidir_shift_reg;

component U_D_Bin_Counter8Bit port(
		CLK				: in std_logic;
		RESET				: in std_logic;
		CLK_EN			: in std_logic;
		UP1_DOWN0		: in std_logic;
		COUNTER_BITS	: out std_logic_vector(7 downto 0)
	);
	
end component U_D_Bin_Counter8bit;

component Energy_Monitor port(
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
end component Energy_Monitor;

component PB_Inverters port(
	pb_n 	: in std_logic_vector(3 downto 0);
	pb		: out std_logic_vector(3 downto 0)		
);
end component PB_Inverters;

component multiplexer_2_to_1 port(
		in_0 		: in std_logic_vector(3 downto 0);	-- multiplexer inputs
		in_1 		: in std_logic_vector(3 downto 0);
		switch 	: in std_logic;							-- selector input
		output	: out std_logic_vector(3 downto 0)	-- multiplexer output
);
end component multiplexer_2_to_1;

------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in								: std_logic;
signal mux_temp, current_temp 		: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg			: std_logic_vector(6 downto 0);

-- SW
signal desired_temp 	: std_logic_vector(3 downto 0);
signal vacation_temp : std_logic_vector(3 downto 0);

-- PB
signal vacation_mode : std_logic;
signal MC_test_mode 	: std_logic;
signal window_open 	: std_logic;
signal door_open 		: std_logic;
signal pb_in 			: std_logic_vector(3 downto 0);
signal pb_out 			: std_logic_vector(3 downto 0);

-- HVAC
signal run			: std_logic;
signal increase 	: std_logic;
signal decrease 	: std_logic;

-- COMPx4
signal AGTB : std_logic;
signal AEQB : std_logic;
signal ALTB : std_logic;

------------------------------------------------------------------- 
begin -- Here the circuit begins

-- Hook up hardware inputs
clk_in <= clkin_50;
desired_temp <= sw(3 downto 0);
vacation_temp <= sw(7 downto 4);
pb_in <= pb_n(3 downto 0);

vacation_mode <= pb_out(3);
MC_test_mode <= pb_out(2);
window_open <= pb_out(1);
door_open <= pb_out(0);

-- Connecting all components via signals

inst1: sevensegment port map(mux_temp, hexA_7seg);
inst2: sevensegment port map(current_temp, hexB_7seg);
inst3: segment7_mux port map(clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
inst4: Compx4	port map(mux_temp, current_temp, AGTB, AEQB, ALTB);
inst5: HVAC port map(HVAC_SIM, clk_in, run, increase, decrease, current_temp);
inst6: multiplexer_2_to_1 port map(desired_temp, vacation_temp, vacation_mode, mux_temp);
inst7: PB_Inverters port map(pb_in, pb_out);
inst8: Energy_Monitor port map(AGTB, AEQB, ALTB, vacation_mode, MC_test_mode, window_open, door_open, leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), run, increase, decrease);
inst9: Tester port map(MC_test_mode, AEQB, AGTB, ALTB, desired_temp, current_temp, leds(6));
-- inst10: Bidir_shift_reg port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
-- inst11: U_D_Bin_Counter8Bit port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));

end design;

