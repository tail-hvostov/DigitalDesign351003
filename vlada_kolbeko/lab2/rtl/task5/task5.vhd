library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5 is
    port (
        led_o   : out   std_logic_vector(15 downto 0)
    );
end Task5;

architecture Structural of Task5 is
    component BISTABLE_U is
        port (
            nQ  : out   std_logic;
            Q   : out   std_logic
        );
    end component;
begin
    BISTABLE: BISTABLE_U port map (
        nQ => led_o(1),
        Q => led_o(0)
    );
end Structural;