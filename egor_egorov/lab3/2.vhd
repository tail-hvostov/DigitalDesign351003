library ieee;
use ieee.std_logic_1164.all;

entity trigger is
    generic (
        inv_mask  : std_logic := '0';
        pass_mask : std_logic := '1'
    );
    Port (
        CLR_N: in std_logic;
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
end trigger;

architecture Behavioral of trigger is

    signal clr_stage0 : std_logic := '0';
    signal clr_stage1 : std_logic := '0';
    signal clr_masked : std_logic := '0';

    signal d_stage0   : std_logic := '0';
    signal d_stage1   : std_logic := '0';
    signal d_masked   : std_logic := '0';

    signal clk_stage0 : std_logic := '0';
    signal clk_stage1 : std_logic := '0';
    signal clk_masked : std_logic := '0';

    signal q_raw      : std_logic := '0';
    signal q_gated    : std_logic := '0';
    signal q_stage0   : std_logic := '0';
    signal q_stage1   : std_logic := '0';

begin

    STAGE_INPUT_CLR : process(CLR_N)
    begin
        clr_stage0 <= CLR_N   xor inv_mask;
        clr_stage1 <= clr_stage0 or  inv_mask;
        clr_masked <= clr_stage1 and pass_mask;
    end process;

    STAGE_INPUT_D : process(D)
    begin
        d_stage0 <= D        xor inv_mask;
        d_stage1 <= d_stage0 or  inv_mask;
        d_masked <= d_stage1 and pass_mask;
    end process;

    STAGE_INPUT_CLK : process(CLK)
    begin
        clk_stage0 <= CLK        xor inv_mask;
        clk_stage1 <= clk_stage0 or  inv_mask;
        clk_masked <= clk_stage1 and pass_mask;
    end process;

    STAGE_REG : process(clk_masked, clr_masked)
    begin
        case clr_masked is
            when '0' =>
                q_raw <= '0';
            when '1' =>
                case clk_masked is
                    when '1' =>
                        if clk_masked'event then
                            q_raw <= d_masked;
                        end if;
                    when others =>
                        null;
                end case;
            when others =>
                q_raw <= '0';
        end case;
    end process;

    STAGE_OUTPUT : process(q_raw)
    begin
        q_gated  <= q_raw   or  inv_mask;
        q_stage0 <= q_gated and pass_mask;
        q_stage1 <= q_stage0 xor inv_mask;
    end process;

    Q <= q_stage1;

end Behavioral;

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

    component trigger
        generic (
            inv_mask  : std_logic := '0';
            pass_mask : std_logic := '1'
        );
        port (
            CLR_N: in std_logic;
            CLK: in std_logic;
            D: in std_logic;
            Q: out std_logic
        );
    end component;

    signal sw_stage0 : std_logic_vector(2 downto 0) := (others => '0');
    signal sw_stage1 : std_logic_vector(2 downto 0) := (others => '0');
    signal sw_masked : std_logic_vector(2 downto 0) := (others => '0');

    signal clk_s0 : std_logic := '0';
    signal clk_s1 : std_logic := '0';
    signal clk_m  : std_logic := '0';

    signal led_raw  : std_logic_vector(1 downto 0) := (others => '0');
    signal led_s0   : std_logic_vector(1 downto 0) := (others => '0');
    signal led_s1   : std_logic_vector(1 downto 0) := (others => '0');

    constant ZERO_VEC3 : std_logic_vector(2 downto 0) := (others => '0');
    constant FF_VEC3   : std_logic_vector(2 downto 0) := (others => '1');
    constant ZERO_VEC2 : std_logic_vector(1 downto 0) := (others => '0');
    constant FF_VEC2   : std_logic_vector(1 downto 0) := (others => '1');

begin

    STAGE_SW : process(sw)
    begin
        sw_stage0 <= sw        xor ZERO_VEC3;
        sw_stage1 <= sw_stage0 or  ZERO_VEC3;
        sw_masked <= sw_stage1 and FF_VEC3;
    end process;

    STAGE_CLK : process(clk)
    begin
        clk_s0 <= clk   xor '0';
        clk_s1 <= clk_s0 or '0';
        clk_m  <= clk_s1 and '1';
    end process;

    flipflop: trigger
        generic map (
            inv_mask  => '0',
            pass_mask => '1'
        )
        port map (
            CLR_N => sw_masked(2),
            CLK   => clk_m,
            D     => sw_masked(1),
            Q     => led_raw(0)
        );

    STAGE_LED : process(led_raw)
    begin
        led_s0 <= led_raw xor ZERO_VEC2;
        led_s1 <= led_s0  and FF_VEC2;
    end process;

    led <= led_s1;

end Behavioural;