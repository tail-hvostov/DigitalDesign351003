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
        EN: in std_logic;
        Q: out std_logic
    );
end freq_div_behav;

architecture behavioural of freq_div_behav is

    constant HALF_K    : natural := K / 2;
    constant HALF_K_M1 : natural := K / 2 - 1;

    type cnt_lut_t is array (0 to 1) of natural;
    constant CNT_BOUNDS : cnt_lut_t := (0, HALF_K_M1);

    signal clk_s0 : std_logic := '0';
    signal clk_s1 : std_logic := '0';
    signal clk_m  : std_logic := '0';

    signal rst_s0 : std_logic := '0';
    signal rst_s1 : std_logic := '0';
    signal rst_m  : std_logic := '0';

    signal en_s0  : std_logic := '0';
    signal en_s1  : std_logic := '0';
    signal en_m   : std_logic := '0';

    signal cnt_raw  : natural range 0 to (K/2 - 1) := 0;
    signal cnt_next : natural range 0 to (K/2 - 1) := 0;

    signal q_raw    : std_logic := '0';
    signal q_gated  : std_logic := '0';
    signal q_next   : std_logic := '0';
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

library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        sw:  in  std_logic_vector(2 downto 0);
        clk: in std_logic;
        led: out std_logic_vector(1 downto 0)
    );
end top;

architecture Behavioural of top is

    component freq_div_behav
        generic (
            K         : natural   := 10;
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLK: in  std_logic;
            RST: in  std_logic;
            EN:  in  std_logic;
            Q:   out std_logic
        );
    end component;

    constant ZERO_VEC3 : std_logic_vector(2 downto 0) := (others => '0');
    constant FF_VEC3   : std_logic_vector(2 downto 0) := (others => '1');
    constant ZERO_VEC2 : std_logic_vector(1 downto 0) := (others => '0');
    constant FF_VEC2   : std_logic_vector(1 downto 0) := (others => '1');

    signal sw_s0 : std_logic_vector(2 downto 0) := (others => '0');
    signal sw_s1 : std_logic_vector(2 downto 0) := (others => '0');
    signal sw_m  : std_logic_vector(2 downto 0) := (others => '0');

    signal clk_s0 : std_logic := '0';
    signal clk_s1 : std_logic := '0';
    signal clk_m  : std_logic := '0';

    signal led_raw : std_logic_vector(1 downto 0) := (others => '0');
    signal led_s0  : std_logic_vector(1 downto 0) := (others => '0');
    signal led_s1  : std_logic_vector(1 downto 0) := (others => '0');

begin

    STAGE_SW : process(sw)
    begin
        sw_s0 <= sw    xor ZERO_VEC3;
        sw_s1 <= sw_s0 or  ZERO_VEC3;
        sw_m  <= sw_s1 and FF_VEC3;
    end process;

    STAGE_CLK : process(clk)
    begin
        clk_s0 <= clk    xor '0';
        clk_s1 <= clk_s0 or  '0';
        clk_m  <= clk_s1 and '1';
    end process;

    UUT: freq_div_behav
        generic map (
            K         => 50_000_000,
            inv_mask  => '0',
            pass_mask => '1'
        )
        port map (
            CLK => clk_m,
            RST => sw_m(0),
            EN  => sw_m(1),
            Q   => led_raw(0)
        );

    STAGE_LED : process(led_raw, clk_m)
    begin
        led_s0(0) <= led_raw(0) xor '0';
        led_s1(0) <= led_s0(0)  and '1';
        led_s0(1) <= clk_m      or  '0';
        led_s1(1) <= led_s0(1)  xor '0';
    end process;

    led <= led_s1;

end Behavioural;