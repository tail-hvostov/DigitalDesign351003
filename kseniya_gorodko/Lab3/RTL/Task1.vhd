library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1 is
    port(
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(1 downto 0)
    );
end Task1;

architecture Structural of Task1 is
component NAND2 is
    port(
        a, b: in std_logic;
        y: out std_logic
    );
end component NAND2;
signal q, nq: std_logic;
attribute DONT_TOUCH: string;
attribute DONT_TOUCH of q: signal is "TRUE";
attribute DONT_TOUCH of nq: signal is "TRUE";
begin
    U1: NAND2 port map(a => sw_i(0), b => q, y => nq);
    U2: NAND2 port map(a => sw_i(1), b => nq, y => q);
    led_o(1) <= q;
    led_o(0) <= nq;
end Structural;
