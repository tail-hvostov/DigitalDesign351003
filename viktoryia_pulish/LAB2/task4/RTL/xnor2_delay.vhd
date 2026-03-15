library IEEE;
use ieee.std_logic_1164.all;

entity xnor2_delay is
    generic (DELAY : time := 2 ns);
    port(
        a, b : in std_logic;
        y    : out std_logic
    );
end xnor2_delay;

architecture rtl of xnor2_delay is
begin
    y <= a xnor b after DELAY;
end rtl;