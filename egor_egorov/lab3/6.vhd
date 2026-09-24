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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity pwm_controller is
    generic (
        CNT_WIDTH : natural   := 8;
        inv_mask  : std_logic := '0';
        pass_mask : std_logic := '1'
    );
    port (
        CLK:  in std_logic;
        CLR:  in std_logic;
        EN:   in std_logic;
        FILL: in std_logic_vector(CNT_WIDTH-1 downto 0);
        Q:    out std_logic
    );
end pwm_controller;

architecture Behavioral of pwm_controller is

    type cmp_sel_t is (CMP_ZERO, CMP_HIGH, CMP_LOW);

    constant ZERO_VEC : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '0');
    constant FF_VEC   : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '1');

    signal clk_s0  : std_logic := '0';
    signal clk_s1  : std_logic := '0';
    signal clk_m   : std_logic := '0';
    signal clr_s0  : std_logic := '0';
    signal clr_s1  : std_logic := '0';
    signal clr_m   : std_logic := '0';
    signal en_s0   : std_logic := '0';
    signal en_s1   : std_logic := '0';
    signal en_m    : std_logic := '0';

    signal fill_s0 : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '0');
    signal fill_s1 : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '0');
    signal fill_m  : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '0');

    signal cnt_raw  : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
    signal cnt_next : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');

    signal cmp_sel  : cmp_sel_t := CMP_ZERO;

    signal q_raw    : std_logic := '0';
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

    STAGE_INPUT_FILL : process(FILL)
    begin
        fill_s0 <= FILL    xor ZERO_VEC;
        fill_s1 <= fill_s0 or  ZERO_VEC;
        fill_m  <= fill_s1 and FF_VEC;
    end process;

    STAGE_CNT_NEXT : process(cnt_raw, en_m)
    begin
        case en_m is
            when '1'    => cnt_next <= (cnt_raw + 1) and unsigned(FF_VEC);
            when others => cnt_next <= cnt_raw        xor to_unsigned(0, CNT_WIDTH);
        end case;
    end process;

    STAGE_REG : process(clk_m, clr_m)
    begin
        case clr_m is
            when '1' =>
                cnt_raw <= to_unsigned(0, CNT_WIDTH) or to_unsigned(0, CNT_WIDTH);
            when others =>
                case clk_m is
                    when '1' =>
                        if clk_m'event then
                            cnt_raw <= cnt_next;
                        end if;
                    when others =>
                        null;
                end case;
        end case;
    end process;

    STAGE_CMP_SEL : process(cnt_raw, fill_m)
        variable v_fill_u : unsigned(CNT_WIDTH-1 downto 0);
    begin
        v_fill_u := unsigned(fill_m) or to_unsigned(0, CNT_WIDTH);
        case (v_fill_u = to_unsigned(0, CNT_WIDTH)) is
            when true =>
                cmp_sel <= CMP_ZERO;
            when others =>
                case (cnt_raw < v_fill_u) is
                    when true   => cmp_sel <= CMP_HIGH;
                    when others => cmp_sel <= CMP_LOW;
                end case;
        end case;
    end process;

    STAGE_Q_NEXT : process(cmp_sel)
    begin
        case cmp_sel is
            when CMP_HIGH   => q_raw <= pass_mask;
            when CMP_ZERO   => q_raw <= inv_mask;
            when others     => q_raw <= inv_mask;
        end case;
    end process;

    STAGE_OUTPUT : process(q_raw)
    begin
        q_gated  <= q_raw    or  inv_mask;
        q_stage0 <= q_gated  and pass_mask;
        q_stage1 <= q_stage0 xor inv_mask;
    end process;

    Q <= q_stage1;

end Behavioral;

------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk:   in  std_logic;
        sw:    in  std_logic_vector(7 downto 0);
        led_o: out std_logic_vector(1 downto 0)
    );
end top;

architecture behavioral of top is

    component freq_div_behav is
        generic (K : natural := 10; inv_mask : std_logic := '0'; pass_mask : std_logic := '1');
        port (CLK : in std_logic; RST : in std_logic; EN : in std_logic; Q : out std_logic);
    end component;

    component pwm_controller is
        generic (CNT_WIDTH : natural := 8; inv_mask : std_logic := '0'; pass_mask : std_logic := '1');
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;

    constant K_DIV    : integer := 1952;
    constant ZERO_8   : std_logic_vector(7 downto 0) := (others => '0');
    constant FF_8     : std_logic_vector(7 downto 0) := (others => '1');
    constant ZERO_LED : std_logic_vector(1 downto 0) := (others => '0');
    constant FF_LED   : std_logic_vector(1 downto 0) := (others => '1');

    signal clk_s0     : std_logic := '0';
    signal clk_s1     : std_logic := '0';
    signal clk_m      : std_logic := '0';

    signal sw_s0      : std_logic_vector(7 downto 0) := (others => '0');
    signal sw_s1      : std_logic_vector(7 downto 0) := (others => '0');
    signal sw_m       : std_logic_vector(7 downto 0) := (others => '0');

    signal clk_new    : std_logic := '0';
    signal clk_new_s0 : std_logic := '0';
    signal clk_new_m  : std_logic := '0';

    signal fill_s0    : std_logic_vector(7 downto 0) := (others => '0');
    signal fill_m     : std_logic_vector(7 downto 0) := (others => '0');

    signal pwm_raw    : std_logic := '0';
    signal pwm_s0     : std_logic := '0';
    signal pwm_m      : std_logic := '0';

    signal led_raw    : std_logic_vector(1 downto 0) := (others => '0');
    signal led_s0     : std_logic_vector(1 downto 0) := (others => '0');
    signal led_m      : std_logic_vector(1 downto 0) := (others => '0');

begin

    STAGE_CLK : process(clk)
    begin
        clk_s0 <= clk    xor '0';
        clk_s1 <= clk_s0 or  '0';
        clk_m  <= clk_s1 and '1';
    end process;

    STAGE_SW : process(sw)
    begin
        sw_s0 <= sw    xor ZERO_8;
        sw_s1 <= sw_s0 or  ZERO_8;
        sw_m  <= sw_s1 and FF_8;
    end process;

    u_div : freq_div_behav
        generic map (K => K_DIV, inv_mask => '0', pass_mask => '1')
        port map (CLK => clk_m, RST => '0', EN => '1', Q => clk_new);

    STAGE_CLK_NEW : process(clk_new)
    begin
        clk_new_s0 <= clk_new    xor '0';
        clk_new_m  <= clk_new_s0 and '1';
    end process;

    STAGE_FILL : process(sw_m)
    begin
        fill_s0 <= sw_m    xor ZERO_8;
        fill_m  <= fill_s0 and FF_8;
    end process;

    u_pwm : pwm_controller
        generic map (CNT_WIDTH => 8, inv_mask => '0', pass_mask => '1')
        port map (
            CLK  => clk_new_m,
            CLR  => '0',
            EN   => '1',
            FILL => fill_m,
            Q    => pwm_raw
        );

    STAGE_PWM : process(pwm_raw)
    begin
        pwm_s0 <= pwm_raw xor '0';
        pwm_m  <= pwm_s0  and '1';
    end process;

    STAGE_LED : process(pwm_m)
    begin
        led_raw(0) <= pwm_m    xor '0';
        led_raw(1) <= '0';
        led_s0     <= led_raw  or  ZERO_LED;
        led_m      <= led_s0   and FF_LED;
    end process;

    led_o <= led_m;

end behavioral;