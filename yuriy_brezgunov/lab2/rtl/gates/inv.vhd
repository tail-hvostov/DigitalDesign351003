library ieee;
use ieee.std_logic_1164.all;

entity inv is
    Generic (T: time := 2 ns);
    Port ( i : in STD_LOGIC; o : out STD_LOGIC);
end inv;

architecture behave of inv is
begin
    o <= not i after T;
end behave;