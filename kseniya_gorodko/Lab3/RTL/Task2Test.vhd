library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2Test is
end Task2Test;

architecture Behavioral of Task2Test is
component Task2 is
    port(
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(0 to 0);
        clk: in std_logic
    );
end component Task2;
signal input: std_logic_vector(1 downto 0) := "00";
signal output: std_logic_vector(0 to 0);
signal clk: std_logic := '0';
constant t: time := 100ns;
-- sw_i(1) = d, sw_i(0) = clr_n
begin
    U1: Task2 port map(sw_i => input, led_o => output, clk => clk);
    pclk: process
    begin
        clk <= '0'; wait for t;
        clk <= '1'; wait for t;
    end process pclk;
    p: process
    begin
        input(0) <= '1';
        input(1) <= '0'; wait for t * 2;
        input(1) <= '1'; wait for t * 2;
        input(0) <= '0'; wait for t * 2;
        report "The end of simulation" severity failure;
    end process p;
end Behavioral;
