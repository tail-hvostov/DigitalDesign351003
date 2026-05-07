----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2026 02:03:50
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task1Test is
--  Port ( );
end Task1Test;

architecture Behavioral of Task1Test is
    component Task1Machine is
        port(
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic_vector(3 downto 0)
        );
    end component;
    
    constant LOW_STATE : natural := 1;
    constant HIGH_STATE : natural := 9;

    signal cur_state : natural range LOW_STATE to HIGH_STATE;
    
    type letter_map is array (LOW_STATE to HIGH_STATE) of std_logic_vector(3 downto 0);
    constant state_letters : letter_map := (
        1 => X"A",
        2 => X"B",
        3 => X"E",
        4 => X"B",
        5 => X"F",
        6 => X"C",
        7 => X"F",
        8 => X"D",
        9 => X"A"
    );
    
    signal CLK : std_logic := '0';
    signal RST : std_logic;
    signal EN  : std_logic;
    signal Q   : std_logic_vector(3 downto 0);
begin
    CLK <= transport not CLK after 3 ns;

    process
        variable test_counter : natural;
        variable succeeded_tests : natural;
        variable had_errors : boolean;
    begin
        test_counter := 0;
        succeeded_tests := 0;
        
        report "Letter test.";
        RST <= '1';
        wait for 6 ns;
        had_errors := false;
        RST <= '0';
        EN <= '1';
        for i in state_letters'range loop
            if Q /= state_letters(i) then
                report "Invalid letter on step " & natural'image(i) & ".";
                had_errors := true;
            end if;
            wait for 6 ns;
        end loop;
        if not had_errors then
            succeeded_tests := succeeded_tests + 1;
        end if;
        test_counter := test_counter + 1;
        
        report "EN=0 test.";
        RST <= '1';
        wait for 6 ns;
        RST <= '0';
        EN <= '0';
        wait for 6 ns;
        had_errors := false;
        for i in state_letters'range loop
            if Q /= state_letters(state_letters'low) then
                report "Invalid letter on step " & natural'image(i) & ".";
                had_errors := true;
            end if;
            wait for 6 ns;
        end loop;
        if not had_errors then
            succeeded_tests := succeeded_tests + 1;
        end if;
        test_counter := test_counter + 1;
        
        report "RST test";
        RST <= '1';
        wait for 6 ns;
        RST <= '0';
        EN <= '1';
        wait for 6 * 3 ns;
        RST <= '1';
        wait for 6 ns;
        RST <= '0';
        test_counter := test_counter + 1;
        if Q = state_letters(state_letters'low) then
            had_errors := false;
            for i in state_letters'range loop
                if Q /= state_letters(i) then
                    report "Invalid letter on step " & natural'image(i) & ".";
                    had_errors := true;
                end if;
                wait for 6 ns;
            end loop;
            if not had_errors then
                succeeded_tests := succeeded_tests + 1;
            end if;
        else
            report "RST does not work properly.";
        end if;
        
        report natural'image(succeeded_tests) & " tests of " & natural'image(test_counter) & " succeeded.";
        wait;
    end process;
    
    U0 : Task1Machine
    port map(CLK => CLK, RST => RST, EN => EN, Q => Q);
end Behavioral;
