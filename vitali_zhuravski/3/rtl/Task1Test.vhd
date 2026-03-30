----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 01:31:57
-- Design Name: 
-- Module Name: Task1Test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task1Test is
--  Port ( );
end Task1Test;

architecture Behavioral of Task1Test is
    component Task1Top
        port (
            led_out : out std_logic_vector(15 downto 0);
            sw_in : in std_logic_vector(15 downto 0)
        );
    end component;
    
    type test_array is array (0 to 4) of std_logic_vector(1 downto 0);
        
    constant test_cases : test_array := (
        0 => "10",
        1 => "11",
        2 => "01",
        3 => "11",
        4 => "00",
        others => (others => '0')
    );
    
    constant test_results : test_array := (
        0 => "01",
        1 => "01",
        2 => "10",
        3 => "10",
        4 => "11",
        others => (others => '0')
    );
    
    signal led_out : std_logic_vector(15 downto 0);
    signal sw_in : std_logic_vector(15 downto 0);
begin
    U1 : Task1Top port map(led_out => led_out, sw_in => sw_in);
    
    process
        variable successful_tests : integer;
    begin
        successful_tests := 0;
        sw_in <= (others => '1');
        
        for i in test_array'low to test_array'high loop
            sw_in(1 downto 0) <= test_cases(i);
            wait for 20 ns;
            if led_out(1 downto 0) = test_results(i) then
                successful_tests := successful_tests + 1;
                report "Test with RS=" &  integer'image(to_integer(unsigned(test_cases(i)))) & " succeeded.";
            else
                report "Failed test with RS=" & integer'image(to_integer(unsigned(test_cases(i)))) &
                    " Actual result=" & integer'image(to_integer(unsigned(led_out(1 downto 0)))) &
                    " Expected result=" & integer'image(to_integer(unsigned(test_results(i))));
            end if;
        end loop;
        
        report integer'image(successful_tests) & " tests of 5 succeded.";
        sw_in(1 downto 0) <= "11";
        wait;
    end process;

end Behavioral;
