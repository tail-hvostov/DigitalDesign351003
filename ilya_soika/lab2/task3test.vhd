library ieee;
use ieee.std_logic_1164.all;

entity task3test is
end task3test;

architecture Behaviour of task3test is
    component top 
        port (sw: in std_logic_vector(3 downto 0); led_o: out std_logic_vector(3 downto 0));          
    end component;
    signal G: std_logic_vector(3 downto 0);
    signal L: std_logic_vector(3 downto 0);
begin
    TASK1_TEST: top port map (sw => G, led_o => L);
    
    process
    begin
        G <= "0011";
        wait for 30 ns;
        assert L = "0000" report "test 0011 failed (expected 0000)" severity error;
        
        G <= "0100";
        wait for 30 ns;
        assert L = "0001" report "test 0100 failed (expected 0001)" severity error;
        
        G <= "0101";
        wait for 30 ns;
        assert L = "0010" report "test 0101 failed (expected 0010)" severity error;
        
        G <= "0110";
        wait for 30 ns;
        assert L = "0100" report "test 0110 failed (expected 0100)" severity error;
        
        G <= "0111";
        wait for 30 ns;
        assert L = "0101" report "test 0111 failed (expected 0101)" severity error;
        
        G <= "1000";
        wait for 30 ns;
        assert L = "0110" report "test 1000 failed (expected 0110)" severity error;
        
        G <= "1001";
        wait for 30 ns;
        assert L = "1000" report "test 1001 failed (expected 1000)" severity error;
        
        G <= "1010";
        wait for 30 ns;
        assert L = "1001" report "test 1010 failed (expected 1001)" severity error;
        
        report "All tests passed!" severity note;
        wait;
    end process;
end Behaviour;