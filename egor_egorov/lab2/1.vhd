library ieee;
use ieee.std_logic_1164.all;

entity AND2_gate is
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end AND2_gate;

architecture Behaviour of AND2_gate is
begin
    F <= A and B;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity INV_gate is
    port (
        I: in std_logic;
        O: out std_logic        
    );   
end INV_gate;

architecture Behaviour of INV_gate is
begin
    O <= not I;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity OR2_gate is
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end OR2_gate;

architecture Behaviour of OR2_gate is
begin
    F <= A or B;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        sw: in std_logic_vector(3 downto 0);
        led_o: out std_logic_vector(3 downto 0)
    );
end top;

architecture rtl of top is
    component INV_gate 
        Port (I: in std_logic; O: out std_logic);
    end component;
    component AND2_gate 
        Port (A, B: in std_logic; F: out std_logic);
    end component;
    component OR2_gate 
        Port (A, B: in std_logic; F: out std_logic);
    end component;
    
    signal A, B, C, D : std_logic;
    signal not_A, not_B, not_C, not_D : std_logic;
    
    signal L0_term1, L0_t1_12, L0_t1_123 : std_logic;
    signal L0_term2, L0_t2_12, L0_t2_123 : std_logic;
    signal L0_term3, L0_t3_12, L0_t3_123 : std_logic;
    signal L0_or1 : std_logic;
    
    signal L1_term1, L1_t1_12, L1_t1_123 : std_logic;
    signal L1_term2, L1_t2_12, L1_t2_123 : std_logic;
    
    signal L2_term1, L2_t1_12 : std_logic;
    signal L2_term2, L2_t2_12, L2_t2_123 : std_logic;
    
    signal L3_term1, L3_t1_12, L3_t1_123 : std_logic;
    signal L3_term2, L3_t2_12, L3_t2_123 : std_logic;
    
begin
    A <= sw(3);
    B <= sw(2);
    C <= sw(1);
    D <= sw(0);
    
    INV_A: INV_gate port map (I => A, O => not_A);
    INV_B: INV_gate port map (I => B, O => not_B);
    INV_C: INV_gate port map (I => C, O => not_C);
    INV_D: INV_gate port map (I => D, O => not_D);
    
    -- L0 = (not_A and B and not_C and not_D) or (not_A and B and C and D) or (A and not_B and C and not_D)
    
    AND2_L0_t1_12: AND2_gate port map (A => not_A, B => B, F => L0_t1_12);
    AND2_L0_t1_123: AND2_gate port map (A => L0_t1_12, B => not_C, F => L0_t1_123);
    AND2_L0_t1: AND2_gate port map (A => L0_t1_123, B => not_D, F => L0_term1);
    
    AND2_L0_t2_12: AND2_gate port map (A => not_A, B => B, F => L0_t2_12);
    AND2_L0_t2_123: AND2_gate port map (A => L0_t2_12, B => C, F => L0_t2_123);
    AND2_L0_t2: AND2_gate port map (A => L0_t2_123, B => D, F => L0_term2);
    
    AND2_L0_t3_12: AND2_gate port map (A => A, B => not_B, F => L0_t3_12);
    AND2_L0_t3_123: AND2_gate port map (A => L0_t3_12, B => C, F => L0_t3_123);
    AND2_L0_t3: AND2_gate port map (A => L0_t3_123, B => not_D, F => L0_term3);
    
    OR2_L0_1: OR2_gate port map (A => L0_term1, B => L0_term2, F => L0_or1);
    OR2_L0_2: OR2_gate port map (A => L0_or1, B => L0_term3, F => led_o(0));
    
    -- L1 = (A and not_B and not_C and not_D) or (not_A and B and not_C and D)
    
    AND2_L1_t1_12: AND2_gate port map (A => A, B => not_B, F => L1_t1_12);
    AND2_L1_t1_123: AND2_gate port map (A => L1_t1_12, B => not_C, F => L1_t1_123);
    AND2_L1_t1: AND2_gate port map (A => L1_t1_123, B => not_D, F => L1_term1);
    
    AND2_L1_t2_12: AND2_gate port map (A => not_A, B => B, F => L1_t2_12);
    AND2_L1_t2_123: AND2_gate port map (A => L1_t2_12, B => not_C, F => L1_t2_123);
    AND2_L1_t2: AND2_gate port map (A => L1_t2_123, B => D, F => L1_term2);
    
    OR2_L1: OR2_gate port map (A => L1_term1, B => L1_term2, F => led_o(1));
    
    -- L2 = (not_A and B and C) or (A and not_B and not_C and not_D)
    
    AND2_L2_t1_12: AND2_gate port map (A => not_A, B => B, F => L2_t1_12);
    AND2_L2_t1: AND2_gate port map (A => L2_t1_12, B => C, F => L2_term1);
    
    AND2_L2_t2_12: AND2_gate port map (A => A, B => not_B, F => L2_t2_12);
    AND2_L2_t2_123: AND2_gate port map (A => L2_t2_12, B => not_C, F => L2_t2_123);
    AND2_L2_t2: AND2_gate port map (A => L2_t2_123, B => not_D, F => L2_term2);
    
    OR2_L2: OR2_gate port map (A => L2_term1, B => L2_term2, F => led_o(2));
    
    -- L3 = (A and not_B and not_C and D) or (A and not_B and C and not_D)
    
    AND2_L3_t1_12: AND2_gate port map (A => A, B => not_B, F => L3_t1_12);
    
    AND2_L3_t1_123: AND2_gate port map (A => L3_t1_12, B => not_C, F => L3_t1_123);
    AND2_L3_t1: AND2_gate port map (A => L3_t1_123, B => D, F => L3_term1);
    
    AND2_L3_t2_12: AND2_gate port map (A => A, B => not_B, F => L3_t2_12);
    AND2_L3_t2_123: AND2_gate port map (A => L3_t2_12, B => C, F => L3_t2_123);
    AND2_L3_t2: AND2_gate port map (A => L3_t2_123, B => not_D, F => L3_term2);
    
    OR2_L3: OR2_gate port map (A => L3_term1, B => L3_term2, F => led_o(3));
    
end rtl;