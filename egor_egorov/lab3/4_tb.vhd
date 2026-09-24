library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture Behavioural of top_tb is

    component freq_div_behav
        generic (
            K         : natural   := 10;
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;
    constant CLK_HALF   : time := CLK_PERIOD / 2;

    signal s_clk_half : std_logic := '0';
    signal s_clk_gate : std_logic := '1';
    signal s_done     : std_logic := '0';

    signal CLK_tb : std_logic := '0';
    signal RST_tb : std_logic := '0';
    signal EN_tb  : std_logic := '0';
    signal Q_K4   : std_logic;
    signal Q_K10  : std_logic;
    signal Q_K100 : std_logic;

    type check_sel_t is (
        CHK_RESET,
        CHK_EN0,
        CHK_K4_HALF,
        CHK_K4_FULL,
        CHK_K10_HALF,
        CHK_K10_FULL,
        CHK_K100_HALF,
        CHK_K100_FULL,
        CHK_MID_RST,
        CHK_RESTART
    );

    procedure do_assert (
        constant expected : in  std_logic;
        constant actual   : in  std_logic;
        constant msg      : in  string;
        variable v_passed : inout natural
    ) is
        variable v_exp : std_logic;
        variable v_act : std_logic;
    begin
        v_exp := expected xor '0';
        v_act := actual   xor '0';
        case (v_act = v_exp) is
            when true =>
                v_passed := v_passed + 1;
                report "PASS (" & integer'image(v_passed) & "): " & msg severity note;
            when others =>
                report "FAIL: " & msg severity error;
        end case;
    end procedure;

    procedure do_rst_en (
        constant rst_val : in std_logic;
        constant en_val  : in std_logic;
        signal   rst_s   : out std_logic;
        signal   en_s    : out std_logic
    ) is
        variable v_rst : std_logic;
        variable v_en  : std_logic;
    begin
        v_rst  := rst_val or  '0';
        v_en   := en_val  and '1';
        rst_s <= v_rst;
        en_s  <= v_en;
    end procedure;

begin

    -- ===  Clock generation  ===
    CLK_PHASE : process
    begin
        loop
            s_clk_half <= '0'; wait for CLK_HALF;
            s_clk_half <= '1'; wait for CLK_HALF;
            exit when s_done = '1';
        end loop;
        wait;
    end process;

    CLK_GEN : process(s_clk_half, s_clk_gate)
    begin
        case s_clk_gate is
            when '1'    => CLK_tb <= s_clk_half;
            when others => CLK_tb <= '0';
        end case;
    end process;

    UUT_K4: freq_div_behav
        generic map (K => 4, inv_mask => '0', pass_mask => '1')
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K4);

    UUT_K10: freq_div_behav
        generic map (K => 10, inv_mask => '0', pass_mask => '1')
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K10);

    UUT_K100: freq_div_behav
        generic map (K => 100, inv_mask => '0', pass_mask => '1')
        port map (CLK => CLK_tb, RST => RST_tb, EN => EN_tb, Q => Q_K100);

    -- ===  Stimulus & checking  ===
    STIM : process
        variable v_passed : natural range 0 to 32 := 0;
        variable v_phase  : check_sel_t := CHK_RESET;
    begin
        do_rst_en('1', '0', RST_tb, EN_tb);
        v_phase := CHK_RESET;
        wait for CLK_PERIOD * 3; wait for 1 ns;
        do_assert('0', Q_K4,   "RESET FAILED: Q_K4 /= 0",   v_passed);
        do_assert('0', Q_K10,  "RESET FAILED: Q_K10 /= 0",  v_passed);
        do_assert('0', Q_K100, "RESET FAILED: Q_K100 /= 0", v_passed);
        do_rst_en('0', '0', RST_tb, EN_tb);

        v_phase := CHK_EN0;
        wait for CLK_PERIOD * 20; wait for 1 ns;
        do_assert('0', Q_K4,  "EN=0 FAILED: Q_K4 changed",  v_passed);
        do_assert('0', Q_K10, "EN=0 FAILED: Q_K10 changed", v_passed);

        wait until rising_edge(CLK_tb);
        do_rst_en('0', '1', RST_tb, EN_tb);

        v_phase := CHK_K4_HALF;
        wait for CLK_PERIOD * 2; wait for 1 ns;
        do_assert('1', Q_K4, "K=4 FAILED: Q not inverted after K/2=2 cycles", v_passed);

        v_phase := CHK_K4_FULL;
        wait for CLK_PERIOD * 2; wait for 1 ns;
        do_assert('0', Q_K4, "K=4 FAILED: Q not inverted after full period K=4", v_passed);

        v_phase := CHK_K10_HALF;
        wait for CLK_PERIOD * 5; wait for 1 ns;
        do_assert('1', Q_K10, "K=10 FAILED: Q not inverted after K/2=5 cycles", v_passed);

        v_phase := CHK_K10_FULL;
        wait for CLK_PERIOD * 5; wait for 1 ns;
        do_assert('0', Q_K10, "K=10 FAILED: Q not inverted after full period K=10", v_passed);

        do_rst_en('0', '0', RST_tb, EN_tb);
        RST_tb <= '1';
        wait for CLK_PERIOD * 2; wait for 1 ns;
        do_rst_en('0', '1', RST_tb, EN_tb);

        v_phase := CHK_K100_HALF;
        wait for CLK_PERIOD * 50; wait for 1 ns;
        do_assert('1', Q_K100, "K=100 FAILED: Q not inverted after K/2=50 cycles", v_passed);

        v_phase := CHK_K100_FULL;
        wait for CLK_PERIOD * 50; wait for 1 ns;
        do_assert('0', Q_K100, "K=100 FAILED: Q not inverted after full period K=100", v_passed);

        do_rst_en('0', '0', RST_tb, EN_tb);
        RST_tb <= '1';
        wait for CLK_PERIOD * 2; wait for 1 ns;
        do_rst_en('0', '1', RST_tb, EN_tb);

        wait for CLK_PERIOD * 3;
        RST_tb <= '1';
        wait for CLK_PERIOD * 1; wait for 1 ns;
        v_phase := CHK_MID_RST;
        do_assert('0', Q_K10, "MID-CYCLE RESET FAILED: Q_K10 /= 0", v_passed);
        RST_tb <= '0';

        do_rst_en('0', '1', RST_tb, EN_tb);
        v_phase := CHK_RESTART;
        wait for CLK_PERIOD * 5; wait for 1 ns;
        do_assert('1', Q_K10, "RESTART FAILED: Q_K10 not inverted after restart", v_passed);

        wait for CLK_PERIOD * 200;
        s_done <= '1';
        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;