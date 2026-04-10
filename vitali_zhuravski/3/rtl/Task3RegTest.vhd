----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 23:17:42
-- Design Name: 
-- Module Name: Task3RegTest - Behavioral
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

entity Task3RegTest is
--  Port ( );
end Task3RegTest;

architecture Behavioral of Task3RegTest is

    component RegUnit is
        generic(
            N : natural := 34
        );
        port(
            CLK    : in  std_logic;
            RST    : in  std_logic;
            EN     : in  std_logic;
            Din    : in  std_logic_vector(N-1 downto 0);
            Dout   : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    signal CLK    : std_logic;
    signal RST    : std_logic;
    signal EN     : std_logic;
    signal Din    : std_logic_vector(7 downto 0);
    signal Dout   : std_logic_vector(7 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
begin
    process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    U0 : RegUnit
    generic map(N => 8)
    port map(
        CLK  => CLK,
        RST  => RST,
        EN   => EN,
        Din  => Din,
        Dout => Dout
    );
    
    process
        variable successful_tests : integer;
        variable test_count : integer;
    begin
        test_count := 0;
        successful_tests := 0;
    
        report "Initialization";
        RST <= '0';
        EN <= '0';
        Din <= (others => '0');
        report "Initialization ended.";
        
        test_count := test_count + 1;
        RST <= '1';
        wait for CLK_PERIOD;
        RST <= '0';
        wait for CLK_PERIOD;
        
        if Dout = x"00" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Reset): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Reset): FAILED - Expected: 0, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        test_count := test_count + 1;
        Din <= x"AB";
        EN <= '1';
        wait for CLK_PERIOD;
        EN <= '0';
        wait for CLK_PERIOD;
        
        if Dout = x"AB" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Write xAB): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Write xAB): FAILED - Expected: 171, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        test_count := test_count + 1;
        Din <= x"CD";
        wait for CLK_PERIOD;
        
        if Dout = x"AB" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Hold mode): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Hold mode): FAILED - Expected: 171, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        test_count := test_count + 1;
        EN <= '1';
        wait for CLK_PERIOD;
        EN <= '0';
        wait for CLK_PERIOD;
        
        if Dout = x"CD" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Write xCD): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Write xCD): FAILED - Expected: 205, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        test_count := test_count + 1;
        RST <= '1';
        wait for CLK_PERIOD;
        RST <= '0';
        wait for CLK_PERIOD;
        
        if Dout = x"00" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Synchronous reset): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Synchronous reset): FAILED - Expected: 0, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        test_count := test_count + 1;
        Din <= x"EF";
        EN <= '1';
        wait for CLK_PERIOD;
        EN <= '0';
        wait for CLK_PERIOD;
        
        if Dout = x"EF" then
            successful_tests := successful_tests + 1;
            report "Test " & integer'image(test_count) & " (Write xEF after reset): PASSED";
        else
            report "Test " & integer'image(test_count) & " (Write xEF after reset): FAILED - Expected: 239, Got: " & integer'image(to_integer(unsigned(Dout)));
        end if;
        
        report integer'image(successful_tests) & " tests of " & integer'image(test_count) & " passed.";
    wait;
    end process;

end Behavioral;
