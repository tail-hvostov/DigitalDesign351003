library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF_TB is
end DFF_TB;

architecture Behavioral of DFF_TB is
    constant T              :   time := 20 ns;
    
    signal D, CLK, CLR_N, Q :   std_logic;
    
    component DFF is
        port (
            D       : in    std_logic;
            CLK     : in    std_logic;
            CLR_N   : in    std_logic;
            Q       : out   std_logic
        );
    end component;
begin
    UUT: DFF port map (
        D       => D,
        CLK     => CLK,
        CLR_N   => CLR_N,
        Q       => Q
    );
    
    ClkGen: process
    begin
        CLK <= '0';
        wait for T / 2;
        
        CLK <= '1';
        wait for T / 2;
    end process ClkGen;
    
    Sim: process
    begin
        report "DFF simulation started" 
        severity note;
        
        CLR_N <= '0';
        D     <= '1';
        wait for T;
        assert (Q = '0')
            report "DFF async reset failed"
            severity error;
            
        CLR_N <= '1';
        wait for T;
            
        D <= '1';
        wait for T;
        assert (Q = '1')
            report "DFF write '1' failed"
            severity error;
            
        wait for T;
        assert (Q = '1')
            report "DFF store '1' failed"
            severity error;
            
        D <= '0';
        wait for T;
        assert (Q = '0')
            report "DFF write '0' failed"
            severity error;
            
        wait for T;
        assert (Q = '0')
            report "DFF store '0' failed"
            severity error;
            
        D <= '1';
        wait for T; 
        assert (Q = '1')
            report "DFF setup for async check failed"
            severity error;
        
        wait for T / 4;
        CLR_N <= '0';
        wait for T / 4;
        assert (Q = '0')
            report "DFF async reset failed"
            severity error;
     
        report "DFF simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;