library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        sw  : in  std_logic_vector(15 downto 0);
        led     : out std_logic_vector(2 downto 0)
    );
end entity;

architecture struct of comparator is
    component cmpnbit
    generic (NUM_BITS : integer);
    port (
        num_a, num_b : in  std_logic_vector(NUM_BITS-1 downto 0);
        a_greater, a_equal, a_less : out std_logic
    );
end component;
    
    signal first_num, second_num : std_logic_vector(2 downto 0);
    
begin
    first_num  <= sw (5 downto 3);
    second_num <= sw (2 downto 0);
    
    comparator_3bit : cmpnbit
        generic map (NUM_BITS => 3)
        port map (
            num_a     => first_num,
            num_b     => second_num,
            a_greater => led(2),
            a_equal   => led(1),
            a_less    => led(0)
        );
end architecture;