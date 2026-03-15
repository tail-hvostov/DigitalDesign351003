
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { Q_out }];  # LED 0
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports { nQ_out }]; # LED 1


set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets s0]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets s1]


set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]


set_property DONT_TOUCH TRUE [get_nets s0]
set_property DONT_TOUCH TRUE [get_nets s1]