# Switches
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {R_in}]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {S_in}]

# LEDs
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {Q_out}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {nQ_out}]

# Разрешаем комбинаторную петлю RS latch
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *s0*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *s1*]

# Понижаем ошибку LUTLP
set_property SEVERITY Warning [get_drc_checks LUTLP-1]