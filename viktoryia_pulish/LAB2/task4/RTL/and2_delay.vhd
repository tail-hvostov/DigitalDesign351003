library IEEE;
use ieee.std_logic_1164.all;

entity and2_delay is
    generic (DELAY : time := 2 ns);
    port(
        a, b : in std_logic;
        y    : out std_logic
    );
end and2_delay;

architecture rtl of and2_delay is
begin
    y <= a and b after DELAY;
end rtl;