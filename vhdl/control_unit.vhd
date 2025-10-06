library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	generic (
		challenge_bits:		positive := 4;
		clock_frequency:	positive := 200;	-- in MHz
		delay_us:			positive := 10		-- in microseconds
	);
	port (
		clock:	in	std_logic;
		reset:	in	std_logic;
		enable:	in	std_logic;
		
		counter_enable:	out	std_logic;
		counter_reset:	out	std_logic;
		challenge:		out	std_logic_vector(challenge_bits - 1 downto 0);
		store_response:	out	std_logic;
		done:	out	std_logic
	);
end entity control_unit;

architecture fsm of control_unit is
	constant counter_delay_max: positive := clock_frequency * delay_us - 1;
	constant max_challenges: positive := (2 ** challenge_bits) - 1;

	type state_type is
		( reset_state, enable_state, wait_time, disable, next_challenge, store, all_done);

	signal state, next_state: state_type := reset_state;
	signal wait_counter: natural range 0 to counter_delay_max := 0;
	signal challenge_counter: natural range 0 to max_challenges := 0;
	
	signal last_challenge: boolean := false;
begin

	-- assign outputs
	challenge <= std_logic_vector(to_unsigned(challenge_counter, challenge'length));
	store_response <= '1' when state = store else '0';
	done <= '1' when state = all_done else '0';
	counter_enable <= '1' when (state =  enable_state or state = wait_time) else '0';
	counter_reset <= '0' when state = reset_state else '1';

	-- last challenge logic
	last_challenge <= challenge_counter = max_challenges;


	-- save the next state
	save_state: process(clock, reset) is
	begin
		if reset = '0' then
			state <= reset_state;
		elsif rising_edge(clock) then
			if enable = '1' then
				state <= next_state;
			end if;
		end if;
	end process save_state;
	
	-- increment the wait counter
	counter_process: process(clock, reset) is
	begin
		if reset = '0' then
			wait_counter <= 0;
		elsif rising_edge(clock) then
			if enable = '1' and state = wait_time and wait_counter < counter_delay_max then
				wait_counter <= wait_counter + 1;
			end if;
		end if;
	end process counter_process;

	-- increment challenge counter
	challenge_process: process(clock, reset) is
	begin
		if reset = '0' then
			challenge_counter <= 0;
		elsif rising_edge(clock) then
			if enable = '1' and state = next_challenge and challenge_counter < max_challenges then
				challenge_counter <= challenge_counter + 1;
			end if;
		end if;
	end process challenge_process;
	
	transition_function: process(state, wait_counter, last_challenge) is
	begin
		case state is
			when reset_state => next_state <= enable_state;
			when enable_state => next_state <= wait_time;
			when wait_time =>
				if wait_counter = counter_delay_max then
					next_state <= disable;
				else
					next_state <= wait_time;
				end if;
			when disable => next_state <= store;
			when store =>
				if challenge_counter = max_challenges then
					next_state <= all_done;
				else
					next_state <= next_challenge;
				end if;
			when next_challenge =>
				next_state <= store;
			when all_done => next_state <= all_done;
			when others => next_state <= reset_state;
		end case;
	end process transition_function;
	
end architecture fsm;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture microcode of control_unit is
	type uinsn_type is
	record
		counter_enable:	std_logic;
		counter_reset:	std_logic;
		store_response:	std_logic;
		increment_challenge:	boolean;
		perform_delay:	boolean;
		done:	std_logic;
	end record uinsn_type;
	type uinsn_rom_type is array(natural range<>) of uinsn_type;

	-- horizontal microcode implementation
	constant uinsn_rom: uinsn_rom_type := (
		0 => (		-- counter reset
			counter_enable => '0',
			counter_reset => '0',
			store_response => '0',
			increment_challenge => false,
			perform_delay => false,
			done => '0'
		),
		1 => (		-- counter enable and wait
			counter_enable => '1',
			counter_reset => '1',
			store_response => '0',
			increment_challenge => false,
			perform_delay => true,
			done => '0'
		),
		2 => (		-- store response
			counter_enable => '0',
			counter_reset => '1',
			store_response => '1',
			increment_challenge => false,
			perform_delay => false,
			done => '0'
		),
		3 => (		-- increment challenge
			counter_enable => '0',
			counter_reset => '1',
			store_response => '0',
			increment_challenge => true,
			perform_delay => false,
			done => '0'
		),
		4 => (		-- done
			counter_enable => '0',
			counter_reset => '1',
			store_response => '0',
			increment_challenge => false,
			perform_delay => false,
			done => '1'
		)
	);
			
	constant max_challenges: positive := 2 ** challenge_bits - 1;
	constant counter_delay_max: positive := clock_frequency * delay_us - 1;

	signal challenge_counter: natural range 0 to max_challenges;
	signal wait_counter: natural range 0 to counter_delay_max := 0;

	signal uinsn: uinsn_type;
	signal upc: natural range uinsn_rom'range;

begin

	-- current microinstruction
	uinsn <= uinsn_rom(upc);

	counter_enable <= uinsn.counter_enable;
	counter_reset <= uinsn.counter_reset;

	-- sequencer
	upc_sequencer: process(clock, reset) is
	begin
		if reset = '0' then
			upc <= uinsn_rom'low;
		elsif rising_edge(clock) then
		end if;
	end process upc_sequencer;

end architecture microcode;
