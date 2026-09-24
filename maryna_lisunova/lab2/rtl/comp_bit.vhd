library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor2_gate is
    generic (delay: time := 1 ns);
    port (
    x1, x2: in std_logic;
    y: out std_logic
    );
end xor2_gate;

architecture Behavioral of xor2_gate is
begin
    y <= (x1 xor x2) after delay;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp_bit is
    generic ( GATE_DELAY : time := 2 ns );
    port (
        a, b : in std_logic;
        g_in, l_in, e_in : in std_logic;
        g_out, l_out, e_out : out std_logic
    );
end comp_bit;

architecture Structural of comp_bit is
    component not_gate 
        generic (delay : time); 
        port ( x: in std_logic; y: out std_logic ); 
    end component;
    
    component and2_gate 
        generic (delay : time); 
        port ( x1, x2: in std_logic; y: out std_logic ); 
    end component;
    
    component or2_gate 
        generic (delay : time); 
        port ( x1, x2: in std_logic; y: out std_logic ); 
    end component;
    
    component xor2_gate 
            generic (delay : time); 
            port ( x1, x2: in std_logic; y: out std_logic ); 
        end component;

        signal na, nb : std_logic;
        signal diff_bit, eq_bit : std_logic;
        signal a_gt_b, a_lt_b : std_logic;
        signal g_term, l_term : std_logic;
    begin
        inv_a: not_gate generic map(GATE_DELAY) port map(x => a, y => na);
        inv_b: not_gate generic map(GATE_DELAY) port map(x => b, y => nb);
    
        -- A = B
        xor1: xor2_gate generic map(GATE_DELAY) port map(x1 => a, x2 => b, y => diff_bit);        
        inv_eq: not_gate generic map(GATE_DELAY) port map(x => diff_bit, y => eq_bit);
        and_ef: and2_gate generic map(GATE_DELAY) port map(x1 => e_in, x2 => eq_bit, y => e_out);
    
        -- A > B 
        and_g1: and2_gate generic map(GATE_DELAY) port map(x1 => a, x2 => nb, y => a_gt_b);
        and_g2: and2_gate generic map(GATE_DELAY) port map(x1 => e_in, x2 => a_gt_b, y => g_term);
        or_g:   or2_gate  generic map(GATE_DELAY) port map(x1 => g_in, x2 => g_term, y => g_out);
    
        -- A < B 
        and_l1: and2_gate generic map(GATE_DELAY) port map(x1 => na, x2 => b, y => a_lt_b);
        and_l2: and2_gate generic map(GATE_DELAY) port map(x1 => e_in, x2 => a_lt_b, y => l_term);
        or_l:   or2_gate  generic map(GATE_DELAY) port map(x1 => l_in, x2 => l_term, y => l_out);
        
end Structural;
