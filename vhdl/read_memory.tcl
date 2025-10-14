#load_package external_memif_toolkit
#load_package ::quartus::jtag
load_package ::quartus::insystem_memory_edit

proc wait_for_return {} {
	gets stdin
}

# autodetect USB Blaster 
global usbblaster

foreach hardware_name [get_hardware_names] {
	if { [string match "USB-Blaster*" $hardware_name] } {
		set usbblaster $hardware_name
	}
}

puts "Using probe ${usbblaster}"

# FPGA should be in position 1 of the JTAG chain
global device
foreach device_name [get_device_names -hardware_name ${usbblaster}] {
	if { [string match "@1*" $device_name] } {
		set device $device_name
	}
}
#set device "@1: 10M50SA(.|ES)/10M50SC (0x031850DD)"
puts "Using device ${device}"

# there should be only one 
set instance_index 0

begin_memory_edit -hardware_name ${usbblaster} -device_name ${device}

puts "ensure faults are disabled and press RETURN"
wait_for_return

#save_content_from_memory_to_file -instance_index ${instance_index} \
#	-mem_file_path "capture/glitch_none.mif" -mem_file_type mif \
#	-timeout 40

## hack: the probe crashes every once in a while set last attempt number here
set start_value 0

for {set i ${start_value}} {$i < 50} {incr i} {
	puts "reset board and wait for done, then hit RETURN"
	wait_for_return
	save_content_from_memory_to_file -instance_index ${instance_index} \
		-mem_file_path "memdump/memory_contents_${i}.mif" -mem_file_type mif \
		-timeout 40
}

end_memory_edit
