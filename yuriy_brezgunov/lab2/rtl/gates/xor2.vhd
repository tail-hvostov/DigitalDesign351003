library ieee;
use ieee.std_logic_1164.all;

entity xor2 is
    Generic (T: time := 5 ns);
    Port ( i0 : in STD_LOGIC; i1 : in STD_LOGIC; o : out STD_LOGIC);
end xor2;

architecture behave of xor2 is
begin
    o <= i1 xor i0 after T;
end behave;