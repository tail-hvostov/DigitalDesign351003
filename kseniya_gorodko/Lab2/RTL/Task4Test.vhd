library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task4Test is
end Task4Test;

architecture Behavioral of Task4Test is
component Task4 is
    port(
        sw_i: in std_logic_vector(5 downto 0);
        led_o: out std_logic_vector(2 downto 0)
    );
end component Task4;
signal input: std_logic_vector(5 downto 0);
signal output: std_logic_vector(2 downto 0);
constant t: time := 100ns;
begin
    u: Task4 port map(input, output);
    p: process
    variable a, b: unsigned(2 downto 0);
    begin
        wait for t*10;
        for i in 0 to (2 ** a'length) - 1 loop
            a := to_unsigned(i, a'length);
            for j in 0 to (2 ** b'length) - 1 loop
                b := to_unsigned(j, b'length);
                input <= std_logic_vector(a & b); wait for t*10;
            end loop;
        end loop;
        report "The end of simulation" severity failure;
    end process p;

end Behavioral;