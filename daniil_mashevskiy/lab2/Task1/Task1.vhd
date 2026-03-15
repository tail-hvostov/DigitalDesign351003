library ieee;
use ieee.std_logic_1164.all;

entity INV is
    port (
        I: in std_logic;
        O: out std_logic        
    );   
end INV;

architecture Behaviour of INV is
begin
    O <= not I;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end AND2;

architecture Behaviour of AND2 is
begin
    F <= A and B;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity OR2 is
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end OR2;

architecture Behaviour of OR2 is
begin
    F <= A or B;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity Task1 is
    port (
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end Task1;

architecture structural of Task1 is
    component INV 
        port (I: in std_logic; O: out std_logic);
    end component;
    
    component AND2 
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    component OR2 
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    signal n_sw3, n_sw2, n_sw1, n_sw0: std_logic;
    
    signal L0_t1_a, L0_term1: std_logic;
    signal L0_t2_a, L0_term2: std_logic;
    signal L0_t3_a, L0_t3_b, L0_term3: std_logic;
    signal L0_or1: std_logic;
    
    signal L1_t1_a, L1_term1: std_logic;
    signal L1_t2_a, L1_t2_b, L1_term2: std_logic;
    signal L1_t3_a, L1_t3_b, L1_term3: std_logic;
    signal L1_t4_a, L1_t4_b, L1_term4: std_logic;
    signal L1_or1, L1_or2: std_logic;
    
    signal L2_t1_a, L2_t1_b, L2_term1: std_logic;
    signal L2_t2_a, L2_term2a, L2_term2b: std_logic;
    signal L2_or_combined: std_logic;
    signal L2_t3_a, L2_t3_b, L2_term3: std_logic;
    signal L2_or1: std_logic;
    
    signal L3_t1_a, L3_term1: std_logic;
    signal L3_t2_a, L3_t2_b, L3_term2: std_logic;
    signal L3_or1: std_logic;

begin
    INV_G3: INV port map (I => sw(3), O => n_sw3);
    INV_G2: INV port map (I => sw(2), O => n_sw2);
    INV_G1: INV port map (I => sw(1), O => n_sw1);
    INV_G0: INV port map (I => sw(0), O => n_sw0);

    AND_L0_t1_a: AND2 port map (A => n_sw3, B => n_sw2, F => L0_t1_a);
    AND_L0_term1: AND2 port map (A => L0_t1_a, B => sw(0), F => L0_term1);

    AND_L0_t2_a: AND2 port map (A => sw(3), B => n_sw2, F => L0_t2_a);
    AND_L0_term2: AND2 port map (A => L0_t2_a, B => n_sw0, F => L0_term2);

    AND_L0_t3_a: AND2 port map (A => sw(3), B => sw(2), F => L0_t3_a);
    AND_L0_t3_b: AND2 port map (A => n_sw1, B => n_sw0, F => L0_t3_b);
    AND_L0_term3: AND2 port map (A => L0_t3_a, B => L0_t3_b, F => L0_term3);

    OR_L0_1: OR2 port map (A => L0_term1, B => L0_term2, F => L0_or1);
    OR_L0_2: OR2 port map (A => L0_or1, B => L0_term3, F => led(0));

    AND_L1_t1_a: AND2 port map (A => n_sw3, B => n_sw2, F => L1_t1_a);
    AND_L1_term1: AND2 port map (A => L1_t1_a, B => sw(1), F => L1_term1);

    AND_L1_t2_a: AND2 port map (A => sw(3), B => n_sw2, F => L1_t2_a);
    AND_L1_t2_b: AND2 port map (A => n_sw1, B => n_sw0, F => L1_t2_b);
    AND_L1_term2: AND2 port map (A => L1_t2_a, B => L1_t2_b, F => L1_term2);

    AND_L1_t3_a: AND2 port map (A => sw(3), B => n_sw2, F => L1_t3_a);
    AND_L1_t3_b: AND2 port map (A => sw(1), B => sw(0), F => L1_t3_b);
    AND_L1_term3: AND2 port map (A => L1_t3_a, B => L1_t3_b, F => L1_term3);

    AND_L1_t4_a: AND2 port map (A => sw(3), B => sw(2), F => L1_t4_a);
    AND_L1_t4_b: AND2 port map (A => n_sw1, B => n_sw0, F => L1_t4_b);
    AND_L1_term4: AND2 port map (A => L1_t4_a, B => L1_t4_b, F => L1_term4);

    OR_L1_1: OR2 port map (A => L1_term1, B => L1_term2, F => L1_or1);
    OR_L1_2: OR2 port map (A => L1_term3, B => L1_term4, F => L1_or2);
    OR_L1_3: OR2 port map (A => L1_or1, B => L1_or2, F => led(1));

    AND_L2_t1_a: AND2 port map (A => n_sw3, B => sw(2), F => L2_t1_a);
    AND_L2_t1_b: AND2 port map (A => n_sw1, B => n_sw0, F => L2_t1_b);
    AND_L2_term1: AND2 port map (A => L2_t1_a, B => L2_t1_b, F => L2_term1);

    AND_L2_t2_a: AND2 port map (A => sw(3), B => n_sw2, F => L2_t2_a);
    AND_L2_term2a: AND2 port map (A => L2_t2_a, B => sw(1), F => L2_term2a);
    AND_L2_term2b: AND2 port map (A => L2_t2_a, B => sw(0), F => L2_term2b);

    OR_L2_1: OR2 port map (A => L2_term2a, B => L2_term2b, F => L2_or_combined);

    AND_L2_t3_a: AND2 port map (A => sw(3), B => sw(2), F => L2_t3_a);
    AND_L2_t3_b: AND2 port map (A => n_sw1, B => n_sw0, F => L2_t3_b);
    AND_L2_term3: AND2 port map (A => L2_t3_a, B => L2_t3_b, F => L2_term3);

    OR_L2_2: OR2 port map (A => L2_term1, B => L2_or_combined, F => L2_or1);
    OR_L2_3: OR2 port map (A => L2_or1, B => L2_term3, F => led(2));

    AND_L3_term1: AND2 port map (A => sw(3), B => n_sw2, F => L3_term1);

    AND_L3_t2_a: AND2 port map (A => sw(3), B => sw(2), F => L3_t2_a);
    AND_L3_t2_b: AND2 port map (A => n_sw1, B => n_sw0, F => L3_t2_b);
    AND_L3_term2: AND2 port map (A => L3_t2_a, B => L3_t2_b, F => L3_term2);

    OR_L3_1: OR2 port map (A => L3_term1, B => L3_term2, F => led(3));

end structural;