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
	-- declare any signals you may need
begin
	assert <condition to check using ro_length>
		report "ro_length must be an odd number"
		severity failure;

	-- TODO: place nand gate
	-- one input is enable, the other one the output of the last inverter
	-- output goes into the first inverter in the chain

	-- TODO: place inverters
	-- for ... generate
	-- end generate

	-- drive osc_out with output of last inverter in the chain
	osc_out <= ...;
end architecture gen;
