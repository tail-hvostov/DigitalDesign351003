library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NAND2 is
    port(
        a, b: in std_logic;
        y: out std_logic
    );
end NAND2;

architecture Behavioral of NAND2 is
constant table: std_logic_vector(0 to 3) := "1110";
signal ab: std_logic_vector(0 to 1);
begin
    ab <= a & b;
    y <= table(TO_INTEGER(UNSIGNED(ab)));
end Behavioral;
