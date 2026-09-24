library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task2 is
    port (
        clk     : in    std_logic;
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end task2;

architecture Structural of task2 is
    component DFF is
        port (
            D       : in    std_logic;  -- sw_i[0]
            CLK     : in    std_logic;  -- clk
            CLR_N   : in    std_logic;  -- sw_i[1]
            Q       : out   std_logic   -- led_[0]
        );
    end component;
begin
    led_o(15 downto 1) <= (others => '0');
    
    DFF_0: DFF port map (
        D => sw_i(0),
        CLK => clk,
        CLR_N => sw_i(1),
        Q => led_o(0)
    );
end Structural;