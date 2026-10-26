----------------------------------------------------------------------------------
-- Testbench for Task4Machine (vertical + horizontal microprogramming)
-- Expected sequences are derived from the ACTUAL default ROM.
--
-- Default ROM summary (pCE | out | a | b):
--  0: 1|0|F|1   1: 1|0|0|2   2: 1|2|1|3   3: 1|2|2|4
--  4: 1|2|3|5   5: 1|5|4|6   6: 1|5|5|7   7: 1|5|6|8
--  8: 1|5|7|9   9: 1|9|8|A   A: 1|9|9|B   B: 1|9|A|C
--  C: 1|9|B|D   D: 1|9|C|E   E: 1|9|D|F   F: 0|F|E|0
--
-- With X='0' (follow a):  0 -> F -> halt
-- With X='1' (follow b):  0->1->2->...->E->F -> halt
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task4Test is
end Task4Test;

architecture Behavioral of Task4Test is

    constant CLK_PERIOD  : time    := 10 ns;
    constant ADDR_LENGTH : natural := 4;

    -- Main ROM (identical to DUT default)
    constant ROM_MAIN : std_logic_vector :=
        "1" & X"0" & X"F" & X"1" &
        "1" & X"0" & X"0" & X"2" &
        "1" & X"2" & X"1" & X"3" &
        "1" & X"2" & X"2" & X"4" &
        "1" & X"2" & X"3" & X"5" &
        "1" & X"5" & X"4" & X"6" &
        "1" & X"5" & X"5" & X"7" &
        "1" & X"5" & X"6" & X"8" &
        "1" & X"5" & X"7" & X"9" &
        "1" & X"9" & X"8" & X"A" &
        "1" & X"9" & X"9" & X"B" &
        "1" & X"9" & X"A" & X"C" &
        "1" & X"9" & X"B" & X"D" &
        "1" & X"9" & X"C" & X"E" &
        "1" & X"9" & X"D" & X"F" &
        "0" & X"F" & X"E" & X"0";

    -- Halt ROM: quick reach of pCE=0 at addr C
    constant ROM_HALT : std_logic_vector :=
        "1" & X"0" & X"1" & X"1" &   -- 0: pCE=1 out=0 a=1   b=1
        "1" & X"1" & X"C" & X"C" &   -- 1: pCE=1 out=1 a=C   b=C
        "1" & X"0" & X"0" & X"0" &   -- 2
        "1" & X"0" & X"0" & X"0" &   -- 3
        "1" & X"0" & X"0" & X"0" &   -- 4
        "1" & X"0" & X"0" & X"0" &   -- 5
        "1" & X"0" & X"0" & X"0" &   -- 6
        "1" & X"0" & X"0" & X"0" &   -- 7
        "1" & X"0" & X"0" & X"0" &   -- 8
        "1" & X"0" & X"0" & X"0" &   -- 9
        "1" & X"0" & X"0" & X"0" &   -- A
        "1" & X"0" & X"0" & X"0" &   -- B
        "0" & X"9" & X"0" & X"0" &   -- C: pCE=0 out=9 -> HALT
        "1" & X"0" & X"0" & X"0" &   -- D
        "1" & X"0" & X"0" & X"0" &   -- E
        "1" & X"0" & X"0" & X"0";    -- F

    signal CLK   : std_logic := '0';
    signal CLR   : std_logic := '0';
    signal CE    : std_logic := '0';
    signal X     : std_logic := '0';
    signal DO    : std_logic_vector(ADDR_LENGTH - 1 downto 0);

    signal CLK_H : std_logic := '0';
    signal CLR_H : std_logic := '0';
    signal CE_H  : std_logic := '1';
    signal X_H   : std_logic := '0';
    signal DO_H  : std_logic_vector(ADDR_LENGTH - 1 downto 0);

