library ieee;
use ieee.std_logic_1164.all;

entity rs_trigger is
    generic (
        gate_delay : time := 5 ns
    );
    port (
        S:  in  std_logic;
        R:  in  std_logic;
        Q:  out std_logic;
        nQ: out std_logic
    );
end rs_trigger;

architecture Behavioral of rs_trigger is
    signal s0, s1 : std_logic;
    attribute KEEP : string;
    attribute KEEP of s0 : signal is "TRUE";
    attribute KEEP of s1 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of s0 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1 : signal is "TRUE";
begin
    s0 <= (R nor s1) after gate_delay;
    s1 <= (S nor s0) after gate_delay;
    Q  <= s0;
    nQ <= s1;
end Behavioral;