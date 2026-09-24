library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task1Test is
end Task1Test;

architecture Behavioral of Task1Test is
component Task1 is
    port(
    sw_i: in std_logic_vector(1 downto 0);
    led_o: out std_logic_vector(1 downto 0)
);
end component Task1;
signal input, output: std_logic_vector(1 downto 0);
constant t: time := 100ns;
begin
    U1: Task1 port map(sw_i => input, led_o => output);
    p: process
    begin
        wait for t;
        input <= "10"; wait for t;
        input <= "11"; wait for t;
        input <= "01"; wait for t;
        input <= "11"; wait for t;
        input <= "00"; wait for t;
        input <= "11"; wait for t;
        report "The end of simulation" severity failure;
    end process p;
end Behavioral;
