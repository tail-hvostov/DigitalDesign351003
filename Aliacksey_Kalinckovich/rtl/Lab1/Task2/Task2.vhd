library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sw_led_unit is
    port (
        sw_i : in  std_logic_vector(15 downto 0);  
        led_o: out std_logic_vector(15 downto 0)   
    );
end sw_led_unit;

architecture rtl of sw_led_unit is
begin
    led_o <= sw_i;
end rtl;