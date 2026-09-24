## Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

## Switches & Buttons
# Переключатель V17 для EN (Enable)
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports EN]
# Кнопка U18 для RST (Reset)
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports RST]

## LEDs
# Светодиод U16 для выхода Q
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports Q]

## Configuration Voltage (Стандартные настройки для Basys 3)
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]