----------------------------------------------------------------------------------
-- Testbench for Task1Machine
-- Checks:
--   1) asynchronous reset CLR;
--   2) two full cycles of the ROM at CE = '1';
--   3) counter hold at CE = '0';
--   4) resume at CE = '1'.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1Test is
end Task1Test;

architecture Behavioral of Task1Test is

    constant CLK_PERIOD : time := 10 ns;

    signal CLK : std_logic := '0';
    signal CLR : std_logic := '0';
    signal CE  : std_logic := '0';
    signal DO  : std_logic_vector(3 downto 0);

    component Task1Machine is
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        CE  : in  std_logic;
        DO  : out std_logic_vector(3 downto 0)
    );
    end component;

    type seq_type is array (0 to 15) of std_logic_vector(3 downto 0);
    constant EXPECTED : seq_type := (
        "0000", "0001", "0011", "0010",
        "0110", "0111", "0101", "0100",
        "1100", "1101", "1111", "1110",
        "1010", "1011", "1001", "1000"
    );

    signal held_value : std_logic_vector(3 downto 0);

begin

    DUT : Task1Machine
        port map (CLK => CLK, CLR => CLR, CE => CE, DO => DO);

    CLK <= not CLK after CLK_PERIOD / 2;

    stimulus : process
    begin
        ----------------------------------------------------------------
        -- 1. Asynchronous reset
        ----------------------------------------------------------------
        CLR <= '1';
        CE  <= '0';
        wait for 25 ns;

        assert DO = "0000"
            report "ERROR: reset - DO must be 0000 when CLR=1"
            severity error;

        wait until falling_edge(CLK);
        CLR <= '0';

        ----------------------------------------------------------------
        -- 2. Two full cycles at CE = '1'
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '1';

        -- First full cycle: after each edge the counter is at EXPECTED(i+1)
        for i in 0 to 15 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
            assert DO = EXPECTED((i + 1) mod 16)
                report "ERROR: cycle 1, after edge " & integer'image(i + 1)
                severity error;
        end loop;

        -- Second full cycle: same structure (counter is back at EXPECTED(0))
        for i in 0 to 15 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
            assert DO = EXPECTED((i + 1) mod 16)
                report "ERROR: cycle 2, after edge " & integer'image(i + 1)
                severity error;
        end loop;

        ----------------------------------------------------------------
        -- 3. Hold at CE = '0'
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '0';
        held_value <= DO;

        for k in 1 to 5 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
            assert DO = held_value
                report "ERROR: counter did not hold at CE=0"
                severity error;
        end loop;

        ----------------------------------------------------------------
        -- 4. Resume at CE = '1'
        ----------------------------------------------------------------
        wait until falling_edge(CLK);
        CE <= '1';

        wait until rising_edge(CLK); wait for 1 ns;
        assert DO /= held_value
            report "ERROR: counter did not resume after CE=1"
            severity error;

        ----------------------------------------------------------------
        -- End
        ----------------------------------------------------------------
        report "Simulation finished successfully." severity note;
        wait;
    end process;

end Behavioral;