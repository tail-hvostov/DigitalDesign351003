library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP3 is
    generic (
        N : natural := 3 
    );
    port (
        sw_i    : in    std_logic_vector(15 downto 0);  -- A = sw_i[2:0], B = sw_i[5:3]
        led_o   : out   std_logic_vector(15 downto 0)   -- E = led_o[2], G = led_o[1], L = led_o[0]
    );
end entity COMP3;

architecture Structural of COMP3 is
    signal pE, pG, pL   :   std_logic_vector(0 to N);
    signal E, G, L      :   std_logic_vector(0 to N - 1);
    
    component COMP1 is
        port (
            A, B        : in    std_logic;
            pE, pG, pL  : in    std_logic;
            E, G, L     : out   std_logic
        );
     end component;
begin
    led_o(15 downto 3) <= (others => '0');
    
    pE(0) <= '0';
    pG(0) <= '0';
    pL(0) <= '0';
    
    COMP: for i in 0 to N - 1 generate
        COMP1_i: COMP1 port map (
            A => sw_i(i),
            B => sw_i(i + N),
            pE => pE(i),
            pL => pL(i),
            pG => pG(i),
            E => E(i),
            G => G(i),
            L => L(i)
        );
        
        pE(i + 1) <= E(i);
        pG(i + 1) <= G(i);
        pL(i + 1) <= L(i);        
    end generate;
    
    led_o(2) <= E(N - 1);
    led_o(1) <= G(N - 1);
    led_o(0) <= L(N - 1);
end Structural;