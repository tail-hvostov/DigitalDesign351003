library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;

entity task3_tb is
end task3_tb;

architecture Behavioral of task3_tb is
    component task3 
        port (
            led: out std_logic_vector(15 downto 10);
            sw: in std_logic_vector(15 downto 12)
        );
     end component;
     signal input: std_logic_vector(15 downto 12);
     signal output: std_logic_vector(15 downto 10);
     constant DELAY: time := 50 ns;
     
     type test_params is record 
        inp: std_logic_vector(3 downto 0);
        exp: std_logic_vector(5 downto 0);
     end record;
     
     constant TESTS_AMOUNT: integer := 10;
     type test_array is array (0 to TESTS_AMOUNT - 1) of test_params;
     constant TESTS: test_array := (
        (inp => "0000", exp => "000000"),
        (inp => "0001", exp => "000101"),
        (inp => "0010", exp => "001001"),
        (inp => "0011", exp => "001110"),
        (inp => "0100", exp => "010001"),
        (inp => "0101", exp => "010110"),
        (inp => "0110", exp => "011010"),
        (inp => "1000", exp => "100001"),
        (inp => "1001", exp => "100110"),
        (inp => "1010", exp => "101010")
     );
    
begin
    COMP: task3 port map (
        led => output,  
        sw => input  
    );
    
    test_proc: process 
    begin
        report "Starting test bench...";
        
        for i in 0 to TESTS_AMOUNT - 1 loop 
            input <= TESTS(i).inp; 
            wait for DELAY;
            assert (output = TESTS(i).exp)
                report "Error occured!"
                severity error;
        end loop;
        
        report "Testbench finished";
        wait;
    end process;
end Behavioral;
