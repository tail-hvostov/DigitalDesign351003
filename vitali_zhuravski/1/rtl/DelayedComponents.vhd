library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package delayed_components is
    constant INV_DELAY : time := 1 ns;
    constant NOR2_DELAY : time := 5 ns;
    constant AND2_DELAY : time := 10 ns;
    constant WIRE_DELAY : time := 300 ps;
    constant OR2_DELAY : time := 5 ns;
    
    component DEL_INV is
        generic (
            delay : time := INV_DELAY
        );
        port (
            I : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DEL_NOR2 is
        generic (
            delay : time := NOR2_DELAY
        );
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DEL_AND2 is
        generic (
            delay : time := AND2_DELAY
        );
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DEL_WIRE is
        generic (
            delay : time := WIRE_DELAY
        );
        port (
            I : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DEL_OR2 is
        generic (
            delay : time := OR2_DELAY
        );
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
end delayed_components;