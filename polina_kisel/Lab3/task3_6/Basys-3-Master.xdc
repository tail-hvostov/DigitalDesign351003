## Тактовый сигнал (Clock signal)
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

## Переключатели (Switches) для сигнала FILL [8 бит]
## Мы используем правые 8 переключателей (sw0-sw7)
set_property PACKAGE_PIN V17 [get_ports {FILL[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[0]}]
set_property PACKAGE_PIN V16 [get_ports {FILL[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[1]}]
set_property PACKAGE_PIN W16 [get_ports {FILL[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[2]}]
set_property PACKAGE_PIN W17 [get_ports {FILL[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[3]}]
set_property PACKAGE_PIN W15 [get_ports {FILL[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[4]}]
set_property PACKAGE_PIN V15 [get_ports {FILL[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[5]}]
set_property PACKAGE_PIN W14 [get_ports {FILL[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[6]}]
set_property PACKAGE_PIN W13 [get_ports {FILL[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FILL[7]}]

## Переключатель для EN (используем sw15 - крайний левый)
## Это устраняет конфликт с FILL[0] на пине V17
set_property PACKAGE_PIN R2 [get_ports EN]						
	set_property IOSTANDARD LVCMOS33 [get_ports EN]

## Кнопка для CLR (центральная кнопка btnC)
set_property PACKAGE_PIN T1 [get_ports CLR]						
	set_property IOSTANDARD LVCMOS33 [get_ports CLR]

## Выход ШИМ на светодиод (LD0)
set_property PACKAGE_PIN U16 [get_ports Q]							
	set_property IOSTANDARD LVCMOS33 [get_ports Q]

## Настройки конфигурации для Bitstream (устраняют ошибки Voltage)
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]