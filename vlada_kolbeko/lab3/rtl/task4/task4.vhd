library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task4 is
    generic (
        K   :   natural := 50000000
    );
    port (
        clk     : in    std_logic;
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end task4;

architecture Structural of task4 is
    component freq_div_behav is
        generic (
            K   : natural   := 10
        );
        port (
            CLK : in    std_logic;  -- clk
            RST : in    std_logic;  -- sw_i[0]
            EN  : in    std_logic;  -- sw_i[1]
            Q   : out   std_logic   -- led_o[0]
        );
    end component;
begin
    led_o(15 downto 1) <= (others => '0');
    
    freq_div_behav_0: freq_div_behav
    generic map (
        K => K
    )
    port map (
        CLK => clk,
        RST => sw_i(0),
        EN  => sw_i(1),
        Q   => led_o(0)
    );
end Structural;