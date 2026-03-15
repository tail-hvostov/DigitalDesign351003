library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity code_converter_delay is
    port(
        sw0, sw1, sw2, sw3, sw4 : in STD_LOGIC;
        led0, led1, led2, led3, led4 : out STD_LOGIC
    );
end code_converter_delay;

architecture structural of code_converter_delay is

    component and2_delay
        generic (t_delay : time := 1 ns);
        port(a,b : in STD_LOGIC; y : out STD_LOGIC);
    end component;

    component nand2_delay
        generic (t_delay : time := 1 ns);
        port(a,b : in STD_LOGIC; y : out STD_LOGIC);
    end component;

    component wire_delay
        generic (t_delay : time := 1 ns);
        port(din : in STD_LOGIC; dout : out STD_LOGIC);
    end component;

    signal x : std_logic_vector(4 downto 0);
    signal y : std_logic_vector(4 downto 0);
    signal t1, t2, t1_d, t2_d : std_logic;

begin

    -- ???????? ?????? ??????
    x <= sw4 & sw3 & sw2 & sw1 & sw0;

    -- ??????? 1
    g1: and2_delay generic map(t_delay => 2 ns) port map(a => x(4), b => x(3), y => t1);
    g1_wire: wire_delay generic map(t_delay => 1 ns) port map(din => t1, dout => t1_d);

    -- ??????? 2
    g2: nand2_delay generic map(t_delay => 2 ns) port map(a => t1_d, b => x(1), y => y(0));

    -- ??????? 3
    g3: and2_delay generic map(t_delay => 2 ns) port map(a => x(4), b => x(2), y => t2);
    g3_wire: wire_delay generic map(t_delay => 1 ns) port map(din => t2, dout => t2_d);

    -- ??????? 4
    g4: nand2_delay generic map(t_delay => 2 ns) port map(a => t2_d, b => x(0), y => y(1));

    -- ??????? 5
    g5: nand2_delay generic map(t_delay => 2 ns) port map(a => x(3), b => x(2), y => y(2));

    -- ??????? 6
    g6: nand2_delay generic map(t_delay => 2 ns) port map(a => x(1), b => x(0), y => y(3));

    -- y4 = 0
    y(4) <= '0';

    -- ????? ?? LED
    led0 <= y(0);
    led1 <= y(1);
    led2 <= y(2);
    led3 <= y(3);
    led4 <= y(4);

end structural;