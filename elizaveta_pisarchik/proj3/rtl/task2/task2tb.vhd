library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2TB is
end Task2TB;

architecture sim of Task2TB is
component DFF
    port (
        D     : in  std_logic;
        CLK   : in  std_logic;
        CLR_N : in  std_logic;
        Q     : out std_logic
    );
end component;
signal D, CLK, CLR_N : std_logic;
signal Q : std_logic;
begin
    DUT: DFF
        port map (
            D     => D,
            CLK   => CLK,
            CLR_N => CLR_N,
            Q     => Q
        );

    CLK_PROCESS: process
    begin
        while true loop
            CLK <= '0'; wait for 5 ns;
            CLK <= '1'; wait for 5 ns;
        end loop;
    end process;

    TESTING: process
        variable exp_Q : std_logic;
    begin
        CLR_N <= '0';
        D <= '0';
        wait for 20 ns;
        exp_Q := '0';
        assert (Q = exp_Q)
            report "RESET FAIL"
            severity error;

        CLR_N <= '1';
        D <= '1';
        wait for 20 ns;
        exp_Q := '1';
        assert (Q = exp_Q)
            report "WRITE 1 FAIL"
            severity error;

    
        D <= '0';
        wait for 20 ns;
        exp_Q := '0';
        assert (Q = exp_Q)
            report "WRITE 0 FAIL"
            severity error;

        D <= '1';
        wait for 3 ns;
        assert (Q = exp_Q)
            report "STORE FAIL"
            severity error;

        wait for 7 ns;
        exp_Q := '1';
        assert (Q = exp_Q)
            report "WRITE AFTER STORE FAIL"
            severity error;

        CLR_N <= '0';
        wait for 10 ns;
        exp_Q := '0';
        assert (Q = exp_Q)
            report "ASYNC RESET FAIL"
            severity error;

        report "ALL TESTS PASSED" severity note;
        wait;
    end process;
end sim;