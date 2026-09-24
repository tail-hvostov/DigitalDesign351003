library ieee;
use ieee.std_logic_1164.all;

entity or2 is
    Generic (T: time := 5 ns);
    Port ( i0 : in STD_LOGIC; i1 : in STD_LOGIC; o : out STD_LOGIC);
end or2;

architecture behave of or2 is
begin
    o <= i1 or i0 after T;
end behave;