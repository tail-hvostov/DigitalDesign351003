library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DINV is
    generic(d: time := 10ns);
    port(
        a: in std_logic;
        z: out std_logic
    );
end DINV;

architecture Behavioral of DINV is
begin
    z <= not a after d;
end Behavioral;