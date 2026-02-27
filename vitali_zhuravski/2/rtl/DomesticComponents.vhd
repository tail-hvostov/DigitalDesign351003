library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package domestic_components is
    component DOM_INV is
        port (
            I : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DOM_NOR2 is
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DOM_AND2 is
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DOM_WIRE is
        port (
            I : in std_logic;
            O : out std_logic
        );
    end component;
    
    component DOM_OR2 is
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            O : out std_logic
        );
    end component;
end domestic_components;