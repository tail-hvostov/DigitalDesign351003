library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2Top is
    port (
        clk   : in std_logic;
        sw_i  : in  std_logic_vector(15 downto 0);
        led_o : out std_logic_vector(15 downto 0)
    );
end Task2Top;

architecture rtl of Task2Top is
    component DFF
        port (
            D     : in  std_logic;
            CLK   : in  std_logic;
            CLR_N : in  std_logic;
            Q     : out std_logic
        );
    end component;
    signal Q_sig : std_logic;
begin
    U0: DFF
        port map (
            D     => sw_i(0),
            CLK   => clk,
            CLR_N => sw_i(1),
            Q     => Q_sig
        );

    led_o(0) <= Q_sig;
end rtl;