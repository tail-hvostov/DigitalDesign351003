----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Create Date: 26.09.2026
-- Design Name: 
-- Module Name: Task4Test - Behavioral
-- Description: Testbench for Task4Machine (Button Sequence FSM with Deadlock)
-- 
-- Sequence: BTN(0) ? BTN(1) ? BTN(2) ? BTN(1)
-- CLK_FREQ=100, CLK period=10ms ? 1 logical second = 1000ms
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4Test is
end Task4Test;

architecture Behavioral of Task4Test is

    component Task4Machine is
        generic(
            CLK_FREQ     : natural := 100_000_000;
            MAX_ERRORS   : natural := 3
        );
        port(
            CLK          : in  std_logic;
            RST          : in  std_logic;
            BTN          : in  std_logic_vector(2 downto 0);
            ADMIN_UNLOCK : in  std_logic;
            
            LED_GREEN    : out std_logic;
            LED_RED      : out std_logic;
            LED_BLUE     : out std_logic
        );
    end component;

    signal CLK          : std_logic := '0';
    signal RST          : std_logic := '0';
    signal BTN          : std_logic_vector(2 downto 0) := (others => '0');
    signal ADMIN_UNLOCK : std_logic := '0';
    
    signal LED_GREEN    : std_logic;
    signal LED_RED      : std_logic;
    signal LED_BLUE     : std_logic;

    constant CLK_PERIOD : time := 10 ms;
    constant ONE_SEC    : time := 1000 ms;

begin

    CLK <= not CLK after CLK_PERIOD / 2;

    U0 : Task4Machine
        generic map(CLK_FREQ => 100, MAX_ERRORS => 3)
        port map(
            CLK          => CLK,
            RST          => RST,
            BTN          => BTN,
            ADMIN_UNLOCK => ADMIN_UNLOCK,
            LED_GREEN    => LED_GREEN,
            LED_RED      => LED_RED,
            LED_BLUE     => LED_BLUE
        );

    process

        procedure press_btn0 is
        begin
            BTN <= (0 => '1', others => '0');
            wait for 3 * CLK_PERIOD;
            BTN <= (others => '0');
            wait for 5 * CLK_PERIOD;
        end procedure;

        procedure press_btn1 is
        begin
            BTN <= (1 => '1', others => '0');
            wait for 3 * CLK_PERIOD;
            BTN <= (others => '0');
            wait for 5 * CLK_PERIOD;
        end procedure;

        procedure press_btn2 is
        begin
            BTN <= (2 => '1', others => '0');
            wait for 3 * CLK_PERIOD;
            BTN <= (others => '0');
            wait for 5 * CLK_PERIOD;
        end procedure;

        procedure check_await_state(test_name : string) is
        begin
            if LED_GREEN = '0' and LED_RED = '0' then
                report "PASS: " & test_name & " - AWAIT state" severity note;
            else
                report "FAIL: " & test_name & " - Expected AWAIT" severity error;
            end if;
        end procedure;

        procedure check_unlocked_state(test_name : string) is
        begin
            if LED_GREEN = '1' and LED_RED = '0' and LED_BLUE = '0' then
                report "PASS: " & test_name & " - UNLOCKED state" severity note;
            else
                report "FAIL: " & test_name & " - Expected UNLOCKED" severity error;
            end if;
        end procedure;

        procedure check_deadlock_state(test_name : string) is
        begin
            if LED_RED = '1' and LED_GREEN = '0' and LED_BLUE = '0' then
                report "PASS: " & test_name & " - DEADLOCK state" severity note;
            else
                report "FAIL: " & test_name & " - Expected DEADLOCK" severity error;
            end if;
        end procedure;

    begin
        report "========================================" severity note;
        report "Starting Task4Machine Testbench" severity note;
        report "========================================" severity note;

        -- Initial state
        RST <= '0';
        BTN <= (others => '0');
        ADMIN_UNLOCK <= '0';

        -- Reset
        wait for 2 * CLK_PERIOD;
        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        wait for 3 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 1: Correct sequence ? GREEN ? AWAIT
        -- ========================================
        report "" severity note;
        report "=== SCENARIO 1: Correct sequence ===" severity note;

        check_await_state("Initial state");

        wait for 500 ms;
        report "BLUE should be blinking in AWAIT" severity note;

        -- Correct sequence: BTN(0) ? BTN(1) ? BTN(2) ? BTN(1)
        press_btn0;
        press_btn1;
        press_btn2;
        press_btn1;

        wait for 3 * CLK_PERIOD;
        check_unlocked_state("After correct sequence");

        wait for 5 * ONE_SEC;
        check_await_state("After 5 seconds timeout");

        -- ========================================
        -- SCENARIO 2: Three errors ? DEADLOCK
        -- ========================================
        report "" severity note;
        report "=== SCENARIO 2: Three errors ? DEADLOCK ===" severity note;

        press_btn2;
        press_btn2;
        press_btn2;

        wait for 3 * CLK_PERIOD;
        check_deadlock_state("After 3 errors");

        press_btn0;
        press_btn1;
        press_btn2;
        wait for 3 * CLK_PERIOD;
        check_deadlock_state("Buttons ignored in DEADLOCK");

        -- ========================================
        -- SCENARIO 3: Admin unlock from DEADLOCK
        -- ========================================
        report "" severity note;
        report "=== SCENARIO 3: Admin unlock ===" severity note;

        ADMIN_UNLOCK <= '1';
        BTN <= (0 => '1', others => '0');
        wait for 10 * CLK_PERIOD;
        ADMIN_UNLOCK <= '0';
        BTN <= (others => '0');
        wait for 3 * CLK_PERIOD;

        check_await_state("After admin unlock");

        -- ========================================
        -- SCENARIO 4: Reset during deadlock
        -- ========================================
        report "" severity note;
        report "=== SCENARIO 4: Reset during deadlock ===" severity note;

        press_btn2;
        press_btn2;
        press_btn2;
        wait for 3 * CLK_PERIOD;
        check_deadlock_state("Entered DEADLOCK again");

        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        wait for 3 * CLK_PERIOD;

        check_await_state("After RST");

        -- ========================================
        -- SCENARIO 5: Partial correct sequence then error
        -- ========================================
        report "" severity note;
        report "=== SCENARIO 5: Partial correct then error ===" severity note;

        press_btn0;
        press_btn1;
        wait for 3 * CLK_PERIOD;
        check_await_state("After 2 correct buttons");

        press_btn0;  -- Wrong (expected BTN(2))
        wait for 3 * CLK_PERIOD;
        check_await_state("After error (err_counter=1)");

        press_btn2;
        press_btn2;
        wait for 3 * CLK_PERIOD;
        check_deadlock_state("After 3 total errors");

        ADMIN_UNLOCK <= '1';
        BTN <= (0 => '1', others => '0');
        wait for 10 * CLK_PERIOD;
        ADMIN_UNLOCK <= '0';
        BTN <= (others => '0');
        wait for 3 * CLK_PERIOD;

        check_await_state("After admin unlock (err_counter reset)");

        -- ========================================
        report "" severity note;
        report "========================================" severity note;
        report "ALL SCENARIOS COMPLETE" severity note;
        report "========================================" severity note;

        wait;
    end process;

end Behavioral;