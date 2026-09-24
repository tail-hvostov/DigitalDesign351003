library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1_tb is
end task1_tb;

architecture Behavioral of task1_tb is
    component task1
        port (
            sw  : in  std_logic_vector(15 downto 14); -- sw(15)= R, sw(14)= S
            led : out std_logic_vector(15 downto 14)  -- led(15) = q, led(14) = nq
        );
    end component;
    
    signal sw : std_logic_vector(15 downto 14);
    signal exp_led : std_logic_vector(15 downto 14);
begin
    COMP: task1 port map (
        led => exp_led,  
        sw => sw  
    );

    test_proc: process 
    begin
        report "Starting test bench";
        
        sw <= "11";
        wait for 20 ns;
        
        sw <= "10"; -- R
        wait for 20 ns;
        assert (exp_led = "01") 
            report "Test failed"
            severity error;
        
        sw <= "11";
        wait for 20 ns;
        assert (exp_led = "01") 
            report "Test failed"
            severity error;
            
        sw <= "01"; -- S
        wait for 20 ns;
        assert (exp_led = "10") 
            report "Test failed"
            severity error;
        
        sw <= "11";
        wait for 20 ns;
        assert (exp_led = "10") 
            report "Test failed"
            severity error;
            
        sw <= "00";
        wait for 20 ns;
        
        sw <= "11";
        wait for 20 ns;
        
        report "Testbench finished";
        wait;
    end process;
end Behavioral;
