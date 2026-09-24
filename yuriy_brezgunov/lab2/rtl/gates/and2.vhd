library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    Generic (T: time := 5 ns);
    Port ( i0 : in STD_LOGIC; i1 : in STD_LOGIC; o : out STD_LOGIC);
end and2;

architecture behave of and2 is
begin
    o <= i1 and i0 after T;
end behave;