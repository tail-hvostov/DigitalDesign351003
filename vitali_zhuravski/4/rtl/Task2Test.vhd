----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2026 12:14:28
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task2Test is
--  Port ( );
end Task2Test;

architecture Behavioral of Task2Test is

    signal outputs : std_logic_vector(5 downto 0);
    signal CLK : std_logic := '0';
    signal RST : std_logic;
    signal MODE : std_logic;
    signal CAR_SENSOR : std_logic;
    signal MANUAL_NEXT : std_logic;
    
    type out_val_array is array(0 to 2) of std_logic_vector(5 downto 0);
    constant out_vals : out_val_array := (
        0 => "001100",
        1 => "000100",
        2 => "001100"
    );

    component Task2Machine is
        generic(
            CLK_FREQ    : natural := 100_000_000
        );
        port(
            CLK         : in  std_logic;
            RST         : in  std_logic;
            MODE        : in  std_logic;
            CAR_SENSOR  : in  std_logic;
            MANUAL_NEXT : in  std_logic;
            MAIN_RED    : out std_logic;
            MAIN_YELLOW : out std_logic;
            MAIN_GREEN  : out std_logic;
            SEC_RED     : out std_logic;
            SEC_YELLOW  : out std_logic;
            SEC_GREEN   : out std_logic
        );
    end component;

begin
    
    U0 : Task2Machine
    generic map(CLK_FREQ => 100)
    port map(CLK => CLK, RST => RST, MODE => MODE, CAR_SENSOR => CAR_SENSOR, MANUAL_NEXT => MANUAL_NEXT,
                MAIN_RED => outputs(5), MAIN_YELLOW => outputs(4), MAIN_GREEN => outputs(3),
                SEC_RED => outputs(2), SEC_YELLOW => outputs(1), SEC_GREEN => outputs(0));
    
    CLK <= transport not CLK after 5 ms;
    
    process
        variable test_counter : natural;
        variable succeeded_tests : natural;
        variable temp_outs : std_logic_vector(outputs'range);
    begin
        test_counter := 0;
        succeeded_tests := 0;
        
        RST <= '0';
        MODE <= '0';
        CAR_SENSOR <= '0';
        MANUAL_NEXT <= '0';
        wait for 10 ms;
        RST <= '1';
        wait for 10 ms;
        RST <= '0';
        
        if outputs = out_vals(test_counter) then
            succeeded_tests := succeeded_tests + 1;
        else
            report "Wrong A_MAIN_G outputs.";
        end if;
        test_counter := test_counter + 1;
        
        CAR_SENSOR <= '1';
        wait for 10 ms;
        
        if outputs = out_vals(test_counter) then
            succeeded_tests := succeeded_tests + 1;
        else
            report "Green must blink during A_MAIN_B.";
        end if;
        test_counter := test_counter + 1;
        
        CAR_SENSOR <= '0';
        wait for 500 ms;
        if outputs = out_vals(test_counter) then
            succeeded_tests := succeeded_tests + 1;
        else
            report "Green must blink during A_MAIN_B #2.";
        end if;
        test_counter := test_counter + 1;
        
        
        report natural'image(succeeded_tests) & " tests of " & natural'image(test_counter) & " succeeded.";
        wait;
    end process;

end Behavioral;
