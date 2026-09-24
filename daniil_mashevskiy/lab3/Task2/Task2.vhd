library ieee;
use ieee.std_logic_1164.all;

entity Task2 is
    port (
        sw:  in  std_logic_vector(2 downto 0);
        clk: in std_logic;
        led: out std_logic_vector(1 downto 0)
    );
end Task2;

architecture Behavioural of Task2 is
    component Trigger 
        port (
            CLR_N: in std_logic;
            CLK: in std_logic;
            D: in std_logic;
            Q: out std_logic
        );
    end component;
begin
    DFLIPFLOP: Trigger port map (CLR_N => sw(1), CLK => clk, D => sw(0), Q => led(0));
end Behavioural;