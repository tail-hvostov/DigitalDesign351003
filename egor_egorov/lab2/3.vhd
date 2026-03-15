library ieee;
use ieee.std_logic_1164.all;

entity INV_gate is
    generic (Delay : time := 1 ns);
    port (
        I: in std_logic;
        O: out std_logic        
    );   
end INV_gate;

architecture Behaviour of INV_gate is
begin
    O <= not I after Delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity OR2_gate is
    generic (Delay : time := 1 ns);
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end OR2_gate;

architecture Behaviour of OR2_gate is
begin
    F <= A or B after Delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity AND2_gate is
    generic (Delay : time := 1 ns);
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end AND2_gate;

architecture Behaviour of AND2_gate is
begin
    F <= A or B after Delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity interconnect_delay is
    generic (Delay : time := 0.5 ns);
    port (
        input: in std_logic;
        output: out std_logic
    );
end interconnect_delay;

architecture Behavioral of interconnect_delay is
begin
    output <= input after Delay;
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity top is
    generic (
        GATE_DELAY : time := 5 ns;
        WIRE_DELAY : time := 1 ns
    );
    port (
        sw: in std_logic_vector(3 downto 0);
        led_o: out std_logic_vector(3 downto 0)
    );
end top;

architecture rtl of top is
    component AND2_gate is
        generic (Delay : time);
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    component INV_gate is
        generic (Delay : time);
        port (I: in std_logic; O: out std_logic);
    end component;
    
    component OR2_gate is
        generic (Delay : time);
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    component interconnect_delay is
        generic (Delay : time);
        port (input: in std_logic; output: out std_logic);
    end component;
    
    signal A, B, C, D : std_logic;
    signal not_A, not_B, not_C, not_D : std_logic;
    
    signal A_wire, B_wire, C_wire, D_wire : std_logic;
    signal not_A_wire, not_B_wire, not_C_wire, not_D_wire : std_logic;
    
    signal L0_t1_12, L0_t1_123, L0_term1 : std_logic;
    signal L0_t2_12, L0_t2_123, L0_term2 : std_logic;
    signal L0_t3_12, L0_t3_123, L0_term3 : std_logic;
    signal L0_or1 : std_logic;
    
    signal L1_t1_12, L1_t1_123, L1_term1 : std_logic;
    signal L1_t2_12, L1_t2_123, L1_term2 : std_logic;
    
    signal L2_t1_12, L2_term1 : std_logic;
    signal L2_t2_12, L2_t2_123, L2_term2 : std_logic;
    
    signal L3_t1_12, L3_t1_123, L3_term1 : std_logic;
    signal L3_t2_12, L3_t2_123, L3_term2 : std_logic;
    
