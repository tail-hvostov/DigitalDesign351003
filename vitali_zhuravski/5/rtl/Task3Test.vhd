----------------------------------------------------------------------------------
-- Testbench for Task3Machine (vertical microprogrammed automaton)
-- Checks:
--   1) sequential execution with constant X;
--   2) branching at X = '1' and X = '0';
--   3) program looping (unconditional jump back to start);
--   4) reset to initial address;
--   5) hold at CE = '0'.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3Test is
end Task3Test;

architecture Behavioral of Task3Test is

    constant CLK_PERIOD : time := 10 ns;
    constant ADDR_LENGTH : natural := 4;

    -- Default microcode from the variant (same as DUT default)
    constant ROM_DEFAULT : std_logic_vector :=
        X"0" & X"F" & X"1" &
        X"1" & X"0" & X"2" &
        X"2" & X"1" & X"3" &
        X"3" & X"2" & X"4" &
        X"4" & X"3" & X"5" &
        X"5" & X"4" & X"6" &
        X"6" & X"5" & X"7" &
        X"7" & X"6" & X"8" &
        X"8" & X"7" & X"9" &
        X"9" & X"8" & X"A" &
        X"A" & X"9" & X"B" &
        X"B" & X"A" & X"C" &
        X"C" & X"B" & X"D" &
        X"D" & X"C" & X"E" &
        X"E" & X"D" & X"F" &
        X"F" & X"E" & X"0";

    signal CLK : std_logic := '0';
    signal CLR : std_logic := '0';
    signal CE  : std_logic := '0';
    signal X   : std_logic := '1';
    signal DO  : std_logic_vector(ADDR_LENGTH - 1 downto 0);

begin

    DUT : entity work.Task3Machine
        generic map (
            ADDR_LENGTH => ADDR_LENGTH,
            ROM         => ROM_DEFAULT
        )
        port map (
            CLK => CLK,
            CLR => CLR,
            CE  => CE,
            X   => X,
            DO  => DO
        );

    CLK <= not CLK after CLK_PERIOD / 2;

    stimulus : process
    begin
        ----------------------------------------------------------------
        -- 1. Reset to initial address
        ----------------------------------------------------------------
        CLR <= '1';
        CE  <= '0';
        X   <= '0';
        wait for 25 ns;

        assert DO = "0000"
            report "ERROR: reset - DO must be 0000 when CLR=1"
            severity error;

        wait until falling_edge(CLK);
        CLR <= '0';

        ----------------------------------------------------------------
        -- 2. Sequential execution with X = '1' (follows bbb field)
        --    Microcode: at addr N, out=N, a=N-1, b=N+1 (mod 16)
        --    With X=1, each step goes to addr+1, so DO increments:
        --    0 -> 1 -> 2 -> 3 -> 4 -> ...
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        X  <= '1';
        CE <= '1';

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"1"
            report "ERROR: X=1, step 1 expected 1"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: X=1, step 2 expected 2"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"3"
            report "ERROR: X=1, step 3 expected 3"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"4"
            report "ERROR: X=1, step 4 expected 4"
            severity error;

        ----------------------------------------------------------------
        -- 3. Branching: switch X to '0' mid-sequence (follows aaa field)
        --    At addr 4, a=3, b=5. With X=0 -> go to 3, so DO=3
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        X <= '0';

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"3"
            report "ERROR: X=0 branch, expected 3"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"2"
            report "ERROR: X=0 step 2 expected 2"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"1"
            report "ERROR: X=0 step 3 expected 1"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"0"
            report "ERROR: X=0 step 4 expected 0"
            severity error;

        ----------------------------------------------------------------
        -- 4. Looping: at addr 0, a=F(15), b=1.
        --    With X=0 -> go to F (wrap-around bottom of program).
        --    Continue with X=0: F->E->D->...->0 -> F -> ... infinite loop.
        --    Verify wrap from 0 to F.
        ----------------------------------------------------------------
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"F"
            report "ERROR: X=0 wrap 0->F expected F"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"E"
            report "ERROR: X=0 step expected E"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"D"
            report "ERROR: X=0 step expected D"
            severity error;

        ----------------------------------------------------------------
        -- 5. Switch direction again: from D (X=0 gave D), go back to F
        --    with X=1 (a=C, b=E at addr D... wait: at D, a=C, b=E)
        --    At addr D (13): a=12(C), b=14(E). X=1 -> E
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        X <= '1';

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"E"
            report "ERROR: X=1 at D expected E"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"F"
            report "ERROR: X=1 at E expected F"
            severity error;

        -- At F (15): a=E, b=0. X=1 -> 0 (wrap to start)
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"0"
            report "ERROR: X=1 at F expected 0 (loop)"
            severity error;

        ----------------------------------------------------------------
        -- 6. Hold at CE = '0'
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '0';
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"0"
            report "ERROR: hold at CE=0"
            severity error;

        wait until rising_edge(CLK); wait for 1 ns;
        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"0"
            report "ERROR: hold at CE=0 (still 0)"
            severity error;

        ----------------------------------------------------------------
        -- 7. Resume and verify continued counting
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '1';

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO = X"1"
            report "ERROR: resume expected 1"
            severity error;

        ----------------------------------------------------------------
        -- 8. Async reset again, from a non-zero state
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CLR <= '1';
        wait for 2 ns;
        assert DO = X"0"
            report "ERROR: async reset from non-zero state"
            severity error;

        wait until falling_edge(CLK);
        CLR <= '0';

        ----------------------------------------------------------------
        -- End
        ----------------------------------------------------------------
        report "Simulation finished successfully." severity note;
        wait;
    end process;

end Behavioral;