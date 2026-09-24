library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1 is
    port (
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end task1;

architecture Structural of task1 is
    component rs_latch is
        port (
            R   : in    std_logic;      -- sw_i[1]
            S   : in    std_logic;      -- sw_i[0]
            Q   : out   std_logic;      -- led_o[1]
            nQ  : out   std_logic       -- led_o[0]            
        );
    end component;
begin
    led_o(15 downto 2) <= (others => '0');
    
    rs_latch_0: rs_latch port map (
        R => sw_i(1),
        S => sw_i(0),
        Q => led_o(1),
        nQ => led_o(0)
    );
end Structural;