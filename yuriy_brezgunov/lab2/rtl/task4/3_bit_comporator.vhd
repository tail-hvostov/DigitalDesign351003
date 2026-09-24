library ieee;
use ieee.std_logic_1164.all;

entity three_bit_comporator is
    port (
        led : out std_logic_vector(15 downto 13); -- gt, eq, lt
        sw: in std_logic_vector(15 downto 10) -- a, b
    );
end three_bit_comporator;

architecture rtl of three_bit_comporator is
    component n_bit_comporator
        generic (N : integer := 3);
        port (
            a  : in  std_logic_vector(N-1 downto 0);
            b  : in  std_logic_vector(N-1 downto 0);
            lt : out std_logic;
            eq : out std_logic;
            gt : out std_logic
        );
    end component;
begin
    COMP: n_bit_comporator
        generic map (
            N => 3
        )
        port map (
            a => sw(15 downto 13),
            b => sw(12 downto 10),
            gt => led(15),
            eq => led(14),
            lt => led(13)
        );
end;