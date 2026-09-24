library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS_Latch_D_TB is
end RS_Latch_D_TB;

architecture Behavioral of RS_Latch_D_TB is
    constant T          :   time := 100 ns;
    
    signal R, S, Q, nQ  :   std_logic;
    
    component RS_Latch_D is
        port (
            R   : in    std_logic;
            S   : in    std_logic;
            Q   : out   std_logic;
            nQ  : out   std_logic
        );
    end component;
begin
    UUT: RS_Latch_D port map (
        R => R,
        S => S,
        Q => Q,
        nQ => nQ
    );
    
    Sim: process
    begin
        report "RS Latch simulation started" 
        severity note;
        
        R <= '0';
        S <= '1';
        wait for T;
        assert (Q = '1' and nQ = '0')
            report "RS Latch set mode simulation failed"
            severity error;
            
        R <= '1';
        S <= '0';
        wait for T;
        assert (Q = '0' and nQ = '1')
            report "RS Latch reset mode simulation failed"
            severity error;
            
        R <= '1';
        S <= '1';
        wait for T;
        assert (Q = '0' and nQ = '1')
            report "RS Latch store mode simulation failed"
            severity error;
            
        R <= '0';
        S <= '0';
        wait for T;
        assert (Q = '1' and nQ = '0')
            report "RS Latch undesirable mode simulation failed"
            severity error;
        
        R <= '1';
        S <= '1';
        wait for T;
        report "RS Latch forbidden transaction driven"
        severity note;
     
        report "RS Latch simulation finished" 
        severity note;
    end process Sim;
end Behavioral;