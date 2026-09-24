library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2 is
end Task2;

architecture Behavioral of Task2 is
component Task1 is
    port(
        sw_i: in std_logic_vector(3 downto 0);
        led_o: out std_logic_vector(3 downto 0)
    );
end component Task1;
signal input, output: std_logic_vector(3 downto 0);
constant t: time := 100ns;
begin
    u: Task1 port map(input, output);
    p: process
    begin
        wait for t*10;
        input <= "0000"; wait for t*10;
        input <= "0001"; wait for t*10;
        input <= "0010"; wait for t*10;
        input <= "0011"; wait for t*10;
        input <= "0100"; wait for t*10;
        input <= "1011"; wait for t*10;
        input <= "1100"; wait for t*10;
        input <= "1101"; wait for t*10;
        input <= "1110"; wait for t*10;
        input <= "1111"; wait for t*10;
        report "The end of simulation" severity failure; --выучить severity
    end process p;

end Behavioral;
