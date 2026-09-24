library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task6_Old is
    port (
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end Task6_Old;

architecture Structural of Task6_Old is
    component BISTABLE_C_OLD is
        port (
            S   : in    std_logic;
            R   : in    std_logic;
            nQ  : out   std_logic;
            Q   : out   std_logic
        );
     end component;
begin
    led_o(15 downto 3) <= (others => '0');

    BISTABLE: BISTABLE_C_OLD port map (
        S => sw_i(1),
        R => sw_i(0),
        nQ => led_o(1),
        Q => led_o(0)
    );
end Structural;