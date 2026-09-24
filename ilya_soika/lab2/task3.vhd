library ieee;
use ieee.std_logic_1164.all;

entity CONNECTION is
    generic (
        delay: time := 5 ns
    );
    port (
        I: in std_logic;
        O: out std_logic        
    );   
end CONNECTION;

architecture Behaviour of CONNECTION is
begin
    O <= transport I after delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
    generic (
        delay: time := 5 ns
    );
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end AND2;

architecture Behaviour of AND2 is
begin
    F <= A and B after delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity OR2 is
    generic (
        delay: time := 5 ns
    );
    port (
        A, B: in std_logic;
        F: out std_logic        
    );   
end OR2;

architecture Behaviour of OR2 is
begin
    F <= A or B after delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity INV is
    generic (
        delay: time := 5 ns
    );
    port (
        I: in std_logic;
        O: out std_logic        
    );   
end INV;

architecture Behaviour of INV is
begin
    O <= not I after delay;
end Behaviour;

library ieee;
use ieee.std_logic_1164.all;

entity task3 is
    port (
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(3 downto 0)
    );
end task3;

architecture rtl of task3 is
    component CONNECTION 
        generic (delay: time);
        Port (I: in std_logic; O: out std_logic);
    end component;
    component INV 
        generic (delay: time);
        Port (I: in std_logic; O: out std_logic);
    end component;
    component AND2 
        generic (delay: time);
        Port (A, B: in std_logic; F: out std_logic);
    end component;
    component OR2 
        generic (delay: time);
        Port (A, B: in std_logic; F: out std_logic);
    end component;
    signal G0, G1, G2, G3: std_logic;
    signal NOT_G0, NOT_G1, NOT_G2, NOT_G3: std_logic;
    signal G3_and_G2, G3_and_G0, G3_and_G1, L3_12, L3_RES: std_logic;  
    signal not_G3_and_G2, G3_and_not_G0, G3_not_G0_not_G1, L2_2, L2_RES: std_logic; 
    signal G1_and_G0, not_G3_and_G1, L1_12, L1_RES: std_logic;
    signal not_G3_and_G0, G3_G1_not_G0, L0_12, L0_RES: std_logic;
    constant component_delay: time := 5 ns;
    constant connection_delay: time := 5 ns;
begin
    G0 <= sw(0); G1 <= sw(1); G2 <= sw(2); G3 <= sw(3);

    
    INV_G0: INV generic map (delay => component_delay) port map (I => G0, O => NOT_G0);
    INV_G1: INV generic map (delay => component_delay) port map (I => G1, O => NOT_G1);
    INV_G2: INV generic map (delay => component_delay) port map (I => G2, O => NOT_G2);
    INV_G3: INV generic map (delay => component_delay) port map (I => G3, O => NOT_G3);
    
    --L3 
    AND2_G3_AND_G2: AND2 generic map (delay => component_delay) port map (A => G3, B => G2, F => G3_and_G2);
    AND2_G3_AND_G0: AND2 generic map (delay => component_delay) port map (A => G3, B => G0, F => G3_and_G0);
    AND2_G3_AND_G1: AND2 generic map (delay => component_delay) port map (A => G3, B => G1, F => G3_and_G1);
    OR2_L3_12: OR2 generic map (delay => component_delay) port map (A => G3_and_G2, B => G3_and_G0, F => L3_12); 
    OR2_L3_RES: OR2 generic map (delay => component_delay) port map (A => L3_12, B => G3_and_G1, F => L3_RES); 
    --CONNECTION_L3: CONNECTION generic map (delay => connection_delay) port map (I => L3_RES, O => led(3));
    led(3) <= L3_RES;  
    
    --L2
    AND2_NOT_G3_AND_G2: AND2 generic map (delay => component_delay) port map (A => NOT_G3, B => G2, F => not_G3_and_G2);
    AND2_G3_AND_NOT_G0: AND2 generic map (delay => component_delay) port map (A => G3, B => NOT_G0, F => G3_and_not_G0);
    AND2_G3_NOT_G0_NOT_G1: AND2 generic map (delay => component_delay) port map (A => G3_and_not_G0, B => NOT_G1, F => G3_not_G0_not_G1);
    AND2_L2_2: AND2 generic map (delay => component_delay) port map (A => G3_not_G0_not_G1, B => NOT_G2, F => L2_2);
    OR2_L2_RES: OR2 generic map (delay => component_delay) port map (A => L2_2, B => not_G3_and_G2, F => L2_RES); 
    led(2) <= L2_RES;
    
    --L1
    AND2_G1_AND_G0: AND2 generic map (delay => component_delay) port map (A => G1, B => G0, F => G1_and_G0);
    AND2_NOT_G3_AND_G1: AND2 generic map (delay => component_delay) port map (A => NOT_G3, B => G1, F => not_G3_and_G1);
    OR2_L1_12: OR2 generic map (delay => component_delay) port map (A => G1_and_G0, B => not_G3_and_G1, F => L1_12);
    OR2_L1_RES: OR2 generic map (delay => component_delay) port map (A => L1_12, B => G3_not_G0_not_G1, F => L1_RES); 
    --CONNECTION_L1: CONNECTION generic map (delay => connection_delay) port map (I => L1_RES, O => led(1));
    led(1) <= L1_RES;
    
    --L0
    AND2_NOT_G3_AND_G0: AND2 generic map (delay => component_delay) port map (A => NOT_G3, B => G0, F => not_G3_and_G0);
    AND2_G3_G1_NOT_G0: AND2 generic map (delay => component_delay) port map (A => G3_and_not_G0, B => G1, F => G3_G1_not_G0);
    OR2_L0_12: OR2 generic map (delay => component_delay) port map (A => G2, B => not_G3_and_G0, F => L0_12);
    OR2_L0_RES: OR2 generic map (delay => component_delay) port map (A => L0_12, B => G3_G1_not_G0, F => L0_RES);
    --CONNECTION_L0: CONNECTION generic map (delay => connection_delay) port map (I => L0_RES, O => led(0));
    led(0) <= L0_RES;
end rtl;



