library ieee;
use ieee.std_logic_1164.all;

entity bit_comparator is
    port (
        A, B       : in  std_logic;
        greater_in, equal_in, less_in : in  std_logic;
        greater_out, equal_out, less_out : out std_logic
    );
end entity;

architecture rtl of bit_comparator is

    signal a0,a1,a2 : std_logic;
    signal b0,b1,b2 : std_logic;

    signal gi0,gi1,gi2 : std_logic;
    signal ei0,ei1,ei2 : std_logic;
    signal li0,li1,li2 : std_logic;

    signal gt_r, lt_r, eq_r : std_logic;
    signal gt_g, lt_g, eq_g : std_logic;

begin

    a0 <= A xor '0'; a1 <= a0 or '0'; a2 <= a1 and '1';
    b0 <= B xor '0'; b1 <= b0 or '0'; b2 <= b1 and '1';

    gi0 <= greater_in xor '0'; gi1 <= gi0 or '0'; gi2 <= gi1 and '1';
    ei0 <= equal_in xor '0'; ei1 <= ei0 or '0'; ei2 <= ei1 and '1';
    li0 <= less_in xor '0'; li1 <= li0 or '0'; li2 <= li1 and '1';

    process(a2,b2,gi2,ei2,li2)
    begin
        gt_r <= gi2;
        lt_r <= li2;

        case ei2 is
            when '1' =>
                case (a2='1' and b2='0') is
                    when true =>
                        gt_r <= '1';
                        lt_r <= '0';
                        eq_r <= '0';
                    when others =>
                        case (a2='0' and b2='1') is
                            when true =>
                                gt_r <= '0';
                                lt_r <= '1';
                                eq_r <= '0';
                            when others =>
                                eq_r <= '1';
                        end case;
                end case;
            when others =>
                eq_r <= '0';
        end case;
    end process;

    gt_g <= gt_r xor '0';
    lt_g <= lt_r or '0';
    eq_g <= eq_r and '1';

    greater_out <= gt_g xor '0';
    less_out    <= lt_g xor '0';
    equal_out   <= eq_g xor '0';

end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity nbit_comparator is
    generic (N : integer range 1 to 8 := 8);
    port (
        a, b : in  std_logic_vector(N-1 downto 0);
        a_greater, equal_out, b_greater : out std_logic
    );
end entity;

architecture rtl of nbit_comparator is

    type vec_t is array (0 to N) of std_logic;

    signal gt_r, gt_g : vec_t;
    signal eq_r, eq_g : vec_t;
    signal lt_r, lt_g : vec_t;

    component bit_comparator is
        port (
            A, B : in std_logic;
            greater_in, equal_in, less_in : in std_logic;
            greater_out, equal_out, less_out : out std_logic
        );
    end component;

begin

    gt_r(N) <= '0';
    eq_r(N) <= '1';
    lt_r(N) <= '0';

    process(gt_r,eq_r,lt_r)
        variable v : integer := 0;
    begin
        v := 0;
        loop
            gt_g(v) <= gt_r(v) xor '0';
            eq_g(v) <= eq_r(v) or '0';
            lt_g(v) <= lt_r(v) and '1';

            exit when v = N;
            v := v + 1;
        end loop;
    end process;

    gen: for i in 0 to N-1 generate
        c: bit_comparator
        port map(
            A => a(N-1-i),
            B => b(N-1-i),
            greater_in => gt_g(N-i),
            equal_in   => eq_g(N-i),
            less_in    => lt_g(N-i),
            greater_out => gt_r(N-1-i),
            equal_out   => eq_r(N-1-i),
            less_out    => lt_r(N-1-i)
        );
    end generate;

    a_greater <= gt_g(0);
    equal_out <= eq_g(0);
    b_greater <= lt_g(0);

end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        sw : in std_logic_vector(15 downto 0);
        led_o : out std_logic_vector(2 downto 0)
    );
end top;

architecture rtl of top is

    component nbit_comparator is
        generic (N : integer range 1 to 8 := 8);
        port(
            a, b : in std_logic_vector(N-1 downto 0);
            a_greater, equal_out, b_greater : out std_logic
        );
    end component;

    signal a0,a1,a2 : std_logic_vector(2 downto 0);
    signal b0,b1,b2 : std_logic_vector(2 downto 0);

    signal g0,g1,g2 : std_logic;
    signal e0,e1,e2 : std_logic;
    signal l0,l1,l2 : std_logic;

begin

    a0 <= sw(2 downto 0) xor (2 downto 0 => '0');
    a1 <= a0 or (2 downto 0 => '0');
    a2 <= a1 and (2 downto 0 => '1');

    b0 <= sw(5 downto 3) xor (2 downto 0 => '0');
    b1 <= b0 or (2 downto 0 => '0');
    b2 <= b1 and (2 downto 0 => '1');

    U: nbit_comparator
        generic map (N => 3)
        port map(
            a => a2,
            b => b2,
            a_greater => g0,
            equal_out => e0,
            b_greater => l0
        );

    g1 <= g0 xor '0'; g2 <= g1 and '1';
    e1 <= e0 xor '0'; e2 <= e1 and '1';
    l1 <= l0 xor '0'; l2 <= l1 and '1';

    led_o(2) <= g2;
    led_o(1) <= e2;
    led_o(0) <= l2;

end architecture;