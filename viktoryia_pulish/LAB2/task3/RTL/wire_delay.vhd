library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wire_delay is
    generic(
        t_delay : time := 1 ns
    );
    port(
        din  : in  STD_LOGIC;
        dout : out STD_LOGIC
    );
end wire_delay;

architecture behavioral of wire_delay is
begin
    dout <= din after t_delay;
end behavioral;