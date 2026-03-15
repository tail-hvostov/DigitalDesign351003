library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task6 is
    Port (
        sw  : in  std_logic_vector(1 downto 0);
        led : out std_logic_vector(1 downto 0)
    );
end Task6;

architecture Behavioral of Task6 is
    signal q  : std_logic := '0';  
    signal nq : std_logic := '1';
        attribute dont_touch : string;
    attribute dont_touch of q  : signal is "true";
    attribute dont_touch of nq : signal is "true";
    
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of q  : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of nq : signal is "TRUE";
    
begin
    q  <= not (sw(0) and nq);
    nq <= not (sw(1) and q);
    
    led(0) <= q;
    led(1) <= nq;
    
end Behavioral;