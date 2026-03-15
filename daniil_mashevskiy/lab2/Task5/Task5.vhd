library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5 is
    Port (
        led : out std_logic_vector(15 downto 0)  
    );
end Task5;

architecture Behavioral of Task5 is
    type signal_array is array (0 to 15) of std_logic;
    signal a, b : signal_array;
    
    attribute dont_touch : string;
    attribute dont_touch of a : signal is "true";
    attribute dont_touch of b : signal is "true";
    
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of a : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of b : signal is "TRUE";
    
begin
    gen_loops: for i in 0 to 15 generate
    begin
        a(i) <= not b(i);
        b(i) <= not a(i);
        
        led(i) <= a(i);
    end generate;
    
end Behavioral;