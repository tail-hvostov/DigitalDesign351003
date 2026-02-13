library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task7 is
    Port ( 
        sw_i : in  std_logic_vector(2 downto 0);
        led_o : out std_logic_vector(2 downto 0)
    );
end Task7;

architecture Structural of Task7 is
    component decoder3to8
        Port ( sel : in  std_logic_vector(2 downto 0);
               m   : out std_logic_vector(7 downto 0) );
    end component;

    component or4_gate
        Port ( IN1, IN2, IN3, IN4 : in  std_logic;
               Y                  : out std_logic );
    end component;

    component or3_gate
        Port ( IN1, IN2, IN3 : in  std_logic;
               Y             : out std_logic );
    end component;

    signal A, B, C   : std_logic;
    signal m         : std_logic_vector(7 downto 0);
    signal Y0, Y1, Y2 : std_logic;

begin
    A <= sw_i(2);
    B <= sw_i(1);
    C <= sw_i(0);

    DEC: decoder3to8
        port map (
            sel(2) => A,
            sel(1) => B,
            sel(0) => C,
            m      => m
        );

    OR_Y0: or4_gate
        port map (
            IN1 => m(0),
            IN2 => m(2),
            IN3 => m(4),
            IN4 => m(6),
            Y   => Y0
        );

    OR_Y1: or3_gate
        port map (
            IN1 => m(3),
            IN2 => m(6),
            IN3 => m(7),
            Y   => Y1
        );

    OR_Y2: or4_gate
        port map (
            IN1 => m(4),
            IN2 => m(5),
            IN3 => m(6),
            IN4 => m(7),
            Y   => Y2
        );

    led_o <= Y2 & Y1 & Y0;

end Structural;
