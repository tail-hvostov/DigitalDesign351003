library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
    port (
    x: in std_logic;
    y: out std_logic
    );
end not_gate;

architecture Behavioral of not_gate is
begin
    y <= not x;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2_gate is
    port (
    x1, x2: in std_logic;
    y: out std_logic
    );
end and2_gate;

architecture Behavioral of and2_gate is
begin
    y <= x1 and x2;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2_gate is
    port (
    x1, x2: in std_logic;
    y: out std_logic
    );
end or2_gate;

architecture Behavioral of or2_gate is
begin
    y <= x1 or x2;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1 is
  Port ( 
  sw_i: in std_logic_vector(3 downto 0);
  led_o: out std_logic_vector(3 downto 0)
  );
end task1;

architecture rtl of task1 is

component not_gate
    Port ( x: in std_logic; y: out std_logic );
end component;

component and2_gate
    Port ( x1, x2: in std_logic; y: out std_logic );
end component;

component or2_gate
    Port ( x1, x2: in std_logic; y: out std_logic );
end component;

signal A, B, C, D: std_logic;
signal nA, nB, nC, nD: std_logic;

signal nA_B, A_nB, C_nD, nC_nD: std_logic;

signal A_nB_nD, A_nC_nD: std_logic;
signal nA_B_C_nD, A_B, A_B_nC_nD: std_logic;
signal nA_B_nC_nD, A_nB_C_nD: std_logic;
signal nA_nB, nA_nB_C_nD, A_nB_nC_nD: std_logic;

begin
    A <= sw_i(3);
    B <= sw_i(2);
    C <= sw_i(1);
    D <= sw_i(0);
    
    NOT_A: not_gate port map (x => A, y => nA);
    NOT_B: not_gate port map (x => B, y => nB);
    NOT_C: not_gate port map (x => C, y => nC);
    NOT_D: not_gate port map (x => D, y => nD);
    
    AND_nA_B: and2_gate port map (x1 => nA, x2 => B, y => nA_B);
    AND_A_nB: and2_gate port map (x1 => A, x2 => nB, y => A_nB);
    AND_C_nD: and2_gate port map (x1 => C, x2 => nD, y => C_nD);
    AND_nC_nD: and2_gate port map (x1 => nC, x2 => nD, y => nC_nD);
       
-- l3 = (g3 * not g2 * not g0) + (g3 * not g1 * not g0)
-- led_o(3) = (A * nB * nD) + (A * nC * nD)

    U1: and2_gate port map (x1 => A_nB, x2 => nD, y => A_nB_nD);
    U2: and2_gate port map (x1 => A, x2 => nC_nD, y => A_nC_nD);
    U3: or2_gate port map (x1 => A_nB_nD, x2 => A_nC_nD, y => led_o(3));
        
-- l2 = (not g3 * g2 * g1 * not g0) + (g3 * g2 * not g1 * not g0)
-- led_o(2) = (nA * B * C * nD) + (A * B * nC * nD)

    U4: and2_gate port map (x1 => nA_B, x2 => C_nD, y => nA_B_C_nD);
    U5: and2_gate port map (x1 => A, x2 => B, y => A_B);
    U6: and2_gate port map (x1 => A_B, x2 => nC_nD, y => A_B_nC_nD);
    U7: or2_gate port map (x1 => nA_B_C_nD, x2 => A_B_nC_nD, y => led_o(2));

-- l1 = (not g3 * g2 * not g1 * not g0) + (g3 * not g2 * g1 * not g0)
-- led_o(1) = (nA * B * nC * nD) + (A * nB * C * nD)

    U8: and2_gate port map (x1 => nA_B, x2 => nC_nD, y => nA_B_nC_nD);
    U9: and2_gate port map (x1 => A_nB, x2 => C_nD, y => A_nB_C_nD);
    U10: or2_gate port map (x1 => nA_B_nC_nD, x2 => A_nB_C_nD, y => led_o(1));

-- l0 = (not g3 * not g2 * g1 * not g0) + (g3 * not g2 * not g1 * not g0)
-- led_o(0) = (nA * nB * C * nD) + (A * nB * nC * nD)

    U11: and2_gate port map (x1 => nA, x2 => nB, y => nA_nB);
    U12: and2_gate port map (x1 => nA_nB, x2 => C_nD, y => nA_nB_C_nD);
    U13: and2_gate port map (x1 => A_nB, x2 => nC_nD, y => A_nB_nC_nD);
    U14: or2_gate port map (x1 => nA_nB_C_nD, x2 => A_nB_nC_nD, y => led_o(0));

end rtl;
