library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.domestic_components.all;

entity DOM_INV is
    port (
        I : in std_logic;
        O : out std_logic
    );
end DOM_INV;

architecture rtl of DOM_INV is
begin
    O <= not I;
end rtl;