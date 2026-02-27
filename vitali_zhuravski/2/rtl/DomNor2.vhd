library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.domestic_components.all;

entity DOM_NOR2 is
    port (
        I0 : in std_logic;
        I1 : in std_logic;
        O : out std_logic
    );
end DOM_NOR2;

architecture rtl of DOM_NOR2 is
begin
    O <= I1 nor I0;
end rtl;