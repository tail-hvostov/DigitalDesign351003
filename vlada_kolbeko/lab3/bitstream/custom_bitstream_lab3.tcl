set target_dir "D:/Programming/Languages/VHDL/Labs/lab3/bitstream"
if {![file exists $target_dir]} {
    file mkdir $target_dir
}

set bit_files [glob -nocomplain *.bit]

if {[llength $bit_files] > 0} {
    foreach bit_file $bit_files {
        set target_bit [file join $target_dir [file tail $bit_file]]
        if {[catch {file copy -force $bit_file $target_bit} error_msg]} {
            puts "ERROR: \[vlada\] Failed to copy bitstream $bit_file: $error_msg"
        } else {
            puts "INFO: \[vlada\] Bitstream file $bit_file was successfully copied to $target_dir"
        }
    }
} else {
    puts "INFO: \[vlada\] No bitstream files found in [pwd] yet. This is expected during the pre-bitstream step."
}