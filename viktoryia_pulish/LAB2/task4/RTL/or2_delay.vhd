library IEEE;
use ieee.std_logic_1164.all;

entity or2_delay is
    generic (DELAY : time := 2 ns);
    port(
        a, b : in std_logic;
        y    : out std_logic
    );
end or2_delay;

architecture rtl of or2_delay is
begin
    y <= a or b after DELAY;
end rtl;