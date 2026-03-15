library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand2_delay is
    generic (
        t_delay : time := 1 ns
    );
    port(
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        y : out STD_LOGIC
    );
end nand2_delay;

architecture behavioral of nand2_delay is
begin
    y <= not (a and b) after t_delay;
end behavioral;