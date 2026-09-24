library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;

entity three_bit_comporator_tb is
end three_bit_comporator_tb;

architecture Behavioral of three_bit_comporator_tb is
    component three_bit_comporator
        port (
            led : out std_logic_vector(15 downto 13);
            sw: in std_logic_vector(15 downto 10)
        );
     end component;

     signal input  : std_logic_vector(15 downto 10);
     signal output : std_logic_vector(15 downto 13);
     constant DELAY: time := 50 ns;

     type test_params is record
        a: std_logic_vector(2 downto 0);
        b: std_logic_vector(2 downto 0);
        exp_gt: std_logic;
        exp_eq: std_logic;
        exp_lt: std_logic;
     end record;

     constant TESTS_AMOUNT: integer := 5;
     type test_array is array (0 to TESTS_AMOUNT - 1) of test_params;
     constant TESTS: test_array := (
        (a => "000", b => "000", exp_gt => '0', exp_eq => '1', exp_lt => '0'),
        (a => "011", b => "010", exp_gt => '1', exp_eq => '0', exp_lt => '0'),
        (a => "000", b => "100", exp_gt => '0', exp_eq => '0', exp_lt => '1'),
        (a => "101", b => "101", exp_gt => '0', exp_eq => '1', exp_lt => '0'),
        (a => "010", b => "110", exp_gt => '0', exp_eq => '0', exp_lt => '1')
     );

begin
    COMP: three_bit_comporator port map (
        led => output,
        sw => input
    );

    test_proc: process
    begin
        report "Starting test bench...";

        for i in 0 to TESTS_AMOUNT - 1 loop
            input <= TESTS(i).a & TESTS(i).b;
            wait for DELAY;
            assert output(15) = TESTS(i).exp_gt
                report "GT error" severity error;
            assert output(14) = TESTS(i).exp_eq
                report "EQ error" severity error;
            assert output(13) = TESTS(i).exp_lt
                report "LT error" severity error;
        end loop;

        report "Testbench finished";
        wait;
    end process;
end Behavioral;
