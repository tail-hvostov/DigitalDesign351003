library ieee;
use ieee.std_logic_1164.all;

entity task5 is
    port (
        led: out std_logic_vector(15 downto 0)
    );
end task5;

architecture Behavioral of task5 is
    component bistable
        port (
            Q: out std_logic
            --nQ: out std_logic
        );
    end component;
begin
    BISTABLE_ELEM: bistable port map (Q => led(0));
    BISTABLE_ELEM2: bistable port map (Q => led(1));
    BISTABLE_ELEM3: bistable port map (Q => led(2));
    BISTABLE_ELEM4: bistable port map (Q => led(3));
    BISTABLE_ELEM5: bistable port map (Q => led(4));
    BISTABLE_ELEM6: bistable port map (Q => led(5));
    BISTABLE_ELEM7: bistable port map (Q => led(6));
    BISTABLE_ELEM8: bistable port map (Q => led(7));
    BISTABLE_ELEM9: bistable port map (Q => led(8));
    BISTABLE_ELEM10: bistable port map (Q => led(9));
    BISTABLE_ELEM11: bistable port map (Q => led(10));
    BISTABLE_ELEM12: bistable port map (Q => led(11));
    BISTABLE_ELEM13: bistable port map (Q => led(12));
    BISTABLE_ELEM14: bistable port map (Q => led(13));
    BISTABLE_ELEM15: bistable port map (Q => led(14));
    BISTABLE_ELEM16: bistable port map (Q => led(15));
end Behavioral;
