library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5 is
    port(
        led_o: out std_logic_vector(15 downto 0)
    );
end Task5;
--16 бистабильных элементов вывести одни q
architecture Behavioral of Task5 is
attribute DONT_TOUCH: string;
signal s1, s2: std_logic_vector(15 downto 0);
attribute DONT_TOUCH of s1: signal is "TRUE";
attribute DONT_TOUCH of s2: signal is "TRUE";
begin
    u1: for i in led_o'range generate
        s1(i) <= not s2(i);
        s2(i) <= not s1(i);
        led_o(i) <= s1(i);
    end generate;
end Behavioral;
