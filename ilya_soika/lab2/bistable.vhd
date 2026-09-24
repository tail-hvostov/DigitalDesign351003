library ieee;
use ieee.std_logic_1164.all;

entity bistable is
    port (
        Q: out std_logic
        --nQ: out std_logic
    );
end bistable;

architecture Behavioral of bistable is
    signal s0, s1 : std_logic;
    attribute KEEP : string;
    attribute KEEP of s0 : signal is "TRUE";
    attribute KEEP of s1 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of s0 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1 : signal is "TRUE";
begin
    s0 <= not s1;
    s1 <= not s0;
    Q <= s0;
    --nQ <= s1;
end Behavioral;
