library ieee;
use ieee.std_logic_1164.all;

-- Task 4
-- F - function of 4 variables
-- F = 2FBC (16)
-- X1-4 correspond to sw_i[3:0]
-- F correspond to led_o[0]

entity comb_unit is
    port (
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end comb_unit;

architecture structural of comb_unit is
    signal nX1, nX2, nX3, nX4       :   std_logic;
    signal mt1, mt2, mt3, mt4, mt5  :   std_logic;      -- mt stands for "minimal term"
    
    component INV
        port (
            X   : in    std_logic;
            Y   : out   std_logic
        );
    end component; 
    
    component AND2
        port (
            X1, X2  : in    std_logic;
            Y       : out   std_logic
        );
    end component;
    
    component AND3
        port (
            X1, X2, X3  : in    std_logic;
            Y           : out   std_logic
        );
    end component;
    
    component OR5
        port (
            X1, X2, X3, X4, X5  : in    std_logic;
            Y                   : out   std_logic
        );
    end component;
    
begin
    INV0    : INV   port map (
        X => sw_i(0), 
        Y => nX1
    );
    INV1    : INV   port map (
        X => sw_i(1), 
        Y => nX2
    );
    INV2    : INV   port map (
        X => sw_i(2), 
        Y => nX3
    );
    INV3    : INV   port map (
        X => sw_i(3), 
        Y => nX4
    );
    
    AND2_0  : AND2  port map (
        X1 => nX2, 
        X2 => sw_i(2), 
        Y => mt1
    );
    AND2_1  : AND2  port map (
        X1 => sw_i(2), 
        X2 => nX4, 
        Y => mt2
    );
    AND3_0  : AND3  port map (
        X1 => sw_i(1),
        X2 => nX3, 
        X3 => sw_i(3), 
        Y => mt3
    );
    AND3_1  : AND3  port map (
        X1 => nX1, 
        X2 => nX3, 
        X3 => sw_i(3), 
        Y => mt4
    );
    AND3_2  : AND3  port map (
        X1 => nX1, 
        X2 => sw_i(1), 
        X3 => nX3, 
        Y => mt5
    );
    
    OR5_0   : OR5   port map (
        X1 => mt1, 
        X2 => mt2, 
        X3 => mt3, 
        X4 => mt4, 
        X5 => mt5, 
        Y => led_o(0)
    ); 
    
    led_o(15 downto 1) <= (others => '0');
end structural;