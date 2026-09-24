library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_div_behav_tb is
end freq_div_behav_tb;

architecture Behavioural of freq_div_behav_tb is
    component freq_div_behav
        generic (K : natural := 10);
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    constant CLK_PERIOD : time := 10 ns;
    signal CLK_tb : std_logic := '0';
    signal RST_tb : std_logic := '0';
    signal EN_tb  : std_logic := '0';
    signal Q_K4   : std_logic;
    signal Q_K10  : std_logic;
    signal Q_K100 : std_logic;

begin
    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;

    UUT_K4: freq_div_behav
        generic map (K => 4)
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K4);

    UUT_K10: freq_div_behav
        generic map (K => 10)
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K10);

    UUT_K100: freq_div_behav
        generic map (K => 100)
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K100);

    process
    begin
        RST_tb <= '1'; EN_tb <= '0';
        wait for CLK_PERIOD*3; wait for 1 ns;
        assert Q_K4 = '0' report "RESET FAILED: Q_K4 /= 0"   severity error;
        assert Q_K10 = '0' report "RESET FAILED: Q_K10 /= 0"  severity error;
        assert Q_K100 = '0' report "RESET FAILED: Q_K100 /= 0" severity error;
        RST_tb <= '0';

        EN_tb <= '0';
        wait for CLK_PERIOD * 20; wait for 1 ns;
        assert Q_K4  = '0' report "EN=0 FAILED: Q_K4 changed"  severity error;
        assert Q_K10 = '0' report "EN=0 FAILED: Q_K10 changed" severity error;

        wait until rising_edge(CLK_tb);
        EN_tb <= '1';
        wait for CLK_PERIOD * 2; wait for 1 ns;
        assert Q_K4 = '1'
            report "K=4 FAILED: Q not inverted after K/2=2 cycles" severity error;

        wait for CLK_PERIOD * 2; wait for 1 ns;
        assert Q_K4 = '0'
            report "K=4 FAILED: Q not inverted after full period K=4" severity error;

        wait for CLK_PERIOD * 5; wait for 1 ns;
        assert Q_K10 = '1'
            report "K=10 FAILED: Q not inverted after K/2=5 cycles" severity error;

        wait for CLK_PERIOD * 5; wait for 1 ns;
        assert Q_K10 = '0'
            report "K=10 FAILED: Q not inverted after full period K=10" severity error;

        EN_tb <= '0'; RST_tb <= '1';
        wait for CLK_PERIOD * 2; wait for 1 ns;
        RST_tb <= '0'; EN_tb <= '1';

        wait for CLK_PERIOD * 50; wait for 1 ns;
        assert Q_K100 = '1'
            report "K=100 FAILED: Q not inverted after K/2=50 cycles" severity error;

        wait for CLK_PERIOD * 50; wait for 1 ns;
        assert Q_K100 = '0'
            report "K=100 FAILED: Q not inverted after full period K=100" severity error;

        EN_tb <= '0'; RST_tb <= '1';
        wait for CLK_PERIOD * 2; wait for 1 ns;
        RST_tb <= '0'; EN_tb <= '1';

        wait for CLK_PERIOD * 3;
        RST_tb <= '1';
        wait for CLK_PERIOD * 1; wait for 1 ns;
        assert Q_K10 = '0'
            report "MID-CYCLE RESET FAILED: Q_K10 /= 0" severity error;
        RST_tb <= '0';

        EN_tb <= '1';
        wait for CLK_PERIOD * 5; wait for 1 ns;
        assert Q_K10 = '1'
            report "RESTART FAILED: Q_K10 not inverted after restart" severity error;

        wait for CLK_PERIOD * 200;
        report "Testbench complete" severity note;
        wait;
    end process;
end Behavioural;