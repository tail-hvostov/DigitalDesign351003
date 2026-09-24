library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NOR2 is
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end NOR2;

architecture Behavioral of NOR2 is
begin
    z <= a nor b;
end Behavioral;