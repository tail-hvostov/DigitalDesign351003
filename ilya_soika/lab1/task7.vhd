library ieee;
use ieee.std_logic_1164.all;

entity MUX2 is
    port (
        A, B, S: in std_logic;
        F: out std_logic
    );
end MUX2;

architecture Behavior of MUX2 is
begin
    F <= A when S = '0' else B;  
end Behavior;

library ieee;
use ieee.std_logic_1164.all;

entity INV is 
    port (
        I: in std_logic;
        O: out std_logic
    );
end INV;

architecture Behavior of INV is
begin
    O <= not I;  
end Behavior;

library ieee;
use ieee.std_logic_1164.all;

entity testTop7 is
    port (
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end testTop7;

architecture Structure of testTop7 is
    component INV 
        Port (I: in std_logic; O: out std_logic);
    end component;
    component MUX2 
        Port (A, B, S: in std_logic; F: out std_logic);
    end component;
    signal G0, G1, G2, G3: std_logic;
    signal NOT_G0, NOT_G1, NOT_G2, NOT_G3: std_logic;
    signal G3_and_G2, G3_and_G0, G3_and_G1, L3_12, L3_RES: std_logic;  
    signal not_G3_and_G2, G3_and_not_G0, G3_not_G0_not_G1, L2_2, L2_RES: std_logic; 
    signal G1_and_G0, not_G3_and_G1, L1_12, L1_RES: std_logic;
    signal not_G3_and_G0, G3_G1_not_G0, L0_12, L0_RES: std_logic;
begin
    G0 <= sw(0); G1 <= sw(1); G2 <= sw(2); G3 <= sw(3); 
    
    INV_G0: INV port map (I => G0, O => NOT_G0);
    INV_G1: INV port map (I => G1, O => NOT_G1);
    INV_G2: INV port map (I => G2, O => NOT_G2);
    INV_G3: INV port map (I => G3, O => NOT_G3);
    
    --L3   
    MUX2_G3_AND_G2: MUX2 port map (A => G3, B => G2, S => G3, F => G3_and_G2);
    MUX2_G3_AND_G0: MUX2 port map (A => G3, B => G0, S => G3, F => G3_and_G0);
    MUX2_G3_AND_G1: MUX2 port map (A => G3, B => G1, S => G3, F => G3_and_G1);
    MUX2_L3_12: MUX2 port map (A => G3_and_G2, B => G3_and_G0, S => G3_and_G0, F => L3_12);    
    MUX2_L3_RES: MUX2 port map (A => L3_12, B => G3_and_G1, S => G3_and_G1, F => L3_RES); 
    led(3) <= L3_RES;  
    
    --L2
    MUX2_NOT_G3_AND_G2: MUX2 port map (A => NOT_G3, B => G2, S => NOT_G3, F => not_G3_and_G2);
    MUX2_G3_AND_NOT_G0: MUX2 port map (A => G3, B => NOT_G0, S => G3, F => G3_and_not_G0);
    MUX2_G3_NOT_G0_NOT_G1: MUX2 port map (A => G3_and_not_G0, B => NOT_G1, S => G3_and_not_G0, F => G3_not_G0_not_G1);
    MUX2_L2_2: MUX2 port map (A => G3_not_G0_not_G1, B => NOT_G2, S => G3_not_G0_not_G1, F => L2_2);
    MUX2_L2_RES: MUX2 port map (A => L2_2, B => not_G3_and_G2, S => not_G3_and_G2, F => L2_RES); 
    led(2) <= L2_RES;
    
    --L1
    MUX2_G1_AND_G0: MUX2 port map (A => G1, B => G0, S => G1, F => G1_and_G0);
    MUX2_NOT_G3_AND_G1: MUX2 port map (A => NOT_G3, B => G1, S => NOT_G3, F => not_G3_and_G1);
    MUX_L1_12: MUX2 port map (A => G1_and_G0, B => not_G3_and_G1, S => not_G3_and_G1, F => L1_12);
    MUX_L1_RES: MUX2 port map (A => L1_12, B => G3_not_G0_not_G1, S => G3_not_G0_not_G1, F => L1_RES); 
    led(1) <= L1_RES;
    
    --L0
    MUX2_NOT_G3_AND_G0: MUX2 port map (A => NOT_G3, B => G0, S => NOT_G3, F => not_G3_and_G0);
    MUX2_G3_G1_NOT_G0: MUX2 port map (A => G3_and_not_G0, B => G1, S => G3_and_not_G0, F => G3_G1_not_G0);
    MUX_L0_12: MUX2 port map (A => G2, B => not_G3_and_G0, S => not_G3_and_G0, F => L0_12);
    MUX_L0_RES: MUX2 port map (A => L0_12, B => G3_G1_not_G0, S => G3_G1_not_G0, F => L0_RES);
    led(0) <= L0_RES;
    
end Structure;


