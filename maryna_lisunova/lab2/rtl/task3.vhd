library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
    generic (delay: time := 1 ns);
    port (
    x: in std_logic;
    y: out std_logic
    );
end not_gate;

architecture Behavioral of not_gate is
begin
    y <= (not x) after delay;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2_gate is
    generic (delay: time := 1 ns);
    port (
    x1, x2: in std_logic;
    y: out std_logic
    );
end and2_gate;

architecture Behavioral of and2_gate is
begin
    y <= (x1 and x2) after delay;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2_gate is
    generic (delay: time := 1 ns);
    port (
    x1, x2: in std_logic;
    y: out std_logic
    );
end or2_gate;

architecture Behavioral of or2_gate is
begin
    y <= (x1 or x2) after delay;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wire_delay is
    generic (delay: time := 0.5 ns);
    port (
    x: in std_logic;
    y: out std_logic
    );
end wire_delay;

architecture Behavioral of wire_delay is
begin
    y <= transport x after delay;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task3 is
    generic (
        GATE_DELAY : time := 7 ns;
        CABLE_DELAY : time := 5 ns
    );
    port ( 
        sw_i: in std_logic_vector(3 downto 0);
        led_o: out std_logic_vector(3 downto 0)
    );
end task3;

architecture Behavioral of task3 is
-- Structual
component not_gate
    generic (delay : time);
    Port ( x: in std_logic; y: out std_logic );
end component;

component and2_gate
    generic (delay : time);
    Port ( x1, x2: in std_logic; y: out std_logic );
end component;

component or2_gate
    generic (delay : time);
    Port ( x1, x2: in std_logic; y: out std_logic );
end component;

component wire_delay
    generic (delay : time);
    Port ( x: in std_logic; y: out std_logic );
end component;

signal A, B, C, D: std_logic;
signal nA, nB, nC, nD: std_logic;

signal nA_B, A_nB, C_nD, nC_nD: std_logic;

signal A_nB_nD, A_nC_nD: std_logic;
signal nA_B_C_nD, A_B, A_B_nC_nD: std_logic;
signal nA_B_nC_nD, A_nB_C_nD: std_logic;
signal nA_nB, nA_nB_C_nD, A_nB_nC_nD: std_logic;

signal A_delayed, B_delayed, C_delayed, D_delayed: std_logic;
signal nA_delayed, nB_delayed, nC_delayed, nD_delayed: std_logic;
signal nA_B_delayed, A_nB_delayed, C_nD_delayed, nC_nD_delayed: std_logic;
signal A_nB_nD_delayed, A_nC_nD_delayed: std_logic;
signal nA_B_C_nD_delayed, A_B_delayed, A_B_nC_nD_delayed: std_logic;
signal nA_B_nC_nD_delayed, A_nB_C_nD_delayed: std_logic;
signal nA_nB_delayed, nA_nB_C_nD_delayed, A_nB_nC_nD_delayed: std_logic;

signal l3, l2, l1, l0: std_logic;

begin
    A <= sw_i(3);
    B <= sw_i(2);
    C <= sw_i(1);
    D <= sw_i(0);
    
    DELAY_A: wire_delay generic map (delay => CABLE_DELAY) port map (x => A, y => A_delayed);
    DELAY_B: wire_delay generic map (delay => CABLE_DELAY) port map (x => B, y => B_delayed);
    DELAY_C: wire_delay generic map (delay => CABLE_DELAY) port map (x => C, y => C_delayed);
    DELAY_D: wire_delay generic map (delay => CABLE_DELAY) port map (x => D, y => D_delayed);
    
    NOT_A: not_gate generic map (delay => GATE_DELAY) port map (x => A_delayed, y => nA);
    NOT_B: not_gate generic map (delay => GATE_DELAY) port map (x => B_delayed, y => nB);
    NOT_C: not_gate generic map (delay => GATE_DELAY) port map (x => C_delayed, y => nC);
    NOT_D: not_gate generic map (delay => GATE_DELAY) port map (x => D_delayed, y => nD);
    
    DELAY_nA: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA, y => nA_delayed);
    DELAY_nB: wire_delay generic map (delay => CABLE_DELAY) port map (x => nB, y => nB_delayed);
    DELAY_nC: wire_delay generic map (delay => CABLE_DELAY) port map (x => nC, y => nC_delayed);
    DELAY_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => nD, y => nD_delayed);
    
    AND_nA_B: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_delayed, x2 => B_delayed, y => nA_B);
    AND_A_nB: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_delayed, x2 => nB_delayed, y => A_nB);
    AND_C_nD: and2_gate generic map (delay => GATE_DELAY) port map (x1 => C_delayed, x2 => nD_delayed, y => C_nD);
    AND_nC_nD: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nC_delayed, x2 => nD_delayed, y => nC_nD);
    
    DELAY_nA_B: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA_B, y => nA_B_delayed);
    DELAY_A_nB: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_nB, y => A_nB_delayed);
    DELAY_C_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => C_nD, y => C_nD_delayed);
    DELAY_nC_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => nC_nD, y => nC_nD_delayed);
       
