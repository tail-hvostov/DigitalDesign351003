library ieee;
use ieee.std_logic_1164.all;
use work.Delayy.all;

entity Task3F is
    port (
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end Task3F;

architecture structural_delayed of Task3F is
    component INV 
        generic (gate_delay : time := INV_DELAY);
        port (I: in std_logic; O: out std_logic);
    end component;
    
    component AND2 
        generic (gate_delay : time := AND2_DELAY);
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    component OR2 
        generic (gate_delay : time := OR2_DELAY);
        port (A, B: in std_logic; F: out std_logic);
    end component;
    
    component wire_delay
        generic (DELAY : time := 0.2 ns);
        port (input: in std_logic; output: out std_logic);
    end component;
    
    signal n_sw3, n_sw2, n_sw1, n_sw0: std_logic;
    signal n_sw3_w, n_sw2_w, n_sw1_w, n_sw0_w: std_logic;
    signal sw3_w, sw2_w, sw1_w, sw0_w: std_logic;
    
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
    
    signal direct_led : std_logic_vector(3 downto 0);

begin
    wire_sw3: wire_delay generic map(DELAY => 0.15 ns) port map(input => sw(3), output => sw3_w);
    wire_sw2: wire_delay generic map(DELAY => 0.15 ns) port map(input => sw(2), output => sw2_w);
    wire_sw1: wire_delay generic map(DELAY => 0.15 ns) port map(input => sw(1), output => sw1_w);
    wire_sw0: wire_delay generic map(DELAY => 0.15 ns) port map(input => sw(0), output => sw0_w);
    
    INV_G3: INV generic map(gate_delay => INV_DELAY) port map (I => sw3_w, O => n_sw3);
    INV_G2: INV generic map(gate_delay => INV_DELAY) port map (I => sw2_w, O => n_sw2);
    INV_G1: INV generic map(gate_delay => INV_DELAY) port map (I => sw1_w, O => n_sw1);
    INV_G0: INV generic map(gate_delay => INV_DELAY) port map (I => sw0_w, O => n_sw0);
    
    wire_nsw3: wire_delay generic map(DELAY => 0.1 ns) port map(input => n_sw3, output => n_sw3_w);
    wire_nsw2: wire_delay generic map(DELAY => 0.1 ns) port map(input => n_sw2, output => n_sw2_w);
    wire_nsw1: wire_delay generic map(DELAY => 0.1 ns) port map(input => n_sw1, output => n_sw1_w);
    wire_nsw0: wire_delay generic map(DELAY => 0.1 ns) port map(input => n_sw0, output => n_sw0_w);

    AND_L0_t1_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw3_w, B => n_sw2_w, F => L0_t1_a);
    AND_L0_term1: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L0_t1_a, B => sw0_w, F => L0_term1);

    AND_L0_t2_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => n_sw2_w, F => L0_t2_a);
    AND_L0_term2: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L0_t2_a, B => n_sw0_w, F => L0_term2);

    AND_L0_t3_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => sw2_w, F => L0_t3_a);
    AND_L0_t3_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L0_t3_b);
    AND_L0_term3: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L0_t3_a, B => L0_t3_b, F => L0_term3);

    OR_L0_1: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L0_term1, B => L0_term2, F => L0_or1);
    OR_L0_2: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L0_or1, B => L0_term3, F => direct_led(0));

    AND_L1_t1_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw3_w, B => n_sw2_w, F => L1_t1_a);
    AND_L1_term1: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L1_t1_a, B => sw1_w, F => L1_term1);

    AND_L1_t2_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => n_sw2_w, F => L1_t2_a);
    AND_L1_t2_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L1_t2_b);
    AND_L1_term2: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L1_t2_a, B => L1_t2_b, F => L1_term2);

    AND_L1_t3_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => n_sw2_w, F => L1_t3_a);
    AND_L1_t3_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw1_w, B => sw0_w, F => L1_t3_b);
    AND_L1_term3: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L1_t3_a, B => L1_t3_b, F => L1_term3);

    AND_L1_t4_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => sw2_w, F => L1_t4_a);
    AND_L1_t4_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L1_t4_b);
    AND_L1_term4: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L1_t4_a, B => L1_t4_b, F => L1_term4);

    OR_L1_1: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L1_term1, B => L1_term2, F => L1_or1);
    OR_L1_2: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L1_term3, B => L1_term4, F => L1_or2);
    OR_L1_3: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L1_or1, B => L1_or2, F => direct_led(1));

    AND_L2_t1_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw3_w, B => sw2_w, F => L2_t1_a);
    AND_L2_t1_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L2_t1_b);
    AND_L2_term1: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L2_t1_a, B => L2_t1_b, F => L2_term1);

    AND_L2_t2_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => n_sw2_w, F => L2_t2_a);
    AND_L2_term2a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L2_t2_a, B => sw1_w, F => L2_term2a);
    AND_L2_term2b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L2_t2_a, B => sw0_w, F => L2_term2b);

    OR_L2_1: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L2_term2a, B => L2_term2b, F => L2_or_combined);

    AND_L2_t3_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => sw2_w, F => L2_t3_a);
    AND_L2_t3_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L2_t3_b);
    AND_L2_term3: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L2_t3_a, B => L2_t3_b, F => L2_term3);

    OR_L2_2: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L2_term1, B => L2_or_combined, F => L2_or1);
    OR_L2_3: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L2_or1, B => L2_term3, F => direct_led(2));

    AND_L3_term1: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => n_sw2_w, F => L3_term1);

    AND_L3_t2_a: AND2 generic map(gate_delay => AND2_DELAY) port map (A => sw3_w, B => sw2_w, F => L3_t2_a);
    AND_L3_t2_b: AND2 generic map(gate_delay => AND2_DELAY) port map (A => n_sw1_w, B => n_sw0_w, F => L3_t2_b);
    AND_L3_term2: AND2 generic map(gate_delay => AND2_DELAY) port map (A => L3_t2_a, B => L3_t2_b, F => L3_term2);

    OR_L3_1: OR2 generic map(gate_delay => OR2_DELAY) port map (A => L3_term1, B => L3_term2, F => direct_led(3));


    led(0) <= sw0_w when sw3_w = '0' else direct_led(0);
    led(1) <= sw1_w when sw3_w = '0' else direct_led(1);
    led(2) <= sw2_w when sw3_w = '0' else direct_led(2);
    led(3) <= '0' when sw3_w = '0' else direct_led(3);

end structural_delayed;