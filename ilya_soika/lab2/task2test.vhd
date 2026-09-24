library ieee;
use ieee.std_logic_1164.all;

entity task2test is
end task2test;

architecture Behaviour of task2test is
    component task1 
        port (sw: in std_logic_vector(3 downto 0); led: out std_logic_vector(3 downto 0));          
    end component;
    signal G: std_logic_vector(3 downto 0);
    signal L: std_logic_vector(3 downto 0);
begin
    TASK1_TEST: task1 port map (sw => G, led => L);
    
    process
    begin
        G <= "0000";
        wait for 10 ns;
        assert L = "0000" report "test 0000 failed" severity error;
        
        G <= "0001";
        wait for 10 ns;
        assert L = "0001" report "test 0001 failed" severity error;
        
        G <= "0010";
        wait for 10 ns;
        assert L = "0010" report "test 0010 failed" severity error;
        
        G <= "0011";
        wait for 10 ns;
        assert L = "0011" report "test 0000 failed" severity error;
        
        G <= "0100";
        wait for 10 ns;
        assert L = "0101" report "test 0100 failed" severity error;
        
        G <= "1000";
        wait for 10 ns;
        assert L = "0110" report "test 1000 failed" severity error;
        
        G <= "1001";
        wait for 10 ns;
        assert L = "1000" report "test 1001 failed" severity error;
        
        G <= "1010";
        wait for 10 ns;
        assert L = "1001" report "test 1010 failed" severity error;
        
        G <= "1011";
        wait for 10 ns;
        assert L = "1010" report "test 1011 failed" severity error;
        
        G <= "1100";
        wait for 10 ns;
        assert L = "1011" report "test 1100 failed" severity error;
        
        report "tests passed" severity note;
        wait;
    end process;
end Behaviour;