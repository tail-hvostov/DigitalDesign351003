library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1test is
--  Port ( );
end task1test;

architecture Behavioural of task1test is

    component RSlatch
        generic (gate_delay : time);
        port (
            S:  in  std_logic;
            R:  in  std_logic;
            Q:  out std_logic;
            nQ: out std_logic
        );
    end component;

    signal S_tb  : std_logic := '0';
    signal R_tb  : std_logic := '0';
    signal Q_tb  : std_logic;
    signal nQ_tb : std_logic;

begin

    UUT: RSlatch
        generic map (gate_delay => 5 ns)
        port map (
            S  => S_tb,
            R  => R_tb,
            Q  => Q_tb,
            nQ => nQ_tb
        );

    process
    begin
        S_tb <= '1'; R_tb <= '1';
        wait for 50 ns;

        S_tb <= '0'; R_tb <= '1';
        wait for 50 ns;
        assert Q_tb = '1' and nQ_tb = '0'
            report "failed" severity error;

        S_tb <= '1'; R_tb <= '1';
        wait for 50 ns;

        S_tb <= '1'; R_tb <= '0';
        wait for 50 ns;
        assert Q_tb = '0' and nQ_tb = '1'
            report "failed" severity error;

        S_tb <= '1'; R_tb <= '1';
        wait for 50 ns;

        S_tb <= '0'; R_tb <= '0';
        wait for 50 ns;
        assert Q_tb = '0' and nQ_tb = '0'
            report "Forbidden state outputs not both 1" severity warning;
        report "Releasing forbidden state -> oscillation expected" severity note;
        S_tb <= '1'; R_tb <= '1';
        wait for 200 ns;
        assert (Q_tb = '0' and nQ_tb = '1') or (Q_tb = '1' and nQ_tb = '0')
            report "After oscillation: metastable or still oscillating!" severity warning;

        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;
