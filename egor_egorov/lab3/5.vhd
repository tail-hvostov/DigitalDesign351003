library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_div_behav is
    generic (
        K         : natural   := 10;
        inv_mask  : std_logic := '0';
        pass_mask : std_logic := '1'
    );
    port (
        CLK: in std_logic;
        RST: in std_logic;
        EN:  in std_logic;
        Q:   out std_logic
    );
end freq_div_behav;

architecture behavioural of freq_div_behav is

    constant HALF_K    : natural := K / 2;
    constant HALF_K_M1 : natural := K / 2 - 1;

    type cnt_lut_t is array (0 to 1) of natural;
    constant CNT_BOUNDS : cnt_lut_t := (0, HALF_K_M1);

    signal clk_s0   : std_logic := '0';
    signal clk_s1   : std_logic := '0';
    signal clk_m    : std_logic := '0';
    signal rst_s0   : std_logic := '0';
    signal rst_s1   : std_logic := '0';
    signal rst_m    : std_logic := '0';
    signal en_s0    : std_logic := '0';
    signal en_s1    : std_logic := '0';
    signal en_m     : std_logic := '0';

    signal cnt_raw  : natural range 0 to (K/2 - 1) := 0;
    signal cnt_next : natural range 0 to (K/2 - 1) := 0;
    signal q_raw    : std_logic := '0';
    signal q_next   : std_logic := '0';
    signal q_gated  : std_logic := '0';
    signal q_stage0 : std_logic := '0';
    signal q_stage1 : std_logic := '0';

begin

    STAGE_INPUT_CLK : process(CLK)
    begin
        clk_s0 <= CLK    xor inv_mask;
        clk_s1 <= clk_s0 or  inv_mask;
        clk_m  <= clk_s1 and pass_mask;
    end process;

    STAGE_INPUT_RST : process(RST)
    begin
        rst_s0 <= RST    xor inv_mask;
        rst_s1 <= rst_s0 or  inv_mask;
        rst_m  <= rst_s1 and pass_mask;
    end process;

    STAGE_INPUT_EN : process(EN)
    begin
        en_s0 <= EN     xor inv_mask;
        en_s1 <= en_s0  or  inv_mask;
        en_m  <= en_s1  and pass_mask;
    end process;

    STAGE_NEXT : process(cnt_raw, q_raw, rst_m, en_m)
    begin
        case rst_m is
            when '1' =>
                cnt_next <= CNT_BOUNDS(0);
                q_next   <= '0';
            when others =>
                case en_m is
                    when '1' =>
                        case (cnt_raw = HALF_K_M1) is
                            when true =>
                                cnt_next <= CNT_BOUNDS(0);
                                q_next   <= not q_raw;
                            when others =>
                                cnt_next <= cnt_raw + 1;
                                q_next   <= q_raw;
                        end case;
                    when others =>
                        cnt_next <= cnt_raw;
                        q_next   <= q_raw;
                end case;
        end case;
    end process;

    STAGE_REG : process(clk_m)
    begin
        case clk_m is
            when '1' =>
                if clk_m'event then
                    cnt_raw <= cnt_next;
                    q_raw   <= q_next;
                end if;
            when others =>
                null;
        end case;
    end process;

    STAGE_OUTPUT : process(q_raw)
    begin
        q_gated  <= q_raw    or  inv_mask;
        q_stage0 <= q_gated  and pass_mask;
        q_stage1 <= q_stage0 xor inv_mask;
    end process;

    Q <= q_stage1;

end behavioural;

------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity universal_counter is
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
end universal_counter;

architecture Behavioural of universal_counter is

    type mode_sel_t is (SEL_SHL, SEL_SHR, SEL_ROL, SEL_PAR, SEL_LOAD, SEL_HOLD);

    constant ZERO_VEC : std_logic_vector(N-1 downto 0) := (others => '0');
    constant FF_VEC   : std_logic_vector(N-1 downto 0) := (others => '1');

    signal clk_s0  : std_logic := '0';
    signal clk_s1  : std_logic := '0';
    signal clk_m   : std_logic := '0';
    signal clr_s0  : std_logic := '0';
    signal clr_s1  : std_logic := '0';
    signal clr_m   : std_logic := '0';
    signal en_s0   : std_logic := '0';
    signal en_s1   : std_logic := '0';
    signal en_m    : std_logic := '0';
    signal load_s0 : std_logic := '0';
    signal load_s1 : std_logic := '0';
    signal load_m  : std_logic := '0';

    signal mode_s0 : std_logic_vector(1 downto 0) := (others => '0');
    signal mode_s1 : std_logic_vector(1 downto 0) := (others => '0');
    signal mode_m  : std_logic_vector(1 downto 0) := (others => '0');

    signal din_s0  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal din_s1  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal din_m   : std_logic_vector(N-1 downto 0) := (others => '0');

    signal cur      : std_logic_vector(N-1 downto 0) := (others => '0');
    signal nxt      : std_logic_vector(N-1 downto 0) := (others => '0');
    signal en_prev  : std_logic := '0';
    signal en_pulse : std_logic := '0';
    signal op_sel   : mode_sel_t := SEL_HOLD;

    signal cur_s0   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal cur_s1   : std_logic_vector(N-1 downto 0) := (others => '0');

