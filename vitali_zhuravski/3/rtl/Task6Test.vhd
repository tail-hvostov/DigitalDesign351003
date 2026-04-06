----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2026 13:04:11
-- Design Name: 
-- Module Name: Task6Test - Behavioral
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

entity Task6Test is
--  Port ( );
end Task6Test;

architecture Behavioral of Task6Test is
    constant CNT_WIDTH : natural := 4;
    constant ALL_CLOCKS : natural := 2 ** CNT_WIDTH;

    component PwmController is
        generic(
            CNT_WIDTH : natural := 8
        );
        port(
            CLK : in std_logic;
            CLR : in std_logic;
            EN : in std_logic;
            FILL : in std_logic_vector(CNT_WIDTH - 1 downto 0);
            Q : out std_logic
        );
    end component;
    
    type fill_test_arr is array(1 to 5) of natural;
    constant fill_arr : fill_test_arr := (
        1 => 0,
        2 => ALL_CLOCKS / 4,
        3 => ALL_CLOCKS / 2,
        4 => ALL_CLOCKS / 4 * 3,
        5 => ALL_CLOCKS - 1
    );
    
    signal CLK : std_logic := '0';
    signal CLR : std_logic;
    signal EN : std_logic;
    signal FILL : std_logic_vector(CNT_WIDTH - 1 downto 0);
    signal Q : std_logic;
begin
    U0 : PwmController
    generic map(CNT_WIDTH => CNT_WIDTH)
    port map(CLK => CLK, CLR => CLR, EN => EN, FILL => FILL, Q => Q);
    
    CLK <= transport not CLK after 5 ns;
    
    process
        variable succeeded_tests : natural;
        variable test_count : natural;
        variable cur_fill : natural;
        variable expected_value : std_logic;
        variable was_changed : boolean;
    begin
        succeeded_tests := 0;
        test_count := 0;
        
        for i in fill_arr'range loop
            cur_fill := fill_arr(i);
            EN <= '0';
            CLR <= '0';
            FILL <= std_logic_vector(to_unsigned(cur_fill, FILL'length));
            wait for 10 ns;
            report "FILL=" & natural'image(cur_fill) & " test suite.";
            
            report "Initial reset.";
            CLR <= '1';
            wait for 5 ns;
            CLR <= '0';
            wait for 5 ns;
            test_count := test_count + 1;
            if (cur_fill = 0 and Q = '0') or (cur_fill /= 0 and Q = '1') then
                succeeded_tests := succeeded_tests + 1;
            else
                report "Initial reset was not completed properly when FILL=" & natural'image(cur_fill) & ".";
            end if;
            
            report "EN='0' test.";
            EN <= '0';
            expected_value := Q;
            was_changed := false;
            for j in 1 to ALL_CLOCKS loop
                wait for 10 ns;
                if Q /= expected_value then
                    was_changed := true;
                end if;
            end loop;
            test_count := test_count + 1;
            if was_changed then
                report "PwmController should not change its value when EN is 0.";
            else
                succeeded_tests := succeeded_tests + 1;
            end if;
            
            report "EN='1' test.";
            EN <= '1';
            test_count := test_count + 2;
            was_changed := false;
            expected_value := '1';
            for j in 1 to cur_fill loop
                if Q /= expected_value then
                    was_changed := true;
                end if;
                wait for 10 ns;
            end loop;
            if was_changed then
                report "PwmController should not return 1 before getting " & natural'image(cur_fill) & " CLK signals.";
            else
                succeeded_tests := succeeded_tests + 1;
            end if;
            was_changed := false;
            expected_value := '0';
            for j in 1 to ALL_CLOCKS - cur_fill loop
                if Q /= expected_value then
                    was_changed := true;
                end if;
                wait for 10 ns;
            end loop;
            if was_changed then
                report "PwmController should not return 0 before getting " & natural'image(cur_fill) & " CLK signals.";
            else
                succeeded_tests := succeeded_tests + 1;
            end if;
        end loop;
        
        report natural'image(succeeded_tests) & " tests of " & natural'image(test_count) & " succeeded.";
        wait;
    end process;
end Behavioral;
