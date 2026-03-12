library IEEE;
use ieee.std_logic_1164.all;

entity bistable_ctrl is
port(
sw_i  : in  std_logic_vector(2 downto 0);  -- sw_i(0)=S, sw_i(1)=R, sw_i(2)=rd
led_o : out std_logic_vector(1 downto 0)   -- led_o(0)=Q, led_o(1)=not_Q
);
end bistable_ctrl;

architecture rtl of bistable_ctrl is

signal Q     : std_logic := '0';
signal not_Q : std_logic := '1';

attribute KEEP : string;
attribute KEEP of Q : signal is "TRUE";
attribute KEEP of not_Q : signal is "TRUE";

begin

Q     <= not (not_Q or sw_i(1));   -- R
not_Q <= not (Q or sw_i(0));       -- S

led_o(0) <= Q and sw_i(2);
led_o(1) <= not_Q and sw_i(2);

end rtl;
