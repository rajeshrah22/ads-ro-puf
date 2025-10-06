library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;	-- bring in log2()
use ieee.math_real.ceil;	-- bring in ceil()

entity ro_puf is
	generic (
		ro_length:	positive := 13;
		ro_count:	positive := 16
	);
	port (
		reset:	in	std_logic;
		enable:	in	std_logic;
		challenge:	in	std_logic_vector(2*positive(ceil(log2(real(ro_count / 2)))) - 1 downto 0);
		response:	out	std_logic
	);
end entity ro_puf;

architecture puf of ro_puf is
	-- function to determine if a number is a power of 2
	function is_power_two (
			n:	in	positive
		) return boolean
	is
		variable t1: std_logic_vector(31 downto 0);
		variable t2: std_logic_vector(31 downto 0);
		variable t3: std_logic_vector(31 downto 0);
	begin
		-- the trick here is that a power of two when written in binary only
		-- has one bit set and the rest are 0
		t1 := std_logic_vector(to_unsigned(n, 32));
		t2 := std_logic_vector(to_unsigned(n - 1, 32));
		-- we now use a trick to clear the lowest bit that is set by doing
		-- bitwise anding of n and (n - 1)
		t3 := t1 and t2;
		-- if n is a power of 2, then we would clear its only set bit, so t3
		-- should be 0
		return to_integer(unsigned(t3)) = 0;
	end function is_power_two;


	-- the types for the counter
	subtype count_type is natural range 0 to 2**16 - 1;
	type counter_type is array(0 to ro_count - 1) of count_type;

	-- the counters
	signal counter: counter_type;

	-- determine the amount of challenge bits we have
	constant challenge_bits: positive := 2 * positive(ceil(log2(real(ro_count / 2))));

	signal group_a_select_v: std_logic_vector(challenge_bits/2 - 1 downto 0);
	signal group_b_select_v: std_logic_vector(challenge_bits/2 - 1 downto 0);

	signal group_a_select: natural range 0 to 2**(challenge_bits / 2) - 1;
	signal group_b_select: natural range 0 to 2**(challenge_bits / 2) - 1;

	-- oscillator outputs
	signal osc_out: std_logic_vector(ro_count - 1 downto 0);

begin
	-- add assertion here to check if ro_count is a power of 2, feel free to
	-- use the provided function

	-- group selection
	group_a_select_v <=		-- the lower portion goes to group a's selection
		challenge(challenge_bits/2 - 1 downto 0);
	-- make it into a natural number: need to explicitly say this is an
	-- unsigned value we are talking about before converting it!
	group_a_select <= to_integer(unsigned(group_a_select_v));

	group_b_select_v <=		-- the upper portion goes to group b's selection
		challenge(challenge_bits - 1 downto challenge_bits/2);
	-- make it into a natural number: need to explicitly say this is an
	-- unsigned value we are talking about before converting it!
	group_b_select <= to_integer(unsigned(group_b_select_v));

	-- TODO: generate group a
	group_a: for i in 0 to ro_count / 2 - 1 generate
		-- instance of a ring oscillator, the enable input comes from this
		-- entity's port declaration, the output goes into osc_out(i)
		r0:	ring_oscillator
			port map (
				enable => enable,
				osc_out => osc_out(i)
			);
	end generate group_a;

	-- TODO: generate group_b
	group_b: for i in ro_count / 2 to ro_count - 1 generate
		r0:	ring_oscillator
			port map (
				enable => enable,
				osc_out => osc_out(i)
			);
		-- entity's port declaration, the output goes into osc_out(i)
	end generate group_b;

	-- generate counters
	counters: for i in 0 to ro_count - 1 generate
		ctr: process(reset, osc_out(i)) is
		begin
			if reset = '0' then
				counter(i) <= 0;	-- reset counter
			elsif rising_edge(osc_out(i)) then
				if enable = '1' then
				-- TODO: increment counter by 1
					if counter(i) = count_type'range
						counter(i) <= 0
					else
						counter(i) <= counter(i) + 1;
					end if;
				end if;
			end if;
		end process ctr;
	end generate counters;
	
	-- drive response output
	response <= '1'
			when counter(group_a_select) > counter(group_b_select + ro_count / 2)
			else '0';

end architecture puf;
