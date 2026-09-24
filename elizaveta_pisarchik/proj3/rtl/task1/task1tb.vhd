library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1TB is
end Task1TB;

architecture sim of Task1TB is
component RSLatch
    port ( S, R : in std_logic;
           Q, nQ : out std_logic);
end component;
signal S, R : std_logic;
signal Q, nQ : std_logic;
begin
    DUT: RSLatch
        port map (
            S => S,
            R => R,
            Q => Q,
            nQ => nQ
        );
        
    TESTING: process
        variable exp_Q  : std_logic := '0';
        variable exp_nQ : std_logic := '1';
    begin
        -- STORE
        S <= '1'; R <= '1';
        wait for 20 ns;
        assert (Q = exp_Q and nQ = exp_nQ)
            report "STORE FAIL"
            severity error;

        -- SET
        S <= '1'; R <= '0';
        wait for 20 ns;
        exp_Q  := '1';
        exp_nQ := '0';
        assert (Q = exp_Q and nQ = exp_nQ)
            report "SET FAIL"
            severity error;

        -- STORE
        S <= '1'; R <= '1';
        wait for 20 ns;
        assert (Q = exp_Q and nQ = exp_nQ)
            report "STORE AFTER SET FAIL"
            severity error;

        -- RESET
        S <= '0'; R <= '1';
        wait for 20 ns;
        exp_Q  := '0';
        exp_nQ := '1';
        assert (Q = exp_Q and nQ = exp_nQ)
            report "RESET FAIL"
            severity error;

        -- STORE
        S <= '1'; R <= '1';
        wait for 20 ns;
        assert (Q = exp_Q and nQ = exp_nQ)
            report "STORE AFTER RESET FAIL"
            severity error;

        -- FORBIDDEN (0,0)
        S <= '0'; R <= '0';
        wait for 20 ns;
        assert (Q = '1' and nQ = '1')
            report "FORBIDDEN STATE FAIL"
            severity error;

        -- FORBIDDEN ? STORE
        S <= '1'; R <= '1';
        wait for 20 ns;
        report "Exit from forbidden state: Q=" &
               std_logic'image(Q) & " nQ=" & std_logic'image(nQ)
               severity note;

        report "ALL TESTS COMPLETED" severity note;
        wait;
    end process;
end sim;