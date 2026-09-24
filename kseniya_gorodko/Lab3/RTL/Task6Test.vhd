library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Task6Test is
end Task6Test;

architecture Behavioral of Task6Test is
component Task6 is
    generic(cnt_width: natural := 8);
    port(
        clk:    in  std_logic;
        clr:    in  std_logic;
        en:     in  std_logic;
        fill:   in  std_logic_vector(cnt_width - 1 downto 0);
        q:      out std_logic
    );
end component Task6;
constant cnt_width: natural := 2;
signal clk, clr, en, q: std_logic;
signal fill: std_logic_vector(cnt_width - 1 downto 0);
constant t: time := 10ns;
begin
    u: Task6 generic map(cnt_width => cnt_width)
             port map(clk => clk, clr => clr, en => en, q => q, fill => fill);
    
    clkp: process
    begin
        clk <= '0'; wait for t;
        clk <= '1'; wait for t;
    end process clkp;
    p: process
    begin
        en <= '1';
        fill <= (others => '0'); wait for t * 16;
        clr <= '1'; wait for t * 2;
        clr <= '0'; fill <= "01"; wait for t * 16;
        clr <= '1'; wait for t * 2;
        clr <= '0'; fill <= "10"; wait for t * 16;
        clr <= '1'; wait for t * 2;
        clr <= '0'; fill <= (others => '1'); wait for t * 16;
        
        en <= '0'; wait for t * 2;
        en <= '1'; wait for t * 2;
        fill <= "01"; wait for t * 16;
        report "End of simulation" severity failure;
    end process p;
end Behavioral;
