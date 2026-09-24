library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity freq_div_behav_tb is
end freq_div_behav_tb;

architecture rtl of freq_div_behav_tb is
    component freq_div_behav is
        Generic (K : positive := 10);
        Port (
            CLK : in std_logic;
            RST : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal EN  : std_logic := '0';

    signal Q4   : std_logic;
    signal Q10  : std_logic;
    signal Q100 : std_logic;

begin
    UUT4: freq_div_behav
        generic map ( K => 4 )
        port map ( CLK => CLK, RST => RST, EN => EN, Q => Q4 );

    UUT10: freq_div_behav
        generic map ( K => 10 )
        port map ( CLK => CLK, RST => RST, EN => EN, Q => Q10 );

    UUT100: freq_div_behav
        generic map ( K => 100 )
        port map ( CLK => CLK, RST => RST, EN => EN, Q => Q100 );

    CLK_proc: process
    begin
        while now < 10000 ns loop
            CLK <= '1';
            wait for CLK_PERIOD / 2;
            CLK <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIM: process
        variable t_rise   : time;
        variable t_period : time;
    begin
        RST <= '0'; EN <= '1';

        wait until Q4 = '1';
        t_rise := now;
        wait until Q4 = '0';
        wait until Q4 = '1';
        t_period := now - t_rise;
        assert (t_period = 4 * CLK_PERIOD)
            report "FAIL: K=4 wrong period"
            severity error;

        wait until Q10 = '1';
        t_rise := now;
        wait until Q10 = '0';
        wait until Q10 = '1';
        t_period := now - t_rise;
        assert (t_period = 10 * CLK_PERIOD)
            report "FAIL: K=10 wrong period"
            severity error;

        wait until Q100 = '1';
        t_rise := now;
        wait until Q100 = '0';
        wait until Q100 = '1';
        t_period := now - t_rise;
        assert (t_period = 100 * CLK_PERIOD)
            report "FAIL: K=100 wrong period"
            severity error;

        RST <= '1';
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        assert (Q10 = '0')
            report "FAIL: reset failed"
            severity error;
        RST <= '0';

        EN <= '0';
        wait for CLK_PERIOD * 12;
        assert (Q10 = '0')
            report "FAIL: Q10 changed while EN=0"
            severity error;

        EN <= '1';
        wait until Q10 = '1';
        assert (Q10 = '1')
            report "FAIL: Q10 did not resume after EN=1"
            severity error;

        report "testbench finished";
        wait;
    end process;
end rtl;