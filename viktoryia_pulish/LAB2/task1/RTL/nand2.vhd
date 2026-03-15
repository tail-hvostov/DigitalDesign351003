library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand2 is
    port(
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        y : out STD_LOGIC
    );
end nand2;

architecture behavioral of nand2 is
begin

    y <= not (a and b);

end behavioral;