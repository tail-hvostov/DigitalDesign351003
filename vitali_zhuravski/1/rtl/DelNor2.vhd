library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.delayed_components.all;

entity DEL_NOR2 is
    generic (
        delay : time := NOR2_DELAY
    );
    port (
        I0 : in std_logic;
        I1 : in std_logic;
        O : out std_logic
    );
end DEL_NOR2;

architecture rtl of DEL_NOR2 is
begin
    O <= I1 nor I0 after delay;
end rtl;