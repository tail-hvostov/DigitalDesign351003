library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INV is
    port(
        a: in std_logic;
        z: out std_logic
    );
end INV;

architecture Behavioral of INV is
begin
    z <= not a;
end Behavioral;