begin

    STAGE_INPUT_CLK : process(CLK)
    begin
        clk_s0 <= CLK    xor inv_mask;
        clk_s1 <= clk_s0 or  inv_mask;
        clk_m  <= clk_s1 and pass_mask;
    end process;

    STAGE_INPUT_CLR : process(CLR)
    begin
        clr_s0 <= CLR    xor inv_mask;
        clr_s1 <= clr_s0 or  inv_mask;
        clr_m  <= clr_s1 and pass_mask;
    end process;

    STAGE_INPUT_EN : process(EN)
    begin
        en_s0 <= EN     xor inv_mask;
        en_s1 <= en_s0  or  inv_mask;
        en_m  <= en_s1  and pass_mask;
    end process;

    STAGE_INPUT_LOAD : process(LOAD)
    begin
        load_s0 <= LOAD    xor inv_mask;
        load_s1 <= load_s0 or  inv_mask;
        load_m  <= load_s1 and pass_mask;
    end process;

    STAGE_INPUT_MODE : process(MODE)
    begin
        mode_s0 <= MODE    xor (inv_mask & inv_mask);
        mode_s1 <= mode_s0 or  (inv_mask & inv_mask);
        mode_m  <= mode_s1 and (pass_mask & pass_mask);
    end process;

    STAGE_INPUT_DIN : process(Din)
    begin
        din_s0 <= Din    xor ZERO_VEC;
        din_s1 <= din_s0 or  ZERO_VEC;
        din_m  <= din_s1 and FF_VEC;
    end process;

    STAGE_PULSE : process(en_m, en_prev)
    begin
        case en_m is
            when '1' =>
                case en_prev is
                    when '0'    => en_pulse <= pass_mask;
                    when others => en_pulse <= inv_mask;
                end case;
            when others =>
                en_pulse <= inv_mask;
        end case;
    end process;

    STAGE_SEL : process(load_m, en_pulse, mode_m)
    begin
        case load_m is
            when '1' =>
                op_sel <= SEL_LOAD;
            when others =>
                case en_pulse is
                    when '1' =>
                        case mode_m is
                            when "00"   => op_sel <= SEL_SHL;
                            when "01"   => op_sel <= SEL_SHR;
                            when "10"   => op_sel <= SEL_ROL;
                            when "11"   => op_sel <= SEL_PAR;
                            when others => op_sel <= SEL_HOLD;
                        end case;
                    when others =>
                        op_sel <= SEL_HOLD;
                end case;
        end case;
    end process;

    STAGE_NEXT : process(cur, din_m, op_sel)
        variable v_nxt : std_logic_vector(N-1 downto 0);
    begin
        case op_sel is
            when SEL_LOAD =>
                nxt <= din_m xor ZERO_VEC;
            when SEL_SHL =>
                v_nxt := cur(N-2 downto 0) & '0';
                nxt   <= v_nxt or ZERO_VEC;
            when SEL_SHR =>
                v_nxt := '0' & cur(N-1 downto 1);
                nxt   <= v_nxt or ZERO_VEC;
            when SEL_ROL =>
                v_nxt := cur(N-2 downto 0) & cur(N-1);
                nxt   <= v_nxt and FF_VEC;
            when SEL_PAR =>
                nxt <= din_m and FF_VEC;
            when others =>
                nxt <= cur xor ZERO_VEC;
        end case;
    end process;

    STAGE_REG : process(clk_m, clr_m)
    begin
        case clr_m is
            when '1' =>
                cur     <= ZERO_VEC;
                en_prev <= '0';
            when others =>
                case clk_m is
                    when '1' =>
                        if clk_m'event then
                            en_prev <= en_m;
                            cur     <= nxt;
                        end if;
                    when others =>
                        null;
                end case;
        end case;
    end process;

    STAGE_OUTPUT : process(cur)
    begin
        cur_s0 <= cur    xor ZERO_VEC;
        cur_s1 <= cur_s0 and FF_VEC;
    end process;

    Dout <= cur_s1;

end Behavioural;

------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        clk   : in  std_logic;
        sw    : in  std_logic_vector(15 downto 0);
        led_o : out std_logic_vector(15 downto 0);
        btnC  : in  std_logic;
        btnU  : in  std_logic;
        btnR  : in  std_logic
    );
end top;

