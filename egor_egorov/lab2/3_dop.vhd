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