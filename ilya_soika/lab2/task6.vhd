library ieee;
use ieee.std_logic_1164.all;

entity task6 is
    port (
        sw:  in  std_logic_vector(1 downto 0);
        led: out std_logic_vector(1 downto 0)
    );
end task6;

architecture Behavioral of task6 is
    component rs_trigger
        generic (gate_delay : time);
        port (
            S:  in  std_logic;
            R:  in  std_logic;
            Q:  out std_logic;
            nQ: out std_logic
        );
    end component;
begin
    RS: rs_trigger
        generic map (gate_delay => 5 ns)
        port map (
            S  => sw(1),
            R  => sw(0),
            Q  => led(1),
            nQ => led(0)
        );
end Behavioral;