library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end AND2;

architecture Behavioral of AND2 is
begin
    z <= a and b;
end Behavioral;