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
	-- TODO: any signal declarations you may need
begin

	-- TODO: make instance of ro_puf
	puf: ro_puf
		generic map (
			-- add generic information
			-- should come from toplevel's generic list
		)
		port map (
			-- add port information
			-- should use some signals internal to this architecture
			-- should use the `reset' input from toplevel
		);

	-- TODO: control unit
	-- use control unit entity from blackboard, make entity here
	-- uses the `clock' input and the `reset' input from toplevel

	-- TODO: BRAM
	-- create a BRAM using the IP Catalog, instance it here
	-- make sure you enable the In-System Memory Viewer!

end architecture top;
