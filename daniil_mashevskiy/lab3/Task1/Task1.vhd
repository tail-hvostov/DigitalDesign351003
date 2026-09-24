library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity NAND2 is
    port(
        A, B: in std_logic;
        F: out std_logic
    );
end entity;

architecture Behavioral of NAND2 is
 constant GATE_DELAY : time := 5 ns;
begin    
    F <= A nand B after GATE_DELAY;
end Behavioral;