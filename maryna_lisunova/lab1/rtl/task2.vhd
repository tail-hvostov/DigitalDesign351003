library ieee;
use ieee.std_logic_1164.all;

entity task2 is
    port (
      led_o: out std_logic_vector(15 downto 0);
      sw_i: in std_logic_vector(15 downto 0)
    );
end task2;

architecture rtl of task2 is
begin
    led_o <= sw_i;
end rtl;

