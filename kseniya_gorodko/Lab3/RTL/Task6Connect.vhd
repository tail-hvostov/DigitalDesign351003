library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task6Connect is
    port(
        sw_i: in std_logic_vector(15 downto 0);
        led_o: out std_logic_vector(15 downto 0);
        clk: in std_logic
    );
end Task6Connect;

architecture Structural of Task6Connect is
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
begin
    u: Task6 generic map(cnt_width => 8)
             port map(clk => clk, clr => sw_i(15), en => sw_i(14), fill => sw_i(7 downto 0), q => led_o(0));
end Structural;