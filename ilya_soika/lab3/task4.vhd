library ieee;
use ieee.std_logic_1164.all;

entity task4 is
    port (
        sw:  in  std_logic_vector(2 downto 0);
        clk: in std_logic;
        led: out std_logic_vector(1 downto 0)
    );
end task4;

architecture Behavioural of task4 is
    component freq_div_behav
        generic (K : natural := 10);
        port (
            CLK: in  std_logic;
            RST: in  std_logic;
            EN: in  std_logic;
            Q: out std_logic
        );
    end component;
begin
    led(1) <= clk;
    UUT: freq_div_behav
        generic map (K => 50_000_000)
        port map (
            CLK => clk,
            RST => sw(0),
            EN => sw(1),
            Q => led(0)   
        );
end Behavioural;
