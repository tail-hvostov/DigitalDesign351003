library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP3_D is
    port (
        sw_i    : in    std_logic_vector(15 downto 0);  -- A = sw_i[2:0], B = sw_i[5:3]
        led_o   : out   std_logic_vector(15 downto 0)   -- E = led_o[2], G = led_o[1], L = led_o[0]
    );
end entity COMP3_D;

architecture Structural of COMP3_D is
    signal sA0, sA1, sA2                    : std_logic;
    signal sB0, sB1, sB2                    : std_logic;
    signal pE_00, pE_01, pE_10, pE_11, pE_2 : std_logic;
    signal pG_00, pG_01, pG_10, pG_11, pG_2 : std_logic;
    signal pL_00, pL_01, pL_10, pL_11, pL_2 : std_logic;
    
    component COMP1_D is
        port (
            A, B        : in    std_logic;
            pE, pG, pL  : in    std_logic;
            E, G, L     : out   std_logic
        );
     end component;
     
     component INTCON_D is
        generic (
             DELAY       : time  := 10 ns
        );
        port (
            X   : in    std_logic;
            Y   : out   std_logic
        );
     end component;
begin
    led_o(15 downto 3) <= (others => '0');
   
    sA0 <= transport sw_i(0) after 10 ns;
    sB0 <= transport sw_i(3) after 11 ns;
    
    sA1 <= transport sw_i(1) after 15 ns;
    sB1 <= transport sw_i(4) after 16 ns;
    
    sA2 <= transport sw_i(2) after 20 ns;
    sB2 <= transport sw_i(5) after 21 ns;
    
    COMP1_0: COMP1_D port map (
        A => sA0,
        B => sB0,
        pE => '0',
        pG => '0',
        pL => '0',
        E => pE_00,
        G => pG_00,
        L => pL_00
    );
    
    INTCON_0: INTCON_D port map (
        X => pE_00,
        Y => pE_01
    );
    
    INTCON_1: INTCON_D port map (
        X => pG_00,
        Y => pG_01
    );
    
    INTCON_2: INTCON_D port map (
        X => pL_00,
        Y => pL_01
    );

    COMP1_1: COMP1_D port map (
        A => sA1,
        B => sB1,
        pE => pE_01,
        pG => pG_01,
        pL => pL_01,
        E => pE_10,
        G => pG_10,
        L => pL_10
    );
    
    INTCON_3: INTCON_D port map (
        X => pE_10,
        Y => pE_11
    );
        
    INTCON_4: INTCON_D port map (
        X => pG_10,
        Y => pG_11
    );
        
    INTCON_5: INTCON_D port map (
        X => pL_10,
        Y => pL_11
    );
    
    COMP1_2: COMP1_D port map (
        A => sA2,
        B => sB2,
        pE => pE_11,
        pG => pG_11,
        pL => pL_11,
        E => pE_2,
        G => pG_2,
        L => pL_2
    );
  
    led_o(2) <= transport pE_2 after 7 ns;
    led_o(1) <= transport pG_2 after 7 ns;
    led_o(0) <= transport pL_2 after 7 ns;
end Structural;
