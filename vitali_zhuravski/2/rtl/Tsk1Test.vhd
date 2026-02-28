----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2026 01:08:50
-- Design Name: 
-- Module Name: Tsk1Test - Behavioral
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

entity tsk1_test is
--  Port ( );
end tsk1_test;

architecture Behavioral of tsk1_test is
    component tsk1_top
        port (
            led_out : out std_logic_vector(15 downto 0);
            sw_in : in std_logic_vector(15 downto 0)
        );
    end component;
    
    type test_array is array (0 to 15) of std_logic_vector(3 downto 0);
    
    constant test_cases : test_array := (
        0 => "0001",
        1 => "0010",
        2 => "0100",
        3 => "1000",
        others => (others => '0')
    );

    signal led_out : std_logic_vector(15 downto 0);
    signal sw_in : std_logic_vector(15 downto 0);
    
    signal A : std_logic;
    signal B : std_logic;
    signal C : std_logic;
    signal D : std_logic;
begin
    U1 : tsk1_top port map(led_out => led_out, sw_in => sw_in);
    
    A <= sw_in(3);
    B <= sw_in(2);
    C <= sw_in(1);
    D <= sw_in(0);
    
    process
        variable successful_tests : integer;
    begin
        successful_tests := 0;
        for i in 0 to 15 loop
            sw_in <= std_logic_vector(to_unsigned(i, 16));
            wait for 35 ns;
            if led_out(3 downto 0) = test_cases(i) then
                successful_tests := successful_tests + 1;
                report "Test " & integer'image(i) & " succeeded.";
            else
                report "Failed test " & integer'image(i) & ". Input=" &
                    integer'image(to_integer(unsigned(sw_in(3 downto 0)))) &
                    " Actual result=" & integer'image(to_integer(unsigned(led_out(3 downto 0)))) &
                    " Expected result=" & integer'image(to_integer(unsigned(test_cases(i))));
            end if;
        end loop;
        report integer'image(successful_tests) & " tests of 16 succeded.";
        wait;
    end process;
end Behavioral;
