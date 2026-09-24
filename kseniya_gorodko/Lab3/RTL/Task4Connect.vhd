library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4Connect is
    port(
        clk: in std_logic;
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(0 downto 0)
    );
end Task4Connect;

architecture Structural of Task4Connect is
component Task4 is
    generic(k: natural := 10);
    port(
        clk: in std_logic;  -- rising edge
        rst: in std_logic;  -- sync, active high
        en: in std_logic;   -- enable, active high
        q: out std_logic    -- divided clock
    );
end component Task4;
constant k: natural := 50000000;
begin
    u: Task4 generic map(k => k) port map(clk => clk, rst => sw_i(1), en => sw_i(0), q => led_o(0));
end Structural;
