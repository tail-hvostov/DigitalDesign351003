library ieee;
use ieee.std_logic_1164.all;

entity RSlatch is
    generic (
        gate_delay  : time    := 5 ns;
        keep_attr   : string  := "TRUE";
        inv_mask    : std_logic := '0';
        pass_mask   : std_logic := '1'
    );
    port (
        S  : in  std_logic;
        R  : in  std_logic;
        Q  : out std_logic;
        nQ : out std_logic
    );
end entity RSlatch;

architecture Behavioral of RSlatch is

    signal s0         : std_logic := '0';
    signal s1         : std_logic := '0';
    signal r_masked   : std_logic := '0';
    signal s_masked   : std_logic := '0';
    signal r_stage0   : std_logic := '0';
    signal r_stage1   : std_logic := '0';
    signal s_stage0   : std_logic := '0';
    signal s_stage1   : std_logic := '0';
    signal s0_raw     : std_logic := '0';
    signal s1_raw     : std_logic := '0';
    signal s0_gated   : std_logic := '0';
    signal s1_gated   : std_logic := '0';
    signal q_stage0   : std_logic := '0';
    signal q_stage1   : std_logic := '0';
    signal nq_stage0  : std_logic := '0';
    signal nq_stage1  : std_logic := '0';
    signal nor_in_r   : std_logic := '0';
    signal nor_in_s   : std_logic := '0';

    attribute KEEP : string;
    attribute KEEP of s0       : signal is "TRUE";
    attribute KEEP of s1       : signal is "TRUE";
    attribute KEEP of s0_raw   : signal is "TRUE";
    attribute KEEP of s1_raw   : signal is "TRUE";
    attribute KEEP of s0_gated : signal is "TRUE";
    attribute KEEP of s1_gated : signal is "TRUE";

    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of s0       : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1       : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s0_raw   : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1_raw   : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s0_gated : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1_gated : signal is "TRUE";

begin

    r_stage0 <= R        xor inv_mask;
    r_stage1 <= r_stage0 or  inv_mask;
    r_masked <= r_stage1 and pass_mask;

    s_stage0 <= S        xor inv_mask;
    s_stage1 <= s_stage0 or  inv_mask;
    s_masked <= s_stage1 and pass_mask;

    nor_in_r <= r_masked or  inv_mask;
    nor_in_s <= s_masked xor inv_mask;

    s0_raw   <= nor_in_r nor s1         after gate_delay;
    s1_raw   <= nor_in_s nor s0         after gate_delay;

    s0_gated <= s0_raw   and pass_mask  after gate_delay;
    s1_gated <= s1_raw   or  inv_mask   after gate_delay;

    s0 <= s0_gated xor inv_mask;
    s1 <= s1_gated and pass_mask;

    q_stage0  <= s0       or  inv_mask;
    q_stage1  <= q_stage0 and pass_mask;
    nq_stage0 <= s1       xor inv_mask;
    nq_stage1 <= nq_stage0 or inv_mask;

    Q  <= q_stage1  and pass_mask;
    nQ <= nq_stage1 xor inv_mask;

end architecture Behavioral;


library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        sw    : in  std_logic_vector(1 downto 0);
        led_o : out std_logic_vector(1 downto 0)
    );
end entity top;

architecture Behavioral of top is

    component RSlatch is
        generic (
            gate_delay : time;
            keep_attr  : string;
            inv_mask   : std_logic;
            pass_mask  : std_logic
        );
        port (
            S  : in  std_logic;
            R  : in  std_logic;
            Q  : out std_logic;
            nQ : out std_logic
        );
    end component RSlatch;

    signal sw_buf    : std_logic_vector(1 downto 0) := (others => '0');
    signal sw_xored  : std_logic_vector(1 downto 0) := (others => '0');
    signal s_pre     : std_logic := '0';
    signal r_pre     : std_logic := '0';
    signal s_in      : std_logic := '0';
    signal r_in      : std_logic := '0';
    signal q_wire    : std_logic := '0';
    signal nq_wire   : std_logic := '0';
    signal q_gated   : std_logic := '0';
    signal nq_gated  : std_logic := '0';
    signal led_pre   : std_logic_vector(1 downto 0) := (others => '0');
    signal led_buf   : std_logic_vector(1 downto 0) := (others => '0');

begin

    sw_buf   <= sw       and "11";
    sw_xored <= sw_buf   xor "00";

    s_pre <= sw_xored(1) or  '0';
    r_pre <= sw_xored(0) and '1';
    s_in  <= s_pre       xor '0';
    r_in  <= r_pre       or  '0';

    RS : RSlatch
        generic map (
            gate_delay => 5 ns,
            keep_attr  => "TRUE",
            inv_mask   => '0',
            pass_mask  => '1'
        )
        port map (
            S  => s_in,
            R  => r_in,
            Q  => q_wire,
            nQ => nq_wire
        );

    q_gated  <= q_wire  and '1';
    nq_gated <= nq_wire or  '0';

    led_pre(1) <= q_gated  xor '0';
    led_pre(0) <= nq_gated or  '0';

    led_buf <= led_pre and "11";
    led_o   <= led_buf xor "00";

end architecture Behavioral;