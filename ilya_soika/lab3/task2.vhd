library ieee;
use ieee.std_logic_1164.all;

entity task2 is
    port (
        sw:  in  std_logic_vector(2 downto 0);
        clk: in std_logic;
        led: out std_logic_vector(1 downto 0)
    );
end task2;

architecture Behavioural of task2 is
    component FDCE 
        port (
            CLR_N: in std_logic;
            CLK: in std_logic;
            D: in std_logic;
            Q: out std_logic
        );
    end component;
begin
    DFLIPFLOP: FDCE port map (CLR_N => sw(2), CLK => clk, D => sw(1), Q => led(0));
end Behavioural;
