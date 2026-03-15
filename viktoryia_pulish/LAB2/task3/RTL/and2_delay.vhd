library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2_delay is
    generic (
        t_delay : time := 1 ns  
    );
    port(
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        y : out STD_LOGIC
    );
end and2_delay;

architecture behavioral of and2_delay is
begin
    y <= a and b after t_delay;
end behavioral;