library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task3_tb is
--  Port ( );
end task3_tb;

architecture Behavioral of task3_tb is
    component task3
    port (
        sw_i: in std_logic_vector(3 downto 0);
        led_o: out std_logic_vector(3 downto 0)
    );
    end component;
    
    signal G: std_logic_vector(3 downto 0);
    signal L: std_logic_vector(3 downto 0);
begin
    uut: task3 port map (sw_i => G, led_o => L);
    
    test_proc: process
    begin
        report "Start verification...";
        
-- N = 0, G = 0000, L = 0000
        G <= "0000";
        wait for 20 ns;
        assert L = "0000"
        report "Test 0000 failed. Expected value: 0000."
        severity error;
        
-- N = 1, G = 0010, L = 0001
        G <= "0010";
        wait for 20 ns;
        assert L = "0001"
        report "Test 0010 failed. Expected value: 0001."
        severity error;
        
-- N = 2, G = 0100, L = 0010
        G <= "0100";
        wait for 20 ns;
        assert L = "0010"
        report "Test 0100 failed. Expected value: 0010."
        severity error;
        
-- N = 3, G = 0110, L = 0100
        G <= "0110";
        wait for 20 ns;
        assert L = "0100"
        report "Test 0110 failed. Expected value: 0100."
        severity error;

-- N = 7, G = 1000, L = 1001
        G <= "1000";
        wait for 20 ns;
        assert L = "1001"
        report "Test 1000 failed. Expected value: 1001."
        severity error;

-- N = 8, G = 1010, L = 1010
        G <= "1010";
        wait for 20 ns;
        assert L = "1010"
        report "Test 1010 failed. Expected value: 1010."
        severity error;

-- N = 9, G = 1100, L = 1100
        G <= "1100";
        wait for 20 ns;
        assert L = "1100"
        report "Test 1100 failed. Expected value: 1100."
        severity error;
        
        report "Verification passed!";
        wait;        
     end process test_proc;
end Behavioral;
