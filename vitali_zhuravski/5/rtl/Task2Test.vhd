----------------------------------------------------------------------------------
-- Testbench for Task2Machine (reversible microcommand automaton)
-- Checks:
--   1) asynchronous reset CLR;
--   2) count up (DIR = '1');
--   3) count down (DIR = '0');
--   4) direction switching in the middle of the cycle.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2Test is
end Task2Test;

architecture Behavioral of Task2Test is

    constant CLK_PERIOD : time := 10 ns;

    signal CLK : std_logic := '0';
    signal CLR : std_logic := '0';
    signal CE  : std_logic := '0';
    signal DIR : std_logic := '1';
    signal DO  : std_logic_vector(3 downto 0);
    
    component Task2Machine is
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        CE  : in  std_logic;
        DIR : in  std_logic;
        DO  : out std_logic_vector(3 downto 0)
    );
    end component;

begin

    -- Device under test
    DUT : Task2Machine
        port map (
            CLK => CLK,
            CLR => CLR,
            CE  => CE,
            DIR => DIR,
            DO  => DO
        );

    -- Clock generator
    CLK <= not CLK after CLK_PERIOD / 2;

    -- Stimulus process
    stimulus : process
    begin
        ----------------------------------------------------------------
        -- 1. Asynchronous reset
        ----------------------------------------------------------------
        CLR <= '1';
        CE  <= '0';
        DIR <= '1';
        wait until falling_edge(CLK);

        assert DO = "0000"
            report "ERROR: after CLR output must be 0000"
            severity error;

        wait until falling_edge(CLK);
        CLR <= '0';
        wait until falling_edge(CLK);

        ----------------------------------------------------------------
        -- 2. Count up (DIR = '1')
        ----------------------------------------------------------------
        CE  <= '1';
        DIR <= '1';

        -- Expect Gray code sequence: 0000 -> 0001 -> 0011 -> 0010 -> ...
        wait until falling_edge(CLK);
        assert DO = "0001"
            report "ERROR: count up step 1 expected 0001"
            severity error;

        wait until falling_edge(CLK);
        assert DO = "0011"
            report "ERROR: count up step 2 expected 0011"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "0010"
            report "ERROR: count up step 3 expected 0010"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "0110"
            report "ERROR: count up step 4 expected 0110"
            severity error;

        ----------------------------------------------------------------
        -- 3. Direction switch in the middle of the cycle
        ----------------------------------------------------------------
        DIR <= '0';

        -- Now count down: 0110 -> 0010 -> 0011 -> 0001 -> 0000 -> 1000 ...
        wait for CLK_PERIOD;
        assert DO = "0010"
            report "ERROR: after DIR=0 step 1 expected 0010"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "0011"
            report "ERROR: after DIR=0 step 2 expected 0011"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "0001"
            report "ERROR: after DIR=0 step 3 expected 0001"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "0000"
            report "ERROR: after DIR=0 step 4 expected 0000"
            severity error;

        ----------------------------------------------------------------
        -- 4. Continue counting down (wrap-around)
        ----------------------------------------------------------------
        wait for CLK_PERIOD;
        assert DO = "1000"
            report "ERROR: count down wrap expected 1000"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "1001"
            report "ERROR: count down expected 1001"
            severity error;

        wait for CLK_PERIOD;
        assert DO = "1011"
            report "ERROR: count down expected 1011"
            severity error;

        ----------------------------------------------------------------
        -- 5. Stop counting (CE = '0')
        ----------------------------------------------------------------
        CE <= '0';
        wait for 5 * CLK_PERIOD;

        assert DO = "1011"
            report "ERROR: with CE=0 counter must hold its value"
            severity error;

        ----------------------------------------------------------------
        -- 6. Resume counting down to observe full reverse cycle
        ----------------------------------------------------------------
        CE <= '1';
        wait for CLK_PERIOD;
        assert DO = "1010"
            report "ERROR: resume count down expected 1010"
            severity error;

        wait for 20 * CLK_PERIOD;

        ----------------------------------------------------------------
        -- End of simulation
        ----------------------------------------------------------------
        report "Simulation finished successfully." severity note;
        wait;
    end process;

end Behavioral;