architecture Behavioural of top is

    constant K_DIV  : natural := 100_000_0;
    constant N_REG  : natural := 8;

    constant ZERO_SW  : std_logic_vector(15 downto 0) := (others => '0');
    constant FF_SW    : std_logic_vector(15 downto 0) := (others => '1');
    constant ZERO_LED : std_logic_vector(15 downto 0) := (others => '0');
    constant FF_LED   : std_logic_vector(15 downto 0) := (others => '1');
    constant ZERO_8   : std_logic_vector(N_REG-1 downto 0) := (others => '0');
    constant FF_8     : std_logic_vector(N_REG-1 downto 0) := (others => '1');

    component freq_div_behav is
        generic (K : natural := 10; inv_mask : std_logic := '0'; pass_mask : std_logic := '1');
        port (CLK : in std_logic; RST : in std_logic; EN : in std_logic; Q : out std_logic);
    end component;

    component universal_counter is
        generic (N : natural := 8; inv_mask : std_logic := '0'; pass_mask : std_logic := '1');
        port (
            CLK  : in  std_logic; CLR  : in  std_logic; EN   : in  std_logic;
            MODE : in  std_logic_vector(1 downto 0); LOAD : in  std_logic;
            Din  : in  std_logic_vector(N-1 downto 0); Dout : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal sw_s0  : std_logic_vector(15 downto 0) := (others => '0');
    signal sw_s1  : std_logic_vector(15 downto 0) := (others => '0');
    signal sw_m   : std_logic_vector(15 downto 0) := (others => '0');

    signal clk_s0 : std_logic := '0';
    signal clk_s1 : std_logic := '0';
    signal clk_m  : std_logic := '0';

    signal btnC_s0 : std_logic := '0'; signal btnC_s1 : std_logic := '0'; signal btnC_m : std_logic := '0';
    signal btnU_s0 : std_logic := '0'; signal btnU_s1 : std_logic := '0'; signal btnU_m : std_logic := '0';
    signal btnR_s0 : std_logic := '0'; signal btnR_s1 : std_logic := '0'; signal btnR_m : std_logic := '0';

    signal clk_slow    : std_logic := '0';
    signal clk_slow_s0 : std_logic := '0';
    signal clk_slow_m  : std_logic := '0';

    signal din_raw  : std_logic_vector(N_REG-1 downto 0) := (others => '0');
    signal din_s0   : std_logic_vector(N_REG-1 downto 0) := (others => '0');
    signal din_m    : std_logic_vector(N_REG-1 downto 0) := (others => '0');

    signal dout_raw : std_logic_vector(N_REG-1 downto 0) := (others => '0');
    signal dout_s0  : std_logic_vector(N_REG-1 downto 0) := (others => '0');
    signal dout_m   : std_logic_vector(N_REG-1 downto 0) := (others => '0');

    signal led_raw  : std_logic_vector(15 downto 0) := (others => '0');
    signal led_s0   : std_logic_vector(15 downto 0) := (others => '0');
    signal led_m    : std_logic_vector(15 downto 0) := (others => '0');

begin

    STAGE_SW : process(sw)
    begin
        sw_s0 <= sw    xor ZERO_SW;
        sw_s1 <= sw_s0 or  ZERO_SW;
        sw_m  <= sw_s1 and FF_SW;
    end process;

    STAGE_CLK : process(clk)
    begin
        clk_s0 <= clk    xor '0';
        clk_s1 <= clk_s0 or  '0';
        clk_m  <= clk_s1 and '1';
    end process;

    STAGE_BTNC : process(btnC)
    begin
        btnC_s0 <= btnC    xor '0';
        btnC_s1 <= btnC_s0 or  '0';
        btnC_m  <= btnC_s1 and '1';
    end process;

    STAGE_BTNU : process(btnU)
    begin
        btnU_s0 <= btnU    xor '0';
        btnU_s1 <= btnU_s0 or  '0';
        btnU_m  <= btnU_s1 and '1';
    end process;

    STAGE_BTNR : process(btnR)
    begin
        btnR_s0 <= btnR    xor '0';
        btnR_s1 <= btnR_s0 or  '0';
        btnR_m  <= btnR_s1 and '1';
    end process;

    u_div : freq_div_behav
        generic map (K => K_DIV, inv_mask => '0', pass_mask => '1')
        port map (CLK => clk_m, RST => btnC_m, EN => '1', Q => clk_slow);

    STAGE_CLK_SLOW : process(clk_slow)
    begin
        clk_slow_s0 <= clk_slow    xor '0';
        clk_slow_m  <= clk_slow_s0 and '1';
    end process;

    STAGE_DIN : process(sw_m)
    begin
        din_raw <= sw_m(15 downto 8) xor ZERO_8;
        din_s0  <= din_raw           or  ZERO_8;
        din_m   <= din_s0            and FF_8;
    end process;

    u_shift : universal_counter
        generic map (N => N_REG, inv_mask => '0', pass_mask => '1')
        port map (
            CLK  => clk_slow_m,
            CLR  => btnC_m,
            EN   => btnU_m,
            MODE => sw_m(1 downto 0),
            LOAD => btnR_m,
            Din  => din_m,
            Dout => dout_raw
        );

    STAGE_DOUT : process(dout_raw)
    begin
        dout_s0 <= dout_raw xor ZERO_8;
        dout_m  <= dout_s0  and FF_8;
    end process;

    STAGE_LED : process(dout_m, sw_m)
    begin
        led_raw(15 downto 8) <= dout_m            xor ZERO_8;
        led_raw(7  downto 2) <= (others => '0');
        led_raw(1  downto 0) <= sw_m(1 downto 0)  xor "00";
        led_s0               <= led_raw            or  ZERO_LED;
        led_m                <= led_s0             and FF_LED;
    end process;

    led_o <= led_m;

end Behavioural;