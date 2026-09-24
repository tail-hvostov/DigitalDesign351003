## This file is a general .xdc for the Basys3 rev B board
## For reg_file project

## Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

## Reset button (btnC - center button)
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports RST]

## Write Enable (btnU - up button)
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports WE]

## Address Write (sw[1:0] - первые два переключателя)
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {AddrW[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {AddrW[1]}]

## Address Read (sw[3:2] - следующие два переключателя)
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {AddrR[0]}]
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {AddrR[1]}]

## Data Write (sw[15:8] - 8 переключателей для данных)
set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {DataW[0]}]
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {DataW[1]}]
set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {DataW[2]}]
set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {DataW[3]}]
set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {DataW[4]}]
set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {DataW[5]}]
set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {DataW[6]}]
set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {DataW[7]}]

## Data Read (led[7:0] - первые 8 светодиодов)
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {DataR[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {DataR[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {DataR[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {DataR[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {DataR[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {DataR[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {DataR[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {DataR[7]}]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
