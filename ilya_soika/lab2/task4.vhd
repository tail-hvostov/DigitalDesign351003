library ieee;
use ieee.std_logic_1164.all;

entity task4 is
    port (
        sw: in std_logic_vector(5 downto 0);
        led: out std_logic_vector(1 downto 0)
    );
end task4;

architecture Behaviour of task4 is
    component comparator is
        generic (
            N: integer := 3
        );
        port (
            A, B: in std_logic_vector(N-1 downto 0);
            result: out std_logic_vector(1 downto 0)
        );
    end component;
    signal A_sig: std_logic_vector(2 downto 0);
    signal B_sig: std_logic_vector(2 downto 0);
begin
    A_sig <= sw(5 downto 3);
    B_sig <= sw(2 downto 0);
    COMPARATOR_A_B: comparator generic map (N => 3) port map (A => A_sig, B => B_sig, result => led);
end Behaviour;