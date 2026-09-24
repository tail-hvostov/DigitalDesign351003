library ieee;
use ieee.std_logic_1164.all;

entity wire is
    Generic (T: time := 1 ns);
    Port ( i : in STD_LOGIC; o : out STD_LOGIC);
end wire;

architecture behave of wire is
begin
    o <= i after T;
end behave;