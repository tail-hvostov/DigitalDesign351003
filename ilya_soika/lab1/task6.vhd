library ieee;
use ieee.std_logic_1164.all;

entity testTop6 is
    port (
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end testTop6;

architecture rtl of testTop6 is
    signal G3, G2, G1, G0: std_logic;
    signal L3, L2, L1, L0: std_logic;    
begin
    G3 <= sw(3); G2 <= sw(2); G1 <= sw(1); G0 <= sw(0); 
    L3 <= (G3 and (not G1) and G0) or (G3 and (not G2) and G1);
    L2 <= ((not G3) and G2 and (not G1) and (not G0)) or (G3 and (not G2) and (not G1) and (not G0));
    L1 <= ((not G2) and G1 and G0) or ((not G3) and (not G2) and G1) or (G3 and (not G1) and (not G0));
    L0 <= ((not G3) and (not G2) and G0) or (G2 and (not G1) and (not G0)) or (G3 and (not G2) and G1 and (not G0));
    led(3) <= L3; led(2) <= L2; led(1) <= L1; led(0) <= L0; 
end rtl;