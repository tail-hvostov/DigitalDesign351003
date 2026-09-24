library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5Connect is
    port(
        sw_i: in std_logic_vector(15 downto 0);
        led_o: out std_logic_vector(15 downto 0);
        clk: in std_logic
    );
end Task5Connect;

architecture Structural of Task5Connect is
component Task4 is
    generic(k: natural := 10);
    port(
        clk: in std_logic;  -- rising edge
        rst: in std_logic;  -- sync, active high
        en: in std_logic;   -- enable, active high
        q: out std_logic    -- divided clock
    );
end component Task4;
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
constant k: natural := 50000000;
signal clk_div: std_logic;
begin
    u1: Task4 generic map(k => k) port map(clk => clk, rst => '0', en => '1', q => clk_div);
    u2: Task5 port map(clk => clk_div, clr => sw_i(15), en => sw_i(14), mode => sw_i(13 downto 12),
                       load => sw_i(11), din => sw_i(9 downto 0), dout => led_o(9 downto 0));
end Structural;
