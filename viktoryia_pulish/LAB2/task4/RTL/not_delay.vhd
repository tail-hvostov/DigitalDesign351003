library IEEE;
use ieee.std_logic_1164.all;

entity not_delay is
    generic (DELAY : time := 2 ns);
    port(
        a : in std_logic;
        y : out std_logic
    );
end not_delay;

architecture rtl of not_delay is
begin
    y <= not a after DELAY;
end rtl;