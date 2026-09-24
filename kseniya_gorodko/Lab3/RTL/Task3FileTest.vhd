library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Task3FileTest is
end Task3FileTest;

architecture Behavioral of Task3FileTest is
component Task3File is
    generic(m, n: natural := 4);
    port(
        clk, en_clk, rst: in std_logic;
        ra, wa: in std_logic_vector(integer(ceil(log2(real(m)))) - 1 downto 0);
        w: in std_logic_vector(n - 1 downto 0);
        r: out std_logic_vector(n - 1 downto 0)
    );
end component Task3File;
constant n: natural := 4;
constant m: natural := 4;
constant t: time := 100ns;
signal clk, rst, en: std_logic := '0';
signal write, read: std_logic_vector(n - 1 downto 0);
signal writeAddr, readAddr: std_logic_vector(integer(ceil(log2(real(m)))) - 1 downto 0);
begin
    u: Task3File generic map(n => n, m => m)
                 port map(clk => clk, rst => rst, en_clk => en, ra => readAddr, wa => writeAddr,
                          w => write, r => read);
    
    pclk: process
    begin
        clk <= '0'; wait for t;
        clk <= '1'; wait for t;
    end process pclk;
    
    p: process
    begin  
        en <= '0'; writeAddr <= "10"; readAddr <= "10"; write <= "1111"; wait for t * 2;
        en <= '1'; wait for t * 2;
        rst <= '1'; wait for t * 2;
        readAddr <= "11"; wait for t * 2;
        report "The end of simulation" severity failure;
    end process p;
end Behavioral;
