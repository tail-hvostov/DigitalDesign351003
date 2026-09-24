library ieee;
use ieee.std_logic_1164.all;

entity task1 is
    port (
        sw:  in  std_logic_vector(1 downto 0);
        led: out std_logic_vector(1 downto 0)
    );
end task1;

architecture Behavioral of task1 is
    component RSlatch
        generic (gate_delay : time);
        port (
            S:  in  std_logic;
            R:  in  std_logic;
            Q:  out std_logic;
            nQ: out std_logic
        );
    end component;
begin
    RS: RSlatch
        generic map (gate_delay => 5 ns)
        port map (
            S  => sw(1),
            R  => sw(0),
            Q  => led(1),
            nQ => led(0)
        );
end Behavioral;