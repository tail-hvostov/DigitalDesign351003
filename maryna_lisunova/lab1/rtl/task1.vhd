library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1 is
  Port ( 
  led_o: out std_logic_vector(15 downto 0);
  sw_i: in std_logic_vector(15 downto 0)
  );
end task1;

architecture rtl of task1 is
begin
    led_o <= "0110100011000011";
end rtl;
