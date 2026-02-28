library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.delayed_components.all;

entity DEL_AND2 is
    generic (
        delay : time := AND2_DELAY
    );
    port (
        I0 : in std_logic;
        I1 : in std_logic;
        O : out std_logic
    );
end DEL_AND2;

architecture rtl of DEL_AND2 is
begin
    O <= I1 and I0 after delay;
end rtl;