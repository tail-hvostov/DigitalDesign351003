library ieee;
use ieee.std_logic_1164.all;

entity bistable is
    generic (
        inv_mask  : std_logic := '0';
        pass_mask : std_logic := '1'
    );
    port (
        Q: out std_logic
    );
end bistable;

architecture rtl of bistable is

    signal a_s0, a_s1, a_s2 : std_logic;
    signal b_s0, b_s1, b_s2 : std_logic;

    signal q_s0, q_s1, q_s2 : std_logic;

    attribute KEEP : string;
    attribute no_touch : string;

    attribute KEEP of a_s0 : signal is "TRUE";
    attribute KEEP of a_s1 : signal is "TRUE";
    attribute KEEP of a_s2 : signal is "TRUE";
    attribute KEEP of b_s0 : signal is "TRUE";
    attribute KEEP of b_s1 : signal is "TRUE";
    attribute KEEP of b_s2 : signal is "TRUE";

    attribute no_touch of a_s0 : signal is "TRUE";
    attribute no_touch of a_s1 : signal is "TRUE";
    attribute no_touch of a_s2 : signal is "TRUE";
    attribute no_touch of b_s0 : signal is "TRUE";
    attribute no_touch of b_s1 : signal is "TRUE";
    attribute no_touch of b_s2 : signal is "TRUE";

begin

    a_s0 <= (not b_s2) xor inv_mask;
    a_s1 <= a_s0 and pass_mask;
    a_s2 <= a_s1 xor inv_mask;

    b_s0 <= (not a_s2) xor inv_mask;
    b_s1 <= b_s0 and pass_mask;
    b_s2 <= b_s1 xor inv_mask;

    q_s0 <= a_s2 xor inv_mask;
    q_s1 <= q_s0 or inv_mask;
    q_s2 <= q_s1 and pass_mask;

    Q <= q_s2 xor inv_mask;

end rtl;


library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        led_o: out std_logic_vector(15 downto 0)
    );
end top;

architecture rtl of top is

    component bistable
        port (
            Q: out std_logic
        );
    end component;

    signal l_s0, l_s1, l_s2 : std_logic_vector(15 downto 0);

begin

    gen_inst : for i in 0 to 15 generate
        u_i : bistable port map(Q => l_s0(i));
    end generate;

    process(l_s0)
        variable v_idx : integer range 0 to 15 := 0;
    begin
        v_idx := 0;
        loop
            l_s1(v_idx) <= l_s0(v_idx) xor '0';
            l_s2(v_idx) <= l_s1(v_idx) and '1';

            exit when v_idx = 15;
            v_idx := v_idx + 1;
        end loop;
    end process;

    process(l_s2)
        variable v_idx : integer range 0 to 15 := 0;
    begin
        v_idx := 0;
        loop
            led_o(v_idx) <= l_s2(v_idx) xor '0';
            exit when v_idx = 15;
            v_idx := v_idx + 1;
        end loop;
    end process;

end rtl;