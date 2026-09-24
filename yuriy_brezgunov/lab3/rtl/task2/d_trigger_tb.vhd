library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task2_tb is
end task2_tb;

architecture Behavioral of task2_tb is
    component d_trigger
        port (
            sw  : in  std_logic_vector(15 downto 14);
            clk : in std_logic;
            led : out std_logic_vector(15 downto 15)
        );
    end component;
    
    signal D, CLK, CLR_N, exp_Q : std_logic;
    constant CLK_PERIOD : time := 20 ns;
begin
    COMP: d_trigger
    port map (
        led(15) => exp_Q,
        clk => CLK,
        sw(15) => D,
        sw(14) => CLR_N
    );
    
    CLK_proc : process
    begin
        while now < 80 ns loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    test_proc: process 
    begin
        report "Starting test bench";
        CLR_N <= '1';
        
        D <= '0';
        wait for CLK_PERIOD;
        assert (exp_Q = '0') 
            report "Test failed"
            severity error;
            
        wait for CLK_PERIOD/2 - 1 ns;
        D <= '1';
        assert (exp_Q = '0') 
            report "Test failed"
            severity error;
            
        wait for CLK_PERIOD/2;
        assert (exp_Q = '1') 
            report "Test failed"
            severity error;
            
        wait for CLK_PERIOD;
        assert (exp_Q = '1') 
            report "Test failed"
            severity error;
            
        wait for CLK_PERIOD/2;
        CLR_N <= '0';
        wait for 1 ns;
        assert (exp_Q = '0') 
            report "Test failed"
            severity error;
        
        report "Testbench finished";
        wait;
    end process;
end Behavioral;
