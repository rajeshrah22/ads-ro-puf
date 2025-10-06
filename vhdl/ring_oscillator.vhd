library ieee;
use ieee.std_logic_1164.all;

entity ring_oscillator is
	generic (
		ro_length:	positive	:= 13
	);
	port (
		enable:		in	std_logic;
		osc_out:	out	std_logic
	);
end entity ring_oscillator;

architecture gen of ring_oscillator is
	inv_chain: std_logic_vector(0 to ro_length - 1);
begin
	assert ro_length % 2 == 0
		report "ro_length must be an odd number"
		severity failure;

	-- TODO: place nand gate
	-- one input is enable, the other one the output of the last inverter
	-- output goes into the first inverter in the chain
	
	inv_chain(0) <= enable nand inv_chain(ro_length – 1);

   some_chain: for idx in 1 to ro_length - 1 generate
		inv_chain(idx) <= not inv_chain(idx – 1);
   end generate some_chain;

	-- drive osc_out with output of last inverter in the chain
	osc_out <= inv_chain(ro_length -1);
end architecture gen;
