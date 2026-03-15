library IEEE;
use ieee.std_logic_1164.all;

entity comparator_3bit is 
    port (
        sw_i  : in  std_logic_vector(5 downto 0);
        led_o : out std_logic_vector(2 downto 0)
    );
end comparator_3bit;

architecture Structural of comparator_3bit is

    component and2_delay
        generic (DELAY : time := 2 ns);
        port(a,b : in std_logic; y : out std_logic);
    end component;
    
    component or2_delay
        generic (DELAY : time := 2 ns);
        port(a,b : in std_logic; y : out std_logic);
    end component;
    
    component xnor2_delay
        generic (DELAY : time := 2 ns);
        port(a,b : in std_logic; y : out std_logic);
    end component;
    
    component not_delay
        generic (DELAY : time := 2 ns);
        port(a : in std_logic; y : out std_logic);
    end component;
    
    signal xnor_bits, gt_bits, lt_bits : std_logic_vector(2 downto 0);
    signal inversed : std_logic_vector(5 downto 0);
    
    signal and1, and2, and3, and4, and5, or1, or2 : std_logic;
    signal equals, less, greater : std_logic;

begin

    -- equals
    Eq: for i in 0 to 2 generate
        U1: xnor2_delay port map(sw_i(i), sw_i(i+3), xnor_bits(i));
    end generate;
    
    U2: and2_delay port map(xnor_bits(0), xnor_bits(1), and1);
    U3: and2_delay port map(and1, xnor_bits(2), equals);
    
    -- inversion
    INV: for i in 0 to 5 generate
        U4: not_delay port map(sw_i(i), inversed(i));
    end generate;
    
    -- greater
    GT: for i in 0 to 2 generate
        U5: and2_delay port map(sw_i(i), inversed(i+3), gt_bits(i));
    end generate;
    
    -- less
    LT: for i in 0 to 2 generate
        U6: and2_delay port map(sw_i(i+3), inversed(i), lt_bits(i));
    end generate;
    
    -- less cascade
    U7: and2_delay port map(lt_bits(0), xnor_bits(1), and2);
    U8: or2_delay  port map(lt_bits(1), and2, or1);
    U9: and2_delay port map(xnor_bits(2), or1, and3);
    U10: or2_delay port map(lt_bits(2), and3, less);
    
    -- greater cascade
    U11: and2_delay port map(gt_bits(0), xnor_bits(1), and4);
    U12: or2_delay  port map(gt_bits(1), and4, or2);
    U13: and2_delay port map(xnor_bits(2), or2, and5);
    U14: or2_delay  port map(gt_bits(2), and5, greater);
    
    led_o <= less & equals & greater;

end Structural;