library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity freq_div_behav_TB is
end freq_div_behav_TB;

architecture Behavioral of freq_div_behav_TB is
    constant K1 : natural   := 4;
    constant K2 : natural   := 10;
    constant K3 : natural   := 100;
    
    constant T  : time      := 10 ns;
    
    signal CLK, RST, EN     :   std_logic;
    signal Q1, Q2, Q3       :   std_logic;
        
    component freq_div_behav is
        generic (
            K   : natural   := 10
        );
        port (
            CLK : in    std_logic;
            RST : in    std_logic;
            EN  : in    std_logic;
            Q   : out   std_logic
        );
    end component;
begin
    UUT_0: freq_div_behav
    generic map (
        K => K1
    )
    port map (
        CLK => CLK,
        RST => RST,
        EN  => EN,
        Q   => Q1
    );
    
    UUT_1: freq_div_behav
    generic map (
        K => K2
    )
    port map (
        CLK => CLK,
        RST => RST,
        EN  => EN,
        Q   => Q2
    );
    
    UUT_2: freq_div_behav
    generic map (
        K => K3
    )
    port map (
        CLK => CLK,
        RST => RST,
        EN  => EN,
        Q   => Q3
    );
    
    ClkGen: process
    begin
        CLK <= '0';
        wait for (T / 2);
        
        CLK <= '1';
        wait for (T / 2);
    end process ClkGen;
    
    Sim: process
    begin
        report "freq_div_behav simulation started" 
        severity note;
            
        RST <= '1';
        EN  <= '0';
            
        wait for 2*T;
        assert (Q1 = '0' and Q2 = '0' and Q3 = '0')
            report "initial reset failed" 
            severity error;
            
        RST <= '0';
        EN  <= '1';
            
        wait for 2*T;
        assert (Q1 = '1') 
            report "Q1 (K = 4) failed to toggle to '1'" 
            severity error;
            
        wait for 2*T;
        assert (Q1 = '0') 
            report "Q1 (K = 4) failed to toggle back to '0'" 
            severity error;
    
        wait for T; 
        assert (Q2 = '1') 
            report "Q2 (K = 10) failed to toggle" 
            severity error;
    
        wait for 200*T; 
    
        EN <= '0';
            
        wait for 10*T;
          
        EN <= '1';
        wait for 5*T;
             
        RST <= '1';
        wait for T;
            
        assert (Q1 = '0' and Q2 = '0' and Q3 = '0')
            report "reset during operation failed" 
            severity error;
    
        report "freq_div_behav simulation finished" 
        severity note;            
            
        wait;
    end process Sim;
end Behavioral;