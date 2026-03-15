library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestBench is
end TestBench;

architecture Behaviour of TestBench is
    component Task1 
        port (sw: in std_logic_vector(3 downto 0); led: out std_logic_vector(3 downto 0));          
    end component;
    
    signal G: std_logic_vector(3 downto 0);
    signal L: std_logic_vector(3 downto 0);
    
begin
    TASK1_TEST: Task1 port map (sw => G, led => L);
    
    process
    begin
        G <= "0000";
        wait for 10 ns;
        assert L = "0000" report "0000 failed" severity error;
        
        G <= "0001";
        wait for 10 ns;
        assert L = "0001" report "0001 failed" severity error;
        
        G <= "0010";
        wait for 10 ns;
        assert L = "0010" report "0010 failed" severity error;
        
        G <= "0011";
        wait for 10 ns;
        assert L = "0011" report "0011 failed" severity error;
        
        G <= "0100";
        wait for 10 ns;
        assert L = "0100" report "0100 failed" severity error;
        
        G <= "0101";
        wait for 10 ns;
        assert L = "0101" report "0101 failed" severity error;
        
        G <= "0110";
        wait for 10 ns;
        assert L = "0110" report "0110 failed" severity error;
        
        G <= "0111";
        wait for 10 ns;
        assert L = "0111" report "0111 failed" severity error;
        
        G <= "1000";
        wait for 10 ns;
        assert L = "1011" report "1000 failed" severity error;
        
        G <= "1001";
        wait for 10 ns;
        assert L = "1100" report "1001 failed" severity error;
        
        G <= "1010";
        wait for 10 ns;
        assert L = "1101" report "1010 failed" severity error;
        
        G <= "1011";
        wait for 10 ns;
        assert L = "1110" report "1011 failed" severity error;
        
        G <= "1100";
        wait for 10 ns;
        assert L = "1111" report "1100 failed" severity error;
        
        G <= "1101";
        wait for 10 ns;
        assert L = "1111" report "1101 failed" severity error;
        
        G <= "1110";
        wait for 10 ns;
        assert L = "1111" report "1110 failed" severity error;
        
        G <= "1111";
        wait for 10 ns;
        assert L = "1111" report "1111 failed" severity error;
        
        report "All tests passed" severity note;
        wait;
    end process;
    
end Behaviour;