begin
    A <= sw(3);
    B <= sw(2);
    C <= sw(1);
    D <= sw(0);
    
    wire_A: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => A, output => A_wire);
    wire_B: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => B, output => B_wire);
    wire_C: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => C, output => C_wire);
    wire_D: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => D, output => D_wire);
    
    inv_A: INV_gate generic map (Delay => GATE_DELAY) port map (I => A_wire, O => not_A);
    inv_B: INV_gate generic map (Delay => GATE_DELAY) port map (I => B_wire, O => not_B);
    inv_C: INV_gate generic map (Delay => GATE_DELAY) port map (I => C_wire, O => not_C);
    inv_D: INV_gate generic map (Delay => GATE_DELAY) port map (I => D_wire, O => not_D);
    
    wire_not_A: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => not_A, output => not_A_wire);
    wire_not_B: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => not_B, output => not_B_wire);
    wire_not_C: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => not_C, output => not_C_wire);
    wire_not_D: interconnect_delay generic map (Delay => WIRE_DELAY) port map (input => not_D, output => not_D_wire);
    
    -- L0 = (not_A and B and not_C and not_D) or (not_A and B and C and D) or (A and not_B and C and not_D)
    
    L0_and1_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => not_A_wire, B => B_wire, F => L0_t1_12);
    wire_L0_t1_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t1_12, output => L0_t1_12);
    
    L0_and1_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t1_12, B => not_C_wire, F => L0_t1_123);
    wire_L0_t1_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t1_123, output => L0_t1_123);
    
    L0_and1: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t1_123, B => not_D_wire, F => L0_term1);
    
    L0_and2_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => not_A_wire, B => B_wire, F => L0_t2_12);
    wire_L0_t2_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t2_12, output => L0_t2_12);
    
    L0_and2_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t2_12, B => C_wire, F => L0_t2_123);
    wire_L0_t2_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t2_123, output => L0_t2_123);
    
    L0_and2: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t2_123, B => D_wire, F => L0_term2);
    
    L0_and3_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => A_wire, B => not_B_wire, F => L0_t3_12);
    wire_L0_t3_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t3_12, output => L0_t3_12);
    
    L0_and3_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t3_12, B => C_wire, F => L0_t3_123);
    wire_L0_t3_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_t3_123, output => L0_t3_123);
    
    L0_and3: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_t3_123, B => not_D_wire, F => L0_term3);
    
    L0_or1_gate: OR2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_term1, B => L0_term2, F => L0_or1);
    wire_L0_or1: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L0_or1, output => L0_or1);
    
    L0_or2_gate: OR2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L0_or1, B => L0_term3, F => led_o(0));
    
    -- L1 = (A and not_B and not_C and not_D) or (not_A and B and not_C and D)
    
    L1_and1_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => A_wire, B => not_B_wire, F => L1_t1_12);
    wire_L1_t1_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L1_t1_12, output => L1_t1_12);
    
    L1_and1_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L1_t1_12, B => not_C_wire, F => L1_t1_123);
    wire_L1_t1_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L1_t1_123, output => L1_t1_123);
    
    L1_and1: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L1_t1_123, B => not_D_wire, F => L1_term1);
    
    L1_and2_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => not_A_wire, B => B_wire, F => L1_t2_12);
    wire_L1_t2_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L1_t2_12, output => L1_t2_12);
    
    L1_and2_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L1_t2_12, B => not_C_wire, F => L1_t2_123);
    wire_L1_t2_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L1_t2_123, output => L1_t2_123);
    
    L1_and2: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L1_t2_123, B => D_wire, F => L1_term2);
    
    L1_or: OR2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L1_term1, B => L1_term2, F => led_o(1));
    
    -- L2 = (not_A and B and C) or (A and not_B and not_C and not_D)
    
    L2_and1_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => not_A_wire, B => B_wire, F => L2_t1_12);
    wire_L2_t1_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L2_t1_12, output => L2_t1_12);
    
    L2_and1: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L2_t1_12, B => C_wire, F => L2_term1);
    
    L2_and2_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => A_wire, B => not_B_wire, F => L2_t2_12);
    wire_L2_t2_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L2_t2_12, output => L2_t2_12);
    
    L2_and2_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L2_t2_12, B => not_C_wire, F => L2_t2_123);
    wire_L2_t2_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L2_t2_123, output => L2_t2_123);
    
    L2_and2: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L2_t2_123, B => not_D_wire, F => L2_term2);
    
    L2_or: OR2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L2_term1, B => L2_term2, F => led_o(2));
    
    -- L3 = (A and not_B and not_C and D) or (A and not_B and C and not_D)
    
    L3_and1_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => A_wire, B => not_B_wire, F => L3_t1_12);
    wire_L3_t1_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L3_t1_12, output => L3_t1_12);
    
    L3_and1_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L3_t1_12, B => not_C_wire, F => L3_t1_123);
    wire_L3_t1_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L3_t1_123, output => L3_t1_123);
    
    L3_and1: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L3_t1_123, B => D_wire, F => L3_term1);
    
    L3_and2_12: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => A_wire, B => not_B_wire, F => L3_t2_12);
    wire_L3_t2_12: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L3_t2_12, output => L3_t2_12);
    
    L3_and2_123: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L3_t2_12, B => C_wire, F => L3_t2_123);
    wire_L3_t2_123: interconnect_delay generic map (Delay => WIRE_DELAY) 
        port map (input => L3_t2_123, output => L3_t2_123);
    
    L3_and2: AND2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L3_t2_123, B => not_D_wire, F => L3_term2);
    
    L3_or: OR2_gate generic map (Delay => GATE_DELAY) 
        port map (A => L3_term1, B => L3_term2, F => led_o(3));
    
end rtl;