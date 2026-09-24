library ieee;
use ieee.std_logic_1164.all;

entity bit_comporator is 
    port (
        a : in STD_LOGIC; b : in STD_LOGIC;
        lt: out STD_LOGIC; eq: out STD_LOGIC; gt: out STD_LOGIC
    );
end bit_comporator;

-- LT: a and !b
-- EQ: !(a xor b)
-- GT: !a and b
architecture rtl of bit_comporator is   
    constant T_INV:  time := 2 ns;
    constant T_AND:  time := 4 ns; 
    constant T_XOR:  time := 6 ns; 
    
    component inv 
        generic (T: time := T_INV);
        port (i : in std_logic; o : out std_logic);
    end component;
    component and2 
        generic (T : time := T_AND);
        port (i0 : in std_logic; i1 : in std_logic; o : out std_logic);
    end component;
    component xor2 
        generic (T : time := T_XOR);
        port (i0 : in std_logic; i1 : in std_logic; o : out std_logic);
    end component;
    
    signal not_a, not_b : std_logic;
    signal a_xor_b, a_and_nb, na_and_b, : std_logic : std_logic;
begin
    NOT_A: inv port map (i => a, o => not_a);
    NOT_B: inv port map (i => b, o => not_b);
    
    A_XOR_B: xor2 port map (i0 => a, i1 => b, o => a_xor_b);
    NOT_A_XOR_B: inv port map (i => a_xor_b, o => not_a_xor_b);
    
    A_AND_NB: and2 port map (i0 => a, i1 => not_b, o => a_and_nb);
    NA_AND_B: and2 port map (i0 => not_a, i1 => b, o => na_and_b);
    
    GT <= a_and_nb;
    LT <= na_and_b;
    EQ <= not_a_xor_b;
end;