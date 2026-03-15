library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity code_converter is
    port(
        sw_i  : in  STD_LOGIC_VECTOR(4 downto 0);
        led_o : out STD_LOGIC_VECTOR(4 downto 0)
    );
end code_converter;

architecture structural of code_converter is

    component and2
        port(
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC
        );
    end component;

    component nand2
        port(
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC
        );
    end component;

    signal x, y : STD_LOGIC_VECTOR(4 downto 0);
    signal t1, t2 : STD_LOGIC;

begin

    x <= sw_i;

    g1: and2  port map(x(4), x(3), t1);
    g2: nand2 port map(t1,  x(1), y(0));

    g3: and2  port map(x(4), x(2), t2);
    g4: nand2 port map(t2,  x(0), y(1));

    g5: nand2 port map(x(3), x(2), y(2));
    g6: nand2 port map(x(1), x(0), y(3));

    y(4) <= '0';

    led_o <= y;

end structural;