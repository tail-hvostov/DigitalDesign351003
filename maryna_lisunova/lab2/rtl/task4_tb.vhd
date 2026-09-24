library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task4_tb is
--  Port ( );
end task4_tb;

architecture Behavioral of task4_tb is
    component task4
    port (
        sw_i: in std_logic_vector(5 downto 0);
        led_o: out std_logic_vector(2 downto 0)
    );
    end component;
    
    signal sw_internal: std_logic_vector(5 downto 0) := (others => '0');
    signal led_internal: std_logic_vector(2 downto 0);
        
    signal A, B: std_logic_vector(2 downto 0);
    signal GLE: std_logic_vector(2 downto 0);
begin
    uut: task4 port map (
        sw_i => sw_internal,
        led_o => led_internal
    );
    
    sw_internal(5 downto 3) <= A;
    sw_internal(2 downto 0) <= B;
    GLE <= led_internal;
    
    test_proc: process
        begin
            report "Start verification...";
            
    -- A = 0, B = 0, A = B, GLE = 001
            A <= "000";
            B <= "000";
            wait for 30 ns;
            assert GLE = "001"
            report "Test A = 0, B = 0 failed. Expected value: 001 (A = B)."
            severity error;
            
    -- A = 1, B = 0, A > B, GLE = 100
            A <= "001";
            B <= "000";
            wait for 30 ns;
            assert GLE = "100"
            report "Test A = 1, B = 0 failed. Expected value: 100 (A > B)."
            severity error;
            
    -- A = 2, B = 0, A > B, GLE = 100
    
            A <= "010";
            B <= "000";
            wait for 30 ns;
            assert GLE = "100"
            report "Test A = 2, B = 0 failed. Expected value: 100 (A > B)."
            severity error;
    
    -- A = 0, B = 1, A < B, GLE = 010
    
            A <= "000";
            B <= "001";
            wait for 30 ns;
            assert GLE = "010"
            report "Test A = 0, B = 1 failed. Expected value: 010 (A < B)."
            severity error; 
            
    -- A = 1, B = 1, A = B, GLE = 001
    
            A <= "001";
            B <= "001";
            wait for 30 ns;
            assert GLE = "001"
            report "Test A = 1, B = 1 failed. Expected value: 001 (A = B)."
            severity error; 
    
    -- A = 7, B = 7, A = B, GLE = 001
    
            A <= "111";
            B <= "111";
            wait for 30 ns;
            assert GLE = "001"
            report "Test A = 7, B = 7 failed. Expected value: 001 (A = B)."
            severity error;
    
    -- A = 4, B = 3, A > B, GLE = 100
    
            A <= "100";
            B <= "011";
            wait for 30 ns;
            assert GLE = "100"
            report "Test A = 4, B = 3 failed. Expected value: 100 (A > B)."
            severity error;
    
    -- A = 2, B = 5, A < B, GLE = 010
    
            A <= "010";
            B <= "101";
            wait for 30 ns;
            assert GLE = "010"
            report "Test A = 2, B = 5 failed. Expected value: 010 (A < B)."
            severity error;
            
            report "Verification passed!";
            wait;        
         end process test_proc;

end Behavioral;
