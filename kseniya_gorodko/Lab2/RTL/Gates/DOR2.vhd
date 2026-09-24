library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DOR2 is
    generic(d: time := 10ns);
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end DOR2;

architecture Behavioral of DOR2 is
begin
    z <= a or b after d;
end Behavioral;