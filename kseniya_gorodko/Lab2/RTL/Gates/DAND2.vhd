library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DAND2 is
    generic(d: time := 10ns);
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end DAND2;

architecture Behavioral of DAND2 is
begin
    z <= a and b after d;
end Behavioral;