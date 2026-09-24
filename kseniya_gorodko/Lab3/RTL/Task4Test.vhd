library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4Test is
end Task4Test;

architecture Behavioral of Task4Test is
component Task4 is
    generic(k: natural := 10);
    port(
        clk: in std_logic;  -- rising edge
        rst: in std_logic;  -- sync, active high
        en: in std_logic;   -- enable, active high
        q: out std_logic    -- divided clock
    );
end component Task4;
signal clk, rst, en, q: std_logic;
constant k: natural := 2;
constant t: time := 10ns;
begin
    u: Task4 generic map(k => k) port map(clk => clk, rst => rst, en => en, q => q);

    pclk: process
    begin
        clk <= '0'; wait for t;
        clk <= '1'; wait for t;
    end process pclk;
    
    process
    begin
        en <= '1'; wait for t * 10;
        en <= '0'; wait for t * 2;
        en <= '1'; wait for t * 2;
        rst <= '1'; wait for t * 2;
        report "End of simulation" severity failure;
    end process;
end Behavioral;
