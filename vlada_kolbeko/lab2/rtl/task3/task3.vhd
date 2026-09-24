library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIN_CODE_CONV_D is
    port (
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end MIN_CODE_CONV_D;

architecture Structural of MIN_CODE_CONV_D is
    signal sX3_0, sX3_1, sX3_2                      :   std_logic;
    signal sX4_0, sX4_1, sX4_2                      :   std_logic;
    signal snX3_0, snX3_1, snX4_0, snX4_1           :   std_logic;
    signal sY1, sY2, sY3                            :   std_logic;
    
    component INV_D is
        generic (
            IS_DELAYED  : boolean   := true;
            DELAY       : time      := 2 ns
        );
        port (
            X   : in    std_logic;
            Y   : out   std_logic
        );
    end component;
    
    component AND2_D is
        generic (
            IS_DELAYED  : boolean   := true;
            DELAY       : time      := 5 ns
        );
        port (
            X1, X2  : in    std_logic;
            Y       : out   std_logic
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
    
    sX3_0 <= transport sw_i(2) after 12 ns;
    sX3_1 <= transport sw_i(2) after 15 ns;
    sX3_2 <= transport sw_i(2) after 20 ns;
    
    sX4_0 <= transport sw_i(3) after 13 ns;
    sX4_1 <= transport sw_i(3) after 16 ns;
    sX4_2 <= transport sw_i(3) after 21 ns;          
   
    INV_D_0: INV_D port map (
        X => sX3_0,
        Y => snX3_0
    );
    
    INV_D_1: INV_D port map (
        X => sX4_0,
        Y => snX4_0
    );
    
    INTCON_snX3: INTCON_D 
    generic map (
        DELAY => 11 ns
    )
    port map (
        X => snX3_0,
        Y => snX3_1
    );
    
    INTCON_snX4: INTCON_D port map (
        X => snX4_0,
        Y => snX4_1
    );
    
    AND2_D_0: AND2_D port map (
        X1 => sX3_1,
        X2 => snX4_1,
        Y => sY1
    );
    
    AND2_D_1: AND2_D port map (
        X1 => snX3_1,
        X2 => sX4_1,
        Y => sY2
    );
        
    AND2_D_2: AND2_D port map (
        X1 => sX3_2,
        X2 => sX4_2,
        Y => sY3
    );
    
    led_o(0) <= transport sY1 after 10 ns;
    led_o(1) <= transport sY2 after 10 ns;
    led_o(2) <= transport sY3 after 10 ns;
end Structural;