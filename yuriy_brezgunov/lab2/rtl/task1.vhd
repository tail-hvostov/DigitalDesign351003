library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.VComponents.all;

-- G = 7421
-- L = Berger's code (Sum of 1)

-- c1 = (x3 xor x2)(x1 xor x0) + !x3!x2x1x0
-- c0 = (x3 xor x2) !x1!x0 + !x3!x2(x1 xor x0)

entity task1 is
    port (
        led : out std_logic_vector(15 downto 10); -- led11 = c1, led10 = c0
        sw: in std_logic_vector(15 downto 12) -- x3, x2, x1, x0
    );
end task1;

architecture rtl of task1 is
    component inv 
        Port (i: in std_logic; o: out std_logic);
    end component;
    
    signal not_x0, not_x1, not_x2, not_x3: std_logic;
    signal x3_xor_x2, x1_xor_x0: std_logic;
    signal c1_conj1, c1_conj2_p1, c1_conj2_p2, c1_conj2_p3, c1_res: std_logic;
    signal c0_conj1_p1, c0_conj1_p2, c0_conj2_p1, c0_conj2_p2, c0_conj2_p3, c0_res: std_logic;
begin 
    INV_X0: INV port map (I => sw(12), O => not_x0);
    INV_X1: INV port map (I => sw(13), O => not_x1);
    INV_X2: INV port map (I => sw(14), O => not_x2);
    INV_X3: INV port map (I => sw(15), O => not_x3);
    
    XOR_X2_X3: XOR2 port map (I0 => sw(15), I1 => sw(14), O => x3_xor_x2);
    XOR_X1_X0: XOR2 port map (I0 => sw(13), I1 => sw(12), O => x1_xor_x0);
    
    -- Calculate C1
    -- C1 = (x3 xor x2)(x1 xor x0) + !x3!x2x1x0
    AND_C1_11: AND2 port map (I0 => x3_xor_x2, I1 => x1_xor_x0, O => c1_conj1);
    
    AND_C1_21: AND2 port map (I0 => not_x3, I1 => not_x2, O => c1_conj2_p1);
    AND_C1_22: AND2 port map (I0 => c1_conj2_p1, I1 => sw(13), O => c1_conj2_p2);
    AND_C1_23: AND2 port map (I0 => c1_conj2_p2, I1 => sw(12), O => c1_conj2_p3);
    
    OR_C1: OR2 port map (I0 => c1_conj2_p3, I1 => c1_conj1, O => c1_res);
    
    led(11) <= c1_res;
    
    -- Calculate C0
    -- c0 = (x3 xor x2) !x1!x0 + !x3!x2(x1 xor x0)
    AND_C0_11: AND2 port map (I0 => x3_xor_x2, I1 => not_x1, O => c0_conj1_p1);
    AND_C0_12: AND2 port map (I0 => c0_conj1_p1, I1 => not_x0, O => c0_conj1_p2);
        
    AND_C0_21: AND2 port map (I0 => not_x2, I1 => not_x3, O => c0_conj2_p1);
    AND_C0_22: AND2 port map (I0 => c0_conj2_p1, I1 => x1_xor_x0, O => c0_conj2_p2);
    
    OR_C2: OR2 port map (I0 => c0_conj1_p2, I1 => c0_conj2_p2, O => c0_res);
    
    led(10) <= c0_res;
    
    led(15 downto 12) <= sw;
end rtl;