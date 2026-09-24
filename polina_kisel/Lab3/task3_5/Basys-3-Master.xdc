
# Clock
set_property PACKAGE_PIN W5 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 10.000 -name clk [get_ports CLK]

## Кнопка сброса (Центральная)
set_property -dict { PACKAGE_PIN T1  IOSTANDARD LVCMOS33 } [get_ports CLR]

## Переключатели (SW0 - данные, SW14 - EN)
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {DIN[0]}]
set_property -dict { PACKAGE_PIN R2   IOSTANDARD LVCMOS33 } [get_ports EN]

## MODE (SW1, SW2, SW3)
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {MODE[0]}]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports {MODE[1]}]


## Светодиоды (LD0-LD7) - твоя сигнатура
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {DOUT[0]}]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33 } [get_ports {DOUT[1]}]
set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports {DOUT[2]}]
set_property -dict { PACKAGE_PIN V19  IOSTANDARD LVCMOS33 } [get_ports {DOUT[3]}]
set_property -dict { PACKAGE_PIN W18  IOSTANDARD LVCMOS33 } [get_ports {DOUT[4]}]
set_property -dict { PACKAGE_PIN U15  IOSTANDARD LVCMOS33 } [get_ports {DOUT[5]}]
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports {DOUT[6]}]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports {DOUT[7]}]