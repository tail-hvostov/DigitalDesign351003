----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2026 23:42:02
-- Design Name: 
-- Module Name: Tsk4Test - Behavioral
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

entity tsk4_test is
--  Port ( );
end tsk4_test;

architecture Behavioral of tsk4_test is
    component tsk4_top
        port (
            led_out : out std_logic_vector(15 downto 0);
            sw_in : in std_logic_vector(15 downto 0)
        );
    end component;

    signal led_out : std_logic_vector(15 downto 0);
    signal sw_in : std_logic_vector(15 downto 0);
    
    signal input : std_logic_vector(7 downto 0);
    signal num1 : std_logic_vector(2 downto 0);
    signal num2 : std_logic_vector(2 downto 0);
    signal greater_in : std_logic;
    signal smaller_in : std_logic;
begin
    input <= sw_in(7 downto 0);
    num1 <= input(5 downto 3);
    num2 <= input(2 downto 0);
    greater_in <= input(7);
    smaller_in <= input(6);

    U1 : tsk4_top port map(led_out => led_out, sw_in => sw_in);
    process
        variable Ge : std_logic;
        variable Se : std_logic;
        variable successful_tests : integer;
    begin
        successful_tests := 0;
        for i in 0 to 191 loop
            sw_in <= std_logic_vector(to_unsigned(i, 16));
            wait for 55 ns;
            
            if greater_in = '1' then
                Ge := '1';
                Se := '0';
            elsif smaller_in = '1' then
                Ge := '0';
                Se := '1';
            elsif num1 > num2 then
                Ge := '1';
                Se := '0';
            elsif num1 < num2 then
                Ge := '0';
                Se := '1';
            else
                Ge := '0';
                Se := '0';
            end if;
            
            if (Ge = led_out(1)) and (Se = led_out(0)) then
                successful_tests := successful_tests + 1;
                report "Test " & integer'image(i) & " succeeded.";
            else
                report "Gi=" & std_logic'image(greater_in) &
                   " Si=" & std_logic'image(smaller_in) &
                   " N1=" & integer'image(to_integer(unsigned(num1))) &
                   " N2=" & integer'image(to_integer(unsigned(num2))) &
                   " => Go=" & std_logic'image(led_out(1)) &
                   " So=" & std_logic'image(led_out(0)) &
                   " Ge=" & std_logic'image(Ge) &
                   " Se=" & std_logic'image(Se);
            end if;
        end loop;
        report integer'image(successful_tests) & " tests of 192 succeded.";
        wait;
    end process;
end Behavioral;
