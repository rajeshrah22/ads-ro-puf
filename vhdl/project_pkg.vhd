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


-- component instance
r0: ring_oscillator
	port_map (
		enable => enable,
		osc_out => enable
	);

signal inv_chain: std_logic_vector(0 to ro_length - 1);