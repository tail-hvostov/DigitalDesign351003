library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task3Test is
end Task3Test;

architecture Behavioral of Task3Test is
component Task3 is
    generic(n: natural := 34);
    port(
        clk, rst, en_clk: in std_logic;
        din: in std_logic_vector(n - 1 downto 0);
        dout: out std_logic_vector(n - 1 downto 0)
    );
end component Task3;
constant n: natural := 4;
constant t: time := 100ns;
signal clk, rst, en: std_logic := '0';
signal input, output: std_logic_vector(n - 1 downto 0);
begin
    u: Task3 generic map(n => n) port map(clk => clk, rst => rst, en_clk => en, din => input, dout => output);
    
    pclk: process
    begin
        clk <= '0'; wait for t;
        clk <= '1'; wait for t;
    end process pclk;
    
    p: process
    begin
        en <= '0'; input <= (others => '1'); wait for t * 2;
        en <= '1'; wait for t * 2;
        en <= '0'; wait for t * 2;
        en <= '1'; rst <= '1'; wait for t * 2;
        report "The end of simulation" severity failure;
    end process p;
end Behavioral;
