library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4 is
    port(
        sw_i: in std_logic_vector(5 downto 0);
        led_o: out std_logic_vector(2 downto 0)
    );
end Task4;

architecture Structural of Task4 is
component COMP1 is
    port(
        x, y, gr_i, eq_i, ls_i: in std_logic;
        gr_o, eq_o, ls_o: out std_logic
    );
end component COMP1;
signal gr2, ls2, eq2, gr1, ls1, eq1: std_logic;
begin
    u1: COMP1 port map(sw_i(5), sw_i(2), '0', '1', '0', gr2, eq2, ls2);
    u2: COMP1 port map(sw_i(4), sw_i(1), gr2, eq2, ls2, gr1, eq1, ls1);
    u3: COMP1 port map(sw_i(3), sw_i(0), gr1, eq1, ls1, led_o(2), led_o(1), led_o(0));
end Structural;