begin

    DUT_MAIN : entity work.Task4Machine
        generic map (ADDR_LENGTH => ADDR_LENGTH, ROM => ROM_MAIN)
        port map (CLK => CLK, CLR => CLR, CE => CE, X => X, DO => DO);

    CLK <= not CLK after CLK_PERIOD / 2;

    DUT_HALT : entity work.Task4Machine
        generic map (ADDR_LENGTH => ADDR_LENGTH, ROM => ROM_HALT)
        port map (CLK => CLK_H, CLR => CLR_H, CE => CE_H, X => X_H, DO => DO_H);

    CLK_H <= not CLK_H after CLK_PERIOD / 2;

    ----------------------------------------------------------------------------
    -- Main DUT stimulus
    ----------------------------------------------------------------------------
    stim_main : process
    begin
        ----------------------------------------------------------------
        -- 1. Reset
        ----------------------------------------------------------------
        CLR <= '1'; CE <= '0'; X <= '0';
        wait for 25 ns;
        assert DO = X"0"
            report "ERROR: reset DO must be 0" severity error;

        wait until falling_edge(CLK);
        CLR <= '0';

        ----------------------------------------------------------------
        -- 2. X='0' path: 0 -> F (halt). Only one step then halt.
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '1'; X <= '0';

        -- Edge 1: 0 -> F, DO = out(F) = F
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"F"
            report "ERROR: X=0 step 1 expected F (a=F)" severity error;

        -- Halt: pCE(F)=0 -> AR frozen
        for k in 1 to 5 loop
            wait until rising_edge(CLK); wait for 1 ns;
            assert DO = X"F"
                report "ERROR: X=0 halt - DO must stay F" severity error;
        end loop;

        ----------------------------------------------------------------
        -- 3. Exit halt via CLR, then X='1' forward path with pauses
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CLR <= '1';
        wait for 2 ns;
        assert DO = X"0"
            report "ERROR: CLR from halt must give 0" severity error;

        wait until falling_edge(CLK);
        CLR <= '0';
        X   <= '1';

        -- Edge 1: 0 -> 1, DO = out(1) = 0  (pause on out=0)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"0"
            report "ERROR: X=1 step 1 expected 0 (pause out=0)" severity error;

        -- Edge 2: 1 -> 2, DO = out(2) = 2
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: X=1 step 2 expected 2" severity error;

        -- Edge 3: 2 -> 3, DO = out(3) = 2 (pause out=2)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: X=1 step 3 expected 2 (pause out=2a)" severity error;

        -- Edge 4: 3 -> 4, DO = out(4) = 2 (pause out=2)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: X=1 step 4 expected 2 (pause out=2b)" severity error;

        -- Edge 5: 4 -> 5, DO = out(5) = 5
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"5"
            report "ERROR: X=1 step 5 expected 5" severity error;

        -- Edge 6: 5 -> 6, DO = out(6) = 5 (pause out=5)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"5"
            report "ERROR: X=1 step 6 expected 5 (pause out=5a)" severity error;

        -- Edge 7: 6 -> 7, DO = out(7) = 5
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"5"
            report "ERROR: X=1 step 7 expected 5 (pause out=5b)" severity error;

        -- Edge 8: 7 -> 8, DO = out(8) = 5
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"5"
            report "ERROR: X=1 step 8 expected 5 (pause out=5c)" severity error;

        -- Edge 9: 8 -> 9, DO = out(9) = 9
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 9 expected 9" severity error;

        -- Edge 10: 9 -> A, DO = out(A) = 9 (pause out=9)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 10 expected 9 (pause out=9a)" severity error;

        -- Edge 11: A -> B, DO = out(B) = 9
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 11 expected 9 (pause out=9b)" severity error;

        -- Edge 12: B -> C, DO = out(C) = 9
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 12 expected 9 (pause out=9c)" severity error;

        -- Edge 13: C -> D, DO = out(D) = 9
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 13 expected 9 (pause out=9d)" severity error;

        -- Edge 14: D -> E, DO = out(E) = 9
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"9"
            report "ERROR: X=1 step 14 expected 9 (pause out=9e)" severity error;

        -- Edge 15: E -> F, DO = out(F) = F
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"F"
            report "ERROR: X=1 step 15 expected F" severity error;

        -- Edge 16: F has pCE=0 -> halt; DO stays F
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"F"
            report "ERROR: X=1 halt at F" severity error;

        for k in 1 to 3 loop
            wait until rising_edge(CLK); wait for 1 ns;
            assert DO = X"F"
                report "ERROR: X=1 halt hold failed" severity error;
        end loop;

        ----------------------------------------------------------------
        -- 4. External CE hold on the forward path
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CLR <= '1';
        wait for 2 ns;
        assert DO = X"0"
            report "ERROR: CLR before CE-hold test must give 0" severity error;

        wait until falling_edge(CLK);
        CLR <= '0';
        X   <= '1';

        -- Two edges: 0 -> 1 -> 2; DO = out(2) = 2
        wait until rising_edge(CLK); wait for 1 ns;
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: pre-hold state expected 2" severity error;

        wait until falling_edge(CLK);
        CE <= '0';

        for k in 1 to 5 loop
            wait until rising_edge(CLK); wait for 1 ns;
            assert DO = X"2"
                report "ERROR: CE=0 hold failed" severity error;
        end loop;

        wait until falling_edge(CLK);
        CE <= '1';

        -- Resume: next edge 2 -> 3, DO = out(3) = 2 (still 2, but AR moved)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: resume expected 2 (at addr 3)" severity error;

        report "Main DUT tests finished successfully." severity note;
        wait;
    end process;

    ----------------------------------------------------------------------------
    -- Halt DUT stimulus (unchanged, was already passing)
    ----------------------------------------------------------------------------
    stim_halt : process
    begin
        CLR_H <= '1'; CE_H <= '1'; X_H <= '0';
        wait for 25 ns;
        assert DO_H = X"0"
            report "ERROR: halt reset expected 0" severity error;

        wait until falling_edge(CLK_H);
        CLR_H <= '0';

        wait until rising_edge(CLK_H); wait for 1 ns;
        assert DO_H = X"1"
            report "ERROR: halt step 1 expected 1" severity error;

        wait until rising_edge(CLK_H); wait for 1 ns;
        assert DO_H = X"9"
            report "ERROR: halt step 2 expected 9 (reached C)" severity error;

        for k in 1 to 5 loop
            wait until rising_edge(CLK_H); wait for 1 ns;
            assert DO_H = X"9"
                report "ERROR: halt state must hold (pCE=0)" severity error;
        end loop;

        wait until falling_edge(CLK_H);
        CLR_H <= '1';
        wait for 2 ns;
        assert DO_H = X"0"
            report "ERROR: CLR must reset from halt" severity error;

        wait until falling_edge(CLK_H);
        CLR_H <= '0';

        wait until rising_edge(CLK_H); wait for 1 ns;
        assert DO_H = X"1"
            report "ERROR: restart after halt reset expected 1" severity error;

        wait until rising_edge(CLK_H); wait for 1 ns;
        assert DO_H = X"9"
            report "ERROR: restart after halt reset expected 9" severity error;

        report "Halt DUT tests finished successfully." severity note;
        wait;
    end process;

end Behavioral;