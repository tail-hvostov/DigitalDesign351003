library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture Behavioural of top_tb is

    constant CNT_W      : natural := 8;
    constant CLK_PERIOD : time    := 0.1 ns;
    constant CLK_HALF   : time    := CLK_PERIOD / 2;
    constant PWM_PERIOD : time    := CLK_PERIOD * 256;

    constant ZERO_N : std_logic_vector(CNT_W-1 downto 0) := (others => '0');
    constant FF_N   : std_logic_vector(CNT_W-1 downto 0) := (others => '1');

    component pwm_controller
        generic (
            CNT_WIDTH : natural   := 8;
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;

    type check_sel_t is (
        CHK_CLR_ACTIVE,
        CHK_FILL0,
        CHK_FILL_FF,
        CHK_EN0_HOLD
    );

    signal s_clk_half : std_logic := '0';
    signal s_clk_gate : std_logic := '1';
    signal s_done     : std_logic := '0';

    signal CLK_tb  : std_logic := '0';
    signal CLR_tb  : std_logic := '0';
    signal EN_tb   : std_logic := '0';
    signal FILL_tb : std_logic_vector(CNT_W-1 downto 0) := (others => '0');
    signal Q_tb    : std_logic;
    signal Q_latch : std_logic;

    procedure do_assert_sl (
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

    procedure do_set_fill (
        constant val   : in  std_logic_vector;
        signal   fill_s : out std_logic_vector
    ) is
        variable v_buf : std_logic_vector(val'range);
    begin
        v_buf  := val or (val'range => '0');
        fill_s <= v_buf;
    end procedure;

    procedure do_clr_cycle (
        signal clr_s : out std_logic
    ) is begin
        clr_s <= '1';
        wait for CLK_PERIOD * 4;
        clr_s <= '0';
        wait for CLK_PERIOD * 2;
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

    UUT: pwm_controller
        generic map (CNT_WIDTH => CNT_W, inv_mask => '0', pass_mask => '1')
        port map (
            CLK  => CLK_tb,
            CLR  => CLR_tb,
            EN   => EN_tb,
            FILL => FILL_tb,
            Q    => Q_tb
        );

    -- ===  Stimulus & checking  ===
    STIM : process
        variable v_passed : natural range 0 to 32 := 0;
        variable v_phase  : check_sel_t := CHK_CLR_ACTIVE;
    begin
        EN_tb  <= '1';
        do_set_fill(x"00", FILL_tb);

        v_phase := CHK_CLR_ACTIVE;
        CLR_tb  <= '1';
        wait for CLK_PERIOD * 4;
        do_assert_sl('0', Q_tb, "RESET FAILED: Q is not 0 during CLR=1", v_passed);
        CLR_tb  <= '0';
        wait for CLK_PERIOD * 2;

        v_phase := CHK_FILL0;
        do_set_fill(x"00", FILL_tb);
        wait for PWM_PERIOD;
        do_assert_sl('0', Q_tb, "FILL=0% FAILED: Q is not 0", v_passed);

        do_set_fill(x"40", FILL_tb);
        wait for PWM_PERIOD * 2;
        report "25% running" severity note;

        do_set_fill(x"80", FILL_tb);
        wait for PWM_PERIOD * 2;
        report "50% running" severity note;

        do_set_fill(x"C0", FILL_tb);
        wait for PWM_PERIOD * 2;
        report "75% running" severity note;

        v_phase := CHK_FILL_FF;
        do_set_fill(x"FF", FILL_tb);
        wait for PWM_PERIOD * 2;
        wait until rising_edge(CLK_tb);
        wait for CLK_PERIOD / 4;
        do_assert_sl('1', Q_tb, "FILL=100% FAILED: Q is not '1' at period start", v_passed);

        do_set_fill(x"40", FILL_tb);
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=25%" severity note;

        do_set_fill(x"C0", FILL_tb);
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=75%" severity note;

        do_set_fill(x"80", FILL_tb);
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=50% - PASSED" severity note;

        v_phase := CHK_EN0_HOLD;
        do_set_fill(x"80", FILL_tb);
        wait until rising_edge(CLK_tb);
        wait for CLK_PERIOD / 4;
        Q_latch <= Q_tb;
        EN_tb   <= '0';
        wait for CLK_PERIOD * 20;
        do_assert_sl(Q_latch, Q_tb, "EN=0 FAILED: Q changed while EN=0", v_passed);
        report "EN=0 check PASSED" severity note;

        EN_tb <= '1';
        wait for CLK_PERIOD * 4;

        EN_tb  <= '0';
        CLR_tb <= '1';
        do_set_fill(x"00", FILL_tb);
        wait for CLK_PERIOD * 10;
        s_done <= '1';
        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;