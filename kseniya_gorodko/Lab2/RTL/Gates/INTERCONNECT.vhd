library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INTERCONNECT is
    generic(
        delay: time := 5ns
    );
    port(
        x: in std_logic;
        z: out std_logic
    );
end INTERCONNECT;

architecture Behavioral of INTERCONNECT is
begin
    z <= transport x after delay;
end Behavioral;
