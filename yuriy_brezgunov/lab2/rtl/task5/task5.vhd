library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity bistable is
    port (
        led : out std_logic_vector(15 downto 14)
    );
end bistable;

architecture rtl of bistable is
    signal a, b : std_logic;
begin
    lut_a : LUT1
        generic map (
            INIT => "01"
        )
        port map (
            I0 => b,
            O  => a
        );

    lut_b : LUT1
        generic map (
            INIT => "01"
        )
        port map (
            I0 => a,
            O  => b
        );

    led(15) <= a;
    led(14) <= b;

end rtl;