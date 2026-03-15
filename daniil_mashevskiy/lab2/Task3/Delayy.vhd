library ieee;
use ieee.std_logic_1164.all;

package Delayy is
    constant INV_DELAY  : time := 0.5 ns;
    constant AND2_DELAY : time := 0.8 ns;
    constant OR2_DELAY  : time := 0.8 ns;
    constant NAND2_DELAY: time := 0.7 ns;
    constant NOR2_DELAY : time := 0.7 ns;
    constant XOR2_DELAY : time := 1.0 ns;
    
    component wire_delay
        generic (
            DELAY : time := 0.2 ns
        );
        port (
            input : in std_logic;
            output : out std_logic
        );
    end component;
    
end Delayy;