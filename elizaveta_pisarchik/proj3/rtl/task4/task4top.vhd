library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4Top is
    Port (
        clk : in  STD_LOGIC;
        sw_i  : in  STD_LOGIC_VECTOR(1 downto 0);
        led_o : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Task4Top;

architecture rtl of Task4Top is
    component freq_div_behav
        generic (K : natural);
        port(
            CLK : in std_logic;
            RST : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;
    signal Q_sig : std_logic;
begin
    U0: freq_div_behav
        generic map (K => 50000000)
        port map (
            CLK => clk,
            RST => sw_i(0),
            EN  => sw_i(1),
            Q   => Q_sig
        );

    led_o(0) <= Q_sig;
end rtl;