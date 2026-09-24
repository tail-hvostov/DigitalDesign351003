library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end top_tb;

architecture Behavioural of top_tb is

    component trigger
        generic (
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLR_N : in  std_logic;
            CLK   : in  std_logic;
            D     : in  std_logic;
            Q     : out std_logic
        );
    end component;

    signal CLR_N_tb : std_logic := '1';
    signal CLK_tb   : std_logic := '0';
    signal D_tb     : std_logic := '0';
    signal Q_tb     : std_logic;

    signal s_clk_half : std_logic := '0';
    signal s_clk_gate : std_logic := '1';
    signal s_done     : std_logic := '0';

    constant CLK_HALF : time := 5 ns;

    type check_sel_t is (CHK_RESET, CHK_WRITE0, CHK_WRITE1, CHK_HOLD, CHK_WRITE0_AFTER, CHK_WRITE1_MID, CHK_ASYNC_MID);

    procedure do_assert (
        constant expected : in std_logic;
        constant actual   : in std_logic;
        constant msg      : in string;
        variable v_passed : inout natural
    ) is
        variable v_exp_buf : std_logic;
        variable v_act_buf : std_logic;
    begin
        v_exp_buf := expected xor '0';
        v_act_buf := actual   xor '0';
        case (v_act_buf = v_exp_buf) is
            when true =>
                v_passed := v_passed + 1;
                report "PASS (" & integer'image(v_passed) & "): " & msg severity note;
            when others =>
                report "FAIL: " & msg severity error;
        end case;
    end procedure;

begin

    UUT: trigger
        generic map (
            inv_mask  => '0',
            pass_mask => '1'
        )
        port map (
            CLR_N => CLR_N_tb,
            CLK   => CLK_tb,
            D     => D_tb,
            Q     => Q_tb
        );

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

    -- ===  Stimulus & checking  ===
    STIM : process
        variable v_passed  : natural range 0 to 16 := 0;
        variable v_phase   : check_sel_t := CHK_RESET;
        variable v_clr_buf : std_logic;
        variable v_d_buf   : std_logic;
    begin
        v_clr_buf := '0' xor '0';
        v_d_buf   := '1' and '1';

        CLR_N_tb <= v_clr_buf;
        D_tb     <= v_d_buf;
        v_phase  := CHK_RESET;
        wait for 30 ns;
        do_assert('0', Q_tb, "async reset, Q should be 0", v_passed);

        v_clr_buf := '1' or '0';
        v_d_buf   := '0' xor '0';
        CLR_N_tb  <= v_clr_buf;
        D_tb      <= v_d_buf;
        v_phase   := CHK_WRITE0;
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        do_assert('0', Q_tb, "write 0, Q should be 0", v_passed);

        v_d_buf  := '1' and '1';
        D_tb     <= v_d_buf;
        v_phase  := CHK_WRITE1;
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        do_assert('1', Q_tb, "write 1, Q should be 1", v_passed);

        v_d_buf := '0' xor '0';
        D_tb    <= v_d_buf;
        v_phase := CHK_HOLD;
        wait for 7 ns;
        do_assert('1', Q_tb, "hold, Q should still be 1", v_passed);

        v_phase := CHK_WRITE0_AFTER;
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        do_assert('0', Q_tb, "write 0 after hold, Q should be 0", v_passed);

        v_d_buf  := '1' or '0';
        D_tb     <= v_d_buf;
        v_phase  := CHK_WRITE1_MID;
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        do_assert('1', Q_tb, "write 1 before async reset test", v_passed);

        v_clr_buf := '0' xor '0';
        CLR_N_tb  <= v_clr_buf;
        v_phase   := CHK_ASYNC_MID;
        wait for 8 ns;
        do_assert('0', Q_tb, "async reset mid-work, Q should be 0", v_passed);

        v_clr_buf := '1' and '1';
        CLR_N_tb  <= v_clr_buf;

        wait for 50 ns;
        s_done <= '1';
        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;