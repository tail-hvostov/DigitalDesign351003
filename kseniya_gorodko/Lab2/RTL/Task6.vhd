library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task6 is
    port(
        led_o: out std_logic_vector(15 downto 0);
        sw_i: in std_logic_vector(15 downto 0)
    );
end Task6;
--sw_i(1) - r, sw_i(0) - s
architecture Behavioral of Task6 is
signal q, nq, s1, s2: std_logic;
attribute DONT_TOUCH: string;
attribute DONT_TOUCH of s1: signal is "TRUE";
attribute DONT_TOUCH of s2: signal is "TRUE";
begin
    s1 <= (s2 nor sw_i(1));
    s2 <= (s1 nor sw_i(0));
    q <= s1;
    nq <= s2;
    led_o(0) <= q;
    led_o(1) <= nq;
end Behavioral;
