library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity task4test is
end task4test;
architecture Behaviour of task4test is
    component task4 
        port (
            sw: in std_logic_vector(5 downto 0);
            led: out std_logic_vector(1 downto 0)
        );          
    end component;
    
    signal swtb: std_logic_vector(5 downto 0);
    signal ledtb: std_logic_vector(1 downto 0);
    
    signal A_sig: integer := 0;
    signal B_sig: integer := 0;
    
begin
    TASK4_TEST: task4 port map (sw => swtb, led => ledtb);
    process
        variable A: integer;
        variable B: integer;
    begin
        A := 0; B := 0;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "11" report "test 1 failed: A=0, B=0 should be equal" severity error;
        
        A := 1; B := 1;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "11" report "test 2 failed: A=1, B=1 should be equal" severity error;
        
        A := 7; B := 7;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "11" report "test 3 failed: A=7, B=7 should be equal" severity error;
        
        A := 1; B := 2;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "10" report "test 4 failed: A=1 should be less than B=2" severity error;
        
        A := 2; B := 1;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "01" report "test 5 failed: A=2 should be greater than B=1" severity error;
        
        A := 3; B := 5;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "10" report "test 6 failed: A=3 should be less than B=5" severity error;
        
        A := 5; B := 3;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "01" report "test 7 failed: A=5 should be greater than B=3" severity error;
        
        A := 0; B := 7;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "10" report "test 8 failed: A=0 should be less than B=7" severity error;
        
        A := 7; B := 0;
        A_sig <= A; B_sig <= B;
        swtb <= std_logic_vector(to_unsigned(A, 3)) & std_logic_vector(to_unsigned(B, 3));
        wait for 100 ns;
        assert ledtb = "01" report "test 9 failed: A=7 should be greater than B=0" severity error;
        
        report "tests passed" severity note;
        wait;
    end process;
    
end Behaviour;