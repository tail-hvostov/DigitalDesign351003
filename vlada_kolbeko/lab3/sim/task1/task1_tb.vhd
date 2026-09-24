library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rs_latch_TB is
end rs_latch_TB;

architecture Behavioral of rs_latch_TB is
    constant T          :   time := 100 ns;
    
    signal R, S, Q, nQ  :   std_logic;
    
    component RS_Latch is
        port (
            R   : in    std_logic;
            S   : in    std_logic;
            Q   : out   std_logic;
            nQ  : out   std_logic
        );
    end component;
begin
    UUT: RS_Latch port map (
        R   => R,
        S   => S,
        Q   => Q,
        nQ  => nQ
    );
    
    Sim: process
    begin
        report "rs_latch simulation started" 
        severity note;
        
        R <= '0';
        S <= '1';
        wait for T;
        assert (Q = '1' and nQ = '0')
            report "set mode simulation failed"
            severity error;
            
        R <= '1';
        S <= '0';
        wait for T;
        assert (Q = '0' and nQ = '1')
            report "reset mode simulation failed"
            severity error;
            
        R <= '1';
        S <= '1';
        wait for T;
        assert (Q = '0' and nQ = '1')
            report "store mode simulation failed"
            severity error;
            
        R <= '0';
        S <= '0';
        wait for T;
        assert (Q = '1' and nQ = '1')
            report "undesirable mode simulation failed"
            severity error;
        
        R <= '1';
        S <= '1';
        wait for T;
        report "forbidden transaction driven"
        severity note;
     
        report "rs_latch simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;