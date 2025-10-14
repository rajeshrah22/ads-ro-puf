library ieee;
use ieee.std_logic_1164.all;

package project_pkg is
	component ring_oscillator
		generic (
			ro_length: positive := 13
		);
		port (
			enable: in std_logic;
			osc_out: out std_logic
		);
	end component ring_oscillator;
end package project_pkg;