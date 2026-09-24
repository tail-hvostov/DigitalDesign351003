library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1Top is
 port (
   sw_i : in std_logic_vector(1 downto 0);
   led_o : out std_logic_vector(1 downto 0)
 );
end entity;

architecture rtl of Task1Top is
component RSLatch
   port (S, R : in std_logic;
         Q, nQ : out std_logic);
end component;

begin
    DUT: RSLatch
        port map (
            S => sw_i(0),
            R => sw_i(1),
            Q => led_o(0),
            nQ => led_o(1)
   );
end rtl;