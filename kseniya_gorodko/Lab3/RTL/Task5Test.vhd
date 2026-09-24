library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5Test is
end Task5Test;

architecture Behavioral of Task5Test is
component Task5 is
    generic(n: natural := 10);
    port(
        clk:    in  std_logic;                          -- system clock, rising edge
        clr:    in  std_logic;                          -- async reset, active high
        en:     in  std_logic;                          -- enable, active high
        mode:   in  std_logic_vector(1 downto 0);       -- mode select
        load:   in  std_logic;                          -- parallel load enable
        din:    in  std_logic_vector(n - 1 downto 0);   -- parallel load data
        dout:   out std_logic_vector(n - 1 downto 0)    -- parallel data read
    );
end component Task5;
signal clk, clr, en, load: std_logic;
signal mode: std_logic_vector(1 downto 0);
constant n: natural := 10;
signal din, dout: std_logic_vector(n - 1 downto 0);
constant t: time := 10ns;
begin
    u: Task5 generic map(n => n)
             port map(clk => clk, clr => clr, en => en, mode => mode, load => load, din => din, dout => dout);
             
    pclk: process
    begin
        clk <= '0'; wait for t / 2;
        clk <= '1'; wait for t / 2;
    end process pclk;
    
    p: process
    begin
        en <= '1'; mode <= "01"; load <= '1'; din <= "1111100000"; wait for t;
        mode <= "00"; wait for t * 5;
        clr <= '1'; wait for t * 2;
        clr <= '0'; mode <= "01"; din <= "1111111111"; wait for t;
        en <= '0'; wait for t * 2;
        en <= '1'; load <= '0'; din <= "1010101010"; wait for t;
        report "End of simulation" severity failure;
    end process p;
end Behavioral;