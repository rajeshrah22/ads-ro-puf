library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
	generic (
		ro_length:	positive := 13;
		ro_count:	positive := 16
	);
	port (
		clock:	in	std_logic;
		reset:	in	std_logic;
		done:	out	std_logic 
	);
end entity toplevel;

architecture top of toplevel is
	constant initial_enable: std_logic := '1';
	signal ctr_to_puf_enable: std_logic;
	signal challenge:	std_logic_vector(2*positive(ceil(log2(real(ro_count / 2)))) - 1 downto 0);
	signal store_respose: std_logic;
	signal puf_reset: std_logic;
	signal response: 
begin

	-- TODO: make instance of ro_puf
	puf: ro_puf
		generic map (
			-- add generic information
			-- should come from toplevel's generic list
			ro_length => ro_length,
			ro_count => ro_count
		)
		port map (
			-- add port information
			-- should use some signals internal to this architecture
			-- should use the `reset' input from toplevel
			reset => reset,
			enable => ctr_to_puf_enable,
			challenge => challenge
			response => response --TODO Make BRAM
		);

	-- TODO: control unit
	-- use control unit entity from blackboard, make entity here
	-- uses the `clock' input and the `reset' input from toplevel
	c_unit: entity.work.control_unit(fsm)
		generic map (
			clock_frequency => 50
		);
		port map (
			enable => initial_enable,
			clock => clock,
			reset => reset,
			counter_enable => ctr_to_puf_enable, -- correct????
			challenge => challenge,
			store_response => store_respose,
			counter_reset => puf_reset,
			done => done
		);

	-- TODO: BRAM
	-- create a BRAM using the IP Catalog, instance it here
	-- make sure you enable the In-System Memory Viewer!
	ram: bram port map (
		address	 => challenge,
		clock	 => clock,
		data	 => response,
		wren	 => store_response,
	);

end architecture top;
