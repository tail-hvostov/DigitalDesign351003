library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity code_converter_delay is
    port(
        sw_i  : in  STD_LOGIC_VECTOR(4 downto 0);
        led_o : out STD_LOGIC_VECTOR(4 downto 0)
    );
end code_converter_delay;

architecture structural of code_converter_delay is

    component and2_delay
        generic(t_delay : time := 1 ns);
        port(a,b : in STD_LOGIC; y : out STD_LOGIC);
    end component;

    component nand2_delay
        generic(t_delay : time := 1 ns);
        port(a,b : in STD_LOGIC; y : out STD_LOGIC);
    end component;

    component wire_delay
        generic(t_delay : time := 1 ns);
        port(din : in STD_LOGIC; dout : out STD_LOGIC);
    end component;

    component interconnect
        generic(WIDTH : integer := 1; DELAY : time := 1 ns);
        port(bus_i : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
             bus_o : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
    end component;

    signal x, y, sw_delayed, led_delayed : STD_LOGIC_VECTOR(4 downto 0);
    signal t1, t2, t1_d, t2_d : STD_LOGIC;

begin

    W_in: interconnect generic map(5, 1 ns) port map(sw_i, sw_delayed);

    x <= sw_delayed;

    g1: and2_delay  generic map(2 ns) port map(x(4), x(3), t1);
    g1_wire: wire_delay generic map(1 ns) port map(t1, t1_d);
    g2: nand2_delay generic map(2 ns) port map(t1_d, x(1), y(0));

    g3: and2_delay  generic map(2 ns) port map(x(4), x(2), t2);
    g3_wire: wire_delay generic map(1 ns) port map(t2, t2_d);
    g4: nand2_delay generic map(2 ns) port map(t2_d, x(0), y(1));

    g5: nand2_delay generic map(2 ns) port map(x(3), x(2), y(2));
    g6: nand2_delay generic map(2 ns) port map(x(1), x(0), y(3));

    y(4) <= '0';

    W_out: interconnect generic map(5, 1 ns) port map(y, led_delayed);
    led_o <= led_delayed;

end structural;