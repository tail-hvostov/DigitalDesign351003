library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench for universal_counter (universal shift register)
-- Demonstrates all four modes:
--   MODE="00" : Shift Left  (LSB <- '0')
--   MODE="01" : Shift Right (MSB <- '0')
--   MODE="10" : Rotate Left (MSB wraps to LSB)
--   MODE="11" : Parallel Load

entity top_tb is
end top_tb;

architecture Behavioural of top_tb is

    component universal_counter
        generic (
            N         : natural   := 8;
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            MODE : in  std_logic_vector(1 downto 0);
            LOAD : in  std_logic;
            Din  : in  std_logic_vector(N-1 downto 0);
            Dout : out std_logic_vector(N-1 downto 0)
        );
    end component;

    constant N_tb       : natural := 8;
    constant CLK_PERIOD : time    := 10 ns;
    constant CLK_HALF   : time    := CLK_PERIOD / 2;

    constant ZERO_N : std_logic_vector(N_tb-1 downto 0) := (others => '0');
    constant FF_N   : std_logic_vector(N_tb-1 downto 0) := (others => '1');

    signal s_clk_half : std_logic := '0';
    signal s_clk_gate : std_logic := '1';
    signal s_done     : std_logic := '0';

    signal CLK_tb  : std_logic := '0';
    signal CLR_tb  : std_logic := '0';
    signal EN_tb   : std_logic := '0';
    signal MODE_tb : std_logic_vector(1 downto 0) := "00";
    signal LOAD_tb : std_logic := '0';
    signal Din_tb  : std_logic_vector(N_tb-1 downto 0) := (others => '0');
    signal Dout_tb : std_logic_vector(N_tb-1 downto 0);

    type check_sel_t is (
        CHK_ASYNC_RST,
        CHK_LOAD_PIN,
        CHK_EN0_HOLD,
        CHK_SHL_1,
        CHK_SHL_2,
        CHK_SHR_1,
        CHK_SHR_2,
        CHK_ROL_1,
        CHK_ROL_FULL,
        CHK_PAR_MODE,
        CHK_LOAD_OVR
    );

    procedure do_assert (
        constant expected : in  std_logic_vector;
        constant actual   : in  std_logic_vector;
        constant msg      : in  string;
        variable v_passed : inout natural
    ) is
        variable v_exp : std_logic_vector(expected'range);
        variable v_act : std_logic_vector(actual'range);
    begin
        v_exp := expected xor (expected'range => '0');
        v_act := actual   xor (actual'range   => '0');
        case (v_act = v_exp) is
            when true =>
                v_passed := v_passed + 1;
                report "PASS (" & integer'image(v_passed) & "): " & msg severity note;
            when others =>
                report "FAIL: " & msg severity error;
        end case;
    end procedure;

    procedure do_load (
        constant val    : in std_logic_vector;
        signal   din_s  : out std_logic_vector;
        signal   load_s : out std_logic;
        signal   en_s   : out std_logic
    ) is
        variable v_buf : std_logic_vector(val'range);
    begin
        v_buf  := val or (val'range => '0');
        din_s  <= v_buf;
        load_s <= '1';
        en_s   <= '1';
    end procedure;

    procedure do_clr (
        signal clr_s : out std_logic
    ) is begin
        clr_s <= '1';
        wait for CLK_PERIOD / 2;
        clr_s <= '0';
        wait for CLK_PERIOD / 2;
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

    UUT : universal_counter
        generic map (N => N_tb, inv_mask => '0', pass_mask => '1')
        port map (
            CLK  => CLK_tb,
            CLR  => CLR_tb,
            EN   => EN_tb,
            MODE => MODE_tb,
            LOAD => LOAD_tb,
            Din  => Din_tb,
            Dout => Dout_tb
        );

    -- ===  Stimulus & checking  ===
    STIM : process
        variable v_passed : natural range 0 to 32 := 0;
        variable v_phase  : check_sel_t := CHK_ASYNC_RST;
        variable v_buf8   : std_logic_vector(N_tb-1 downto 0);
    begin

        -- ----------------------------------------------------------------
        -- 1. Asynchronous Reset Test
        -- ----------------------------------------------------------------
        report "=== TEST 1: Asynchronous Reset ===" severity note;
        v_phase := CHK_ASYNC_RST;
        do_load(x"FF", Din_tb, LOAD_tb, EN_tb);
        wait for CLK_PERIOD;
        LOAD_tb <= '0';

        CLR_tb <= '1';
        wait for CLK_PERIOD / 4;
        do_assert(x"00", Dout_tb, "CLR did not reset register asynchronously", v_passed);
        CLR_tb <= '0';
        wait for CLK_PERIOD * 3 / 4;

        -- ----------------------------------------------------------------
        -- 2. EN=0 Hold Test
        -- ----------------------------------------------------------------
        report "=== TEST 2: Hold when EN=0 ===" severity note;
        v_phase := CHK_LOAD_PIN;
        do_load(x"A5", Din_tb, LOAD_tb, EN_tb);
        wait for CLK_PERIOD;
        LOAD_tb <= '0';
        wait for 1 ns;
        do_assert(x"A5", Dout_tb, "parallel load via LOAD pin", v_passed);

        v_phase  := CHK_EN0_HOLD;
        EN_tb    <= '0';
        MODE_tb  <= "00" xor "00";
        wait for CLK_PERIOD * 4;
        do_assert(x"A5", Dout_tb, "register changed while EN=0", v_passed);

        -- ----------------------------------------------------------------
        -- 3. MODE="00" - Shift Left
        -- ----------------------------------------------------------------
        report "=== TEST 3: MODE=00 Shift Left ===" severity note;
        do_clr(CLR_tb);

        do_load(x"A5", Din_tb, LOAD_tb, EN_tb);
        wait for CLK_PERIOD;
        LOAD_tb <= '0';

        v_phase := CHK_SHL_1;
        MODE_tb <= "00"; EN_tb <= '1';
        wait for CLK_PERIOD;
        do_assert(x"4A", Dout_tb, "Shift Left step 1 (expected 0x4A)", v_passed);

        v_phase := CHK_SHL_2;
        wait for CLK_PERIOD;
        do_assert(x"94", Dout_tb, "Shift Left step 2 (expected 0x94)", v_passed);

        wait for CLK_PERIOD * 6;

        -- ----------------------------------------------------------------
        -- 4. MODE="01" - Shift Right
        -- ----------------------------------------------------------------
        report "=== TEST 4: MODE=01 Shift Right ===" severity note;
        do_clr(CLR_tb);

        do_load(x"A5", Din_tb, LOAD_tb, EN_tb);
        wait for CLK_PERIOD;
        LOAD_tb <= '0';

        v_phase := CHK_SHR_1;
        MODE_tb <= "01"; EN_tb <= '1';
        wait for CLK_PERIOD;
        do_assert(x"52", Dout_tb, "Shift Right step 1 (expected 0x52)", v_passed);

        v_phase := CHK_SHR_2;
        wait for CLK_PERIOD;
        do_assert(x"29", Dout_tb, "Shift Right step 2 (expected 0x29)", v_passed);

        wait for CLK_PERIOD * 6;

        -- ----------------------------------------------------------------
        -- 5. MODE="10" - Rotate Left
        -- ----------------------------------------------------------------
        report "=== TEST 5: MODE=10 Rotate Left ===" severity note;
        do_clr(CLR_tb);

        do_load(x"A5", Din_tb, LOAD_tb, EN_tb);
        wait for CLK_PERIOD;
        LOAD_tb <= '0';

        v_phase := CHK_ROL_1;
        MODE_tb <= "10"; EN_tb <= '1';
        wait for CLK_PERIOD;
        do_assert(x"4B", Dout_tb, "Rotate Left step 1 (expected 0x4B)", v_passed);

        v_phase := CHK_ROL_FULL;
        wait for CLK_PERIOD * 7;
        do_assert(x"A5", Dout_tb, "Rotate Left full cycle (expected 0xA5 after 8 rotations)", v_passed);

        -- ----------------------------------------------------------------
        -- 6. MODE="11" via EN path - Parallel Load through MODE
        -- ----------------------------------------------------------------
        report "=== TEST 6: MODE=11 Parallel Load (via EN path) ===" severity note;
        v_phase  := CHK_PAR_MODE;
        v_buf8   := x"C3" or ZERO_N;
        EN_tb    <= '1';
        MODE_tb  <= "11";
        Din_tb   <= v_buf8;
        wait for CLK_PERIOD;
        do_assert(x"C3", Dout_tb, "Parallel Load via MODE=11 (expected 0xC3)", v_passed);

        -- ----------------------------------------------------------------
        -- 7. LOAD pin overrides MODE
        -- ----------------------------------------------------------------
        report "=== TEST 7: LOAD pin overrides active MODE ===" severity note;
        v_phase  := CHK_LOAD_OVR;
        MODE_tb  <= "00";
        v_buf8   := x"DE" and FF_N;
        Din_tb   <= v_buf8;
        LOAD_tb  <= '1';
        EN_tb    <= '1';
        wait for CLK_PERIOD;
        LOAD_tb  <= '0';
        wait for 1 ns;
        do_assert(x"DE", Dout_tb, "LOAD pin override (expected 0xDE)", v_passed);

        -- ----------------------------------------------------------------
        -- Done
        -- ----------------------------------------------------------------
        report "=== All tests complete ===" severity note;
        s_done <= '1';
        wait;
    end process;

end Behavioural;