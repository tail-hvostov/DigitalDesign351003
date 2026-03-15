library IEEE;
use ieee.std_logic_1164.all;

entity bistable_element is
    port(
        led_o : out std_logic_vector(1 downto 0)  
    );
end bistable_element;

architecture rtl of bistable_element is

signal Q : std_logic := '0';
signal not_Q : std_logic := '1';

attribute KEEP : string;
attribute KEEP of Q : signal is "TRUE";
attribute KEEP of not_Q : signal is "TRUE";

begin

    Q     <= not not_Q;
    not_Q <= not Q;

    led_o(0) <= Q;
    led_o(1) <= not_Q;

end rtl;