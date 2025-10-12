# clock
set_location_assignment PIN_P11 -to clock;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock;

# Button
set_location_assignment PIN_B8 -to reset;
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to reset;

# LED
set_location_assignment PIN_A8 -to done;
set_instance_assignment -name IO_STANDARD "3.3-V-LVTTL" -to done;