-- l3 = (g3 * not g2 * not g0) + (g3 * not g1 * not g0)
-- led_o(3) = (A * nB * nD) + (A * nC * nD)

    U1: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_nB, x2 => nD, y => A_nB_nD);
    DELAY_A_nB_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_nB_nD, y => A_nB_nD_delayed);
    U2: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_delayed, x2 => nC_nD_delayed, y => A_nC_nD);
    DELAY_A_nC_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_nC_nD, y => A_nC_nD_delayed);
    U3: or2_gate generic map (delay => GATE_DELAY) port map (x1 => A_nB_nD_delayed, x2 => A_nC_nD_delayed, y => l3);
    DELAY_L3: wire_delay generic map (delay => CABLE_DELAY) port map (x => l3, y => led_o(3));    
        
-- l2 = (not g3 * g2 * g1 * not g0) + (g3 * g2 * not g1 * not g0)
-- led_o(2) = (nA * B * C * nD) + (A * B * nC * nD)

    U4: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_B_delayed, x2 => C_nD_delayed, y => nA_B_C_nD);
    DELAY_nA_B_C_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA_B_C_nD, y => nA_B_C_nD_delayed);
    U5: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_delayed, x2 => B_delayed, y => A_B);
    DELAY_A_B: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_B, y => A_B_delayed);
    U6: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_B_delayed, x2 => nC_nD_delayed, y => A_B_nC_nD);
    DELAY_A_B_nC_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_B_nC_nD, y => A_B_nC_nD_delayed);
    U7: or2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_B_C_nD_delayed, x2 => A_B_nC_nD_delayed, y => l2);
    DELAY_L2: wire_delay generic map (delay => CABLE_DELAY) port map (x => l2, y => led_o(2));

-- l1 = (not g3 * g2 * not g1 * not g0) + (g3 * not g2 * g1 * not g0)
-- led_o(1) = (nA * B * nC * nD) + (A * nB * C * nD)

    U8: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_B_delayed, x2 => nC_nD_delayed, y => nA_B_nC_nD);
    DELAY_nA_B_nC_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA_B_nC_nD, y => nA_B_nC_nD_delayed);
    U9: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_nB_delayed, x2 => C_nD_delayed, y => A_nB_C_nD);
    DELAY_A_nB_C_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_nB_C_nD, y => A_nB_C_nD_delayed);
    U10: or2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_B_nC_nD_delayed, x2 => A_nB_C_nD_delayed, y => l1);
    DELAY_L1: wire_delay generic map (delay => CABLE_DELAY) port map (x => l1, y => led_o(1));

-- l0 = (not g3 * not g2 * g1 * not g0) + (g3 * not g2 * not g1 * not g0)
-- led_o(0) = (nA * nB * C * nD) + (A * nB * nC * nD)

    U11: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_delayed, x2 => nB_delayed, y => nA_nB);
    DELAY_nA_nB: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA_nB, y => nA_nB_delayed);
    U12: and2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_nB_delayed, x2 => C_nD_delayed, y => nA_nB_C_nD);
    DELAY_nA_nB_C_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => nA_nB_C_nD, y => nA_nB_C_nD_delayed);
    U13: and2_gate generic map (delay => GATE_DELAY) port map (x1 => A_nB_delayed, x2 => nC_nD_delayed, y => A_nB_nC_nD);
    DELAY_A_nB_nC_nD: wire_delay generic map (delay => CABLE_DELAY) port map (x => A_nB_nC_nD, y => A_nB_nC_nD_delayed);
    U14: or2_gate generic map (delay => GATE_DELAY) port map (x1 => nA_nB_C_nD_delayed, x2 => A_nB_nC_nD_delayed, y => l0);
    DELAY_L0: wire_delay generic map (delay => CABLE_DELAY) port map (x => l0, y => led_o(0));

end Behavioral;
