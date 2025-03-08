# Assign I/O Standards (Updated)
set_property IOSTANDARD LVCMOS18 [get_ports {F_in[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {idct_out[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports done]
set_property IOSTANDARD LVCMOS18 [get_ports rst]
set_property IOSTANDARD LVCMOS18 [get_ports start]

# Move F_in[2] to a different bank (Bank 33)
set_property PACKAGE_PIN Y17 [get_ports F_in[2]]  ;# New location in Bank 33

# Assign Pin Locations (No changes except F_in[2])
set_property PACKAGE_PIN V17 [get_ports F_in[0]]
set_property PACKAGE_PIN W17 [get_ports F_in[1]]
set_property PACKAGE_PIN V16 [get_ports F_in[3]]
set_property PACKAGE_PIN W16 [get_ports F_in[4]]
set_property PACKAGE_PIN U15 [get_ports F_in[5]]
set_property PACKAGE_PIN V15 [get_ports F_in[6]]
set_property PACKAGE_PIN W15 [get_ports F_in[7]]
set_property PACKAGE_PIN U14 [get_ports F_in[8]]
set_property PACKAGE_PIN V14 [get_ports F_in[9]]
set_property PACKAGE_PIN W14 [get_ports F_in[10]]
set_property PACKAGE_PIN U13 [get_ports F_in[11]]
set_property PACKAGE_PIN V13 [get_ports F_in[12]]
set_property PACKAGE_PIN W13 [get_ports F_in[13]]
set_property PACKAGE_PIN U12 [get_ports F_in[14]]
set_property PACKAGE_PIN V12 [get_ports F_in[15]]

set_property PACKAGE_PIN P16 [get_ports idct_out[0]]
set_property PACKAGE_PIN R16 [get_ports idct_out[1]]
set_property PACKAGE_PIN P15 [get_ports idct_out[2]]
set_property PACKAGE_PIN R15 [get_ports idct_out[3]]
set_property PACKAGE_PIN P14 [get_ports idct_out[4]]
set_property PACKAGE_PIN R14 [get_ports idct_out[5]]
set_property PACKAGE_PIN P13 [get_ports idct_out[6]]
set_property PACKAGE_PIN R13 [get_ports idct_out[7]]

set_property PACKAGE_PIN U10 [get_ports rst]
set_property PACKAGE_PIN V10 [get_ports start]
set_property PACKAGE_PIN W9  [get_ports done]

# Clock Pin (No changes)
set_property PACKAGE_PIN <valid_CC_pin> [get_ports clk]

# Set Clock Constraints
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]
