----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 11:53:32
-- Design Name: 
-- Module Name: Task2Test - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task2Test is
--  Port ( );
end Task2Test;

architecture Behavioral of Task2Test is

    component DomFDCE is
        port(
            CLK : in std_logic;
            D : in std_logic;
            CLR_N : in std_logic;
            Q : out std_logic
        );
    end component;
    
    -- 2 - CLK, 1 - D, 0 - CLR_N
    type input_array is array (0 to 7) of std_logic_vector(2 downto 0);
    type output_array is array (0 to 7) of std_logic;
    
    constant test_cases : input_array := (
        0 => "100",
        1 => "001",
        2 => "101",
        3 => "111",
        4 => "011",
        5 => "000",
        6 => "010",
        7 => "110",
        others => (others => '0')
    );
    
    constant test_results : output_array := (
        0 => '0',
        1 => '0',
        2 => '0',
        3 => '1',
        4 => '1',
        5 => '0',
        6 => '0',
        7 => '0'
    );
    
    signal CLK : std_logic;
    signal D : std_logic;
    signal CLR_N : std_logic;
    signal Q : std_logic;

begin
    U0 : DomFDCE port map(CLK => CLK, D => D, CLR_N => CLR_N, Q => Q);

    process
        variable successful_tests : integer;
    begin
        successful_tests := 0;
        
        for i in test_cases'low to test_cases'high loop
            CLK <= test_cases(i)(2);
            D <= test_cases(i)(1);
            CLR_N <= test_cases(i)(0);
            wait for 10ns;
            if Q = test_results(i) then
                successful_tests := successful_tests + 1;
                report "Test with (CLK, D, CLR_N)=" &  integer'image(to_integer(unsigned(test_cases(i)))) & " succeeded.";
            else
                report "Failed test with (CLK, D, CLR_N)=" & integer'image(to_integer(unsigned(test_cases(i)))) &
                       " Actual result=" & std_logic'image(Q) &
                       " Expected result=" & std_logic'image(test_results(i));
            end if;
            CLK <= '0';
            wait for 5ns;
        end loop;
        
        report integer'image(successful_tests) & " tests of " & integer'image(test_cases'length) & " succeded.";
        wait;
    end process;

end Behavioral;
