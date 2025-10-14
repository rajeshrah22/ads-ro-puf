proc place_inverters {ro_length ro_count} {
	
	set group "a"
	set X 6
	set Y 38
	for {set chain  0} {$chain < [expr $ro_count / 2]} {incr chain} {
		if {$X == 28 || $X == 48 || $X == 68 || $X == 5 || $X == 33 || $X == 53 || $X == 73	} {
			incr X
		}
		set N 0
		for {set inv 0} {$inv < $ro_length} {incr inv} {
			set signal_name "ro_puf:puf|ring_oscillator:\\group_${group}:${chain}:r0|inv_chain\[${inv}\]"
			set_location_assignment LCCOMB_X${X}_Y${Y}_N${N} -to ${signal_name}
			incr N 2
			if {$N > 30} {
				incr Y
				set N 0
			}
		}
		incr X
	}
		
	set group "b"
	for {set chain [expr $ro_count / 2]} {$chain < $ro_count} {incr chain} {
		if {$X == 28 || $X == 48 || $X == 68 || $X == 5 || $X == 33 || $X == 53 || $X == 73	} {
			incr X
		}
		set N 0
		for {set inv 0} {$inv < $ro_length} {incr inv} {
			set signal_name "ro_puf:puf|ring_oscillator:\\group_${group}:${chain}:r0|inv_chain\[${inv}\]"
			set_location_assignment LCCOMB_X${X}_Y${Y}_N${N} -to ${signal_name}
			incr N 2
			if {$N > 30} {
				incr Y
				set N 0
			}
		}
		incr X
	}
	
}