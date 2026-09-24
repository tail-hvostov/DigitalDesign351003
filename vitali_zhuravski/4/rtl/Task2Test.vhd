----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026
-- Design Name: 
-- Module Name: Task2Test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for Task2Machine FSM
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: 
-- CLK_FREQ=100 means 1 logical second = 100 CLK cycles
-- CLK period = 10 ms, so 1 logical second = 1000 ms
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2Test is
end Task2Test;

architecture Behavioral of Task2Test is

    component Task2Machine is
        generic(
            CLK_FREQ : natural := 100_000_000
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

    signal CLK         : std_logic := '0';
    signal RST         : std_logic := '0';
    signal MODE        : std_logic := '0';
    signal CAR_SENSOR  : std_logic := '0';
    signal MANUAL_NEXT : std_logic := '0';

    signal MAIN_RED    : std_logic;
    signal MAIN_YELLOW : std_logic;
    signal MAIN_GREEN  : std_logic;
    signal SEC_RED     : std_logic;
    signal SEC_YELLOW  : std_logic;
    signal SEC_GREEN   : std_logic;

    constant CLK_PERIOD  : time := 10 ms;
    constant ONE_SEC     : time := 1000 ms;
    constant QUARTER_SEC : time := 250 ms;
    constant SYNC_DELAY  : time := 30 ms;

begin

    CLK <= not CLK after CLK_PERIOD / 2;

    U0 : Task2Machine
        generic map(CLK_FREQ => 100)
        port map(
            CLK         => CLK,
            RST         => RST,
            MODE        => MODE,
            CAR_SENSOR  => CAR_SENSOR,
            MANUAL_NEXT => MANUAL_NEXT,
            MAIN_RED    => MAIN_RED,
            MAIN_YELLOW => MAIN_YELLOW,
            MAIN_GREEN  => MAIN_GREEN,
            SEC_RED     => SEC_RED,
            SEC_YELLOW  => SEC_YELLOW,
            SEC_GREEN   => SEC_GREEN
        );

    process
        variable passed : natural := 0;
        variable failed : natural := 0;
        variable total  : natural := 0;

        procedure check(
            exp_MR : std_logic;
            exp_MY : std_logic;
            exp_MG : std_logic;
            exp_SR : std_logic;
            exp_SY : std_logic;
            exp_SG : std_logic;
            name   : string
        ) is
        begin
            total := total + 1;
            if MAIN_RED = exp_MR and MAIN_YELLOW = exp_MY and
               MAIN_GREEN = exp_MG and SEC_RED = exp_SR and
               SEC_YELLOW = exp_SY and SEC_GREEN = exp_SG then
                passed := passed + 1;
                report "PASS: " & name severity note;
            else
                failed := failed + 1;
                report "FAIL: " & name severity error;
            end if;
        end procedure;

        -- Overload: skip MAIN_GREEN check (for blinking state)
        procedure check_blink(
            exp_MR : std_logic;
            exp_MY : std_logic;
            exp_SR : std_logic;
            exp_SY : std_logic;
            exp_SG : std_logic;
            name   : string
        ) is
        begin
            total := total + 1;
            if MAIN_RED = exp_MR and MAIN_YELLOW = exp_MY and
               SEC_RED = exp_SR and
               SEC_YELLOW = exp_SY and SEC_GREEN = exp_SG then
                passed := passed + 1;
                report "PASS: " & name severity note;
            else
                failed := failed + 1;
                report "FAIL: " & name severity error;
            end if;
        end procedure;

        procedure press_button is
        begin
            MANUAL_NEXT <= '1';
            wait for 2 * CLK_PERIOD;
            MANUAL_NEXT <= '0';
            wait for 2 * CLK_PERIOD;
        end procedure;

    begin
        report "========================================" severity note;
        report "Starting Task2Machine Testbench" severity note;
        report "========================================" severity note;

        -- Initial values
        RST <= '0';
        MODE <= '0';
        CAR_SENSOR <= '0';
        MANUAL_NEXT <= '0';

        -- ========================================
        -- RESET
        -- ========================================
        wait for 2 * CLK_PERIOD;
        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        wait for SYNC_DELAY;

        -- ========================================
        -- TEST 1: Initial state A_MAIN_G
        -- ========================================
        report "" severity note;
        report "--- TEST 1: Initial state A_MAIN_G ---" severity note;
        check('0','0','1','1','0','0', "After reset -> A_MAIN_G");

        -- ========================================
        -- TEST 2: CAR_SENSOR triggers A_MAIN_GB
        -- ========================================
        report "" severity note;
        report "--- TEST 2: Adaptive CAR_SENSOR ---" severity note;
        wait for 2 * ONE_SEC;
        CAR_SENSOR <= '1';
        wait for SYNC_DELAY;
        check_blink('0','0','1','0','0', "CAR_SENSOR -> A_MAIN_GB (blink)");

        -- ========================================
        -- TEST 3: A_MAIN_GB -> A_MAIN_Y (3 sec)
        -- ========================================
        report "" severity note;
        report "--- TEST 3: A_MAIN_GB -> A_MAIN_Y ---" severity note;
        wait for 3 * ONE_SEC - SYNC_DELAY;
        check('0','1','0','1','0','0', "After 3s -> A_MAIN_Y");
        CAR_SENSOR <= '0';

        -- ========================================
        -- TEST 4: A_MAIN_Y -> A_SEC_G (2 sec)
        -- ========================================
        report "" severity note;
        report "--- TEST 4: A_MAIN_Y -> A_SEC_G ---" severity note;
        wait for 2 * ONE_SEC;
        check('1','0','0','0','0','1', "After 2s -> A_SEC_G");

        -- ========================================
        -- TEST 5: Early exit A_SEC_G (CAR=0, 3 sec)
        -- ========================================
        report "" severity note;
        report "--- TEST 5: Early exit A_SEC_G ---" severity note;
        wait for 3 * ONE_SEC;
        check('1','0','0','0','1','0', "CAR=0 after 3s -> A_SEC_Y");

        -- ========================================
        -- TEST 6: A_SEC_Y -> A_MAIN_G (2 sec)
        -- ========================================
        report "" severity note;
        report "--- TEST 6: A_SEC_Y -> A_MAIN_G ---" severity note;
        wait for 2 * ONE_SEC;
        check('0','0','1','1','0','0', "After 2s -> A_MAIN_G");

        -- ========================================
        -- TEST 7: Full auto cycle (10s timer)
        -- ========================================
        report "" severity note;
        report "--- TEST 7: Full auto cycle (timer) ---" severity note;
        wait for 10 * ONE_SEC;
        check_blink('0','0','1','0','0', "After 10s -> A_MAIN_GB");

        wait for 3 * ONE_SEC;
        check('0','1','0','1','0','0', "After 3s -> A_MAIN_Y");

        wait for 2 * ONE_SEC;
        check('1','0','0','0','0','1', "After 2s -> A_SEC_G");

        -- ========================================
        -- TEST 8: Extended A_SEC_G (CAR=1, 6 sec)
        -- ========================================
        report "" severity note;
        report "--- TEST 8: Extended A_SEC_G ---" severity note;
        CAR_SENSOR <= '1';
        wait for 3 * ONE_SEC;
        check('1','0','0','0','0','1', "CAR=1 after 3s -> stay A_SEC_G");

        wait for 3 * ONE_SEC;
        check('1','0','0','0','1','0', "After 6s total -> A_SEC_Y");
        CAR_SENSOR <= '0';

        wait for 2 * ONE_SEC;
        check('0','0','1','1','0','0', "After 2s -> A_MAIN_G");

        -- ========================================
        -- TEST 9: Switch to manual mode
        -- ========================================
        report "" severity note;
        report "--- TEST 9: Switch to manual ---" severity note;
        MODE <= '1';
        wait for SYNC_DELAY;
        check('0','0','1','1','0','0', "MODE=1 -> M_MAIN_G");

        -- ========================================
        -- TEST 10: Manual step-by-step
        -- ========================================
        report "" severity note;
        report "--- TEST 10: Manual step-by-step ---" severity note;

        press_button;
        check('0','1','0','1','0','0', "Button -> M_MAIN_Y");

        press_button;
        check('1','0','0','0','0','1', "Button -> M_SEC_G");

        press_button;
        check('1','0','0','0','1','0', "Button -> M_SEC_Y");

        press_button;
        check('0','0','1','1','0','0', "Button -> M_MAIN_G");

        -- ========================================
        -- TEST 11: MODE ignored outside MAIN_G
        -- ========================================
        report "" severity note;
        report "--- TEST 11: MODE ignored outside MAIN_G ---" severity note;

        press_button;
        -- Now in M_MAIN_Y
        MODE <= '0';
        wait for SYNC_DELAY;
        check('0','1','0','1','0','0', "MODE=0 in M_MAIN_Y -> no change");

        -- Return to M_MAIN_G first
        press_button;  -- M_SEC_G
        press_button;  -- M_SEC_Y
        press_button;  -- M_MAIN_G
        MODE <= '0';
        wait for SYNC_DELAY;
        check('0','0','1','1','0','0', "MODE=0 in M_MAIN_G -> A_MAIN_G");

        -- ========================================
        -- TEST 12: Reset during operation
        -- ========================================
        report "" severity note;
        report "--- TEST 12: Reset during operation ---" severity note;
        wait for 5 * ONE_SEC;
        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        wait for SYNC_DELAY;
        check('0','0','1','1','0','0', "RST during A_MAIN_G -> A_MAIN_G");

        -- ========================================
        -- Final report
        -- ========================================
        report "" severity note;
        report "========================================" severity note;
        report "Results: " &
               natural'image(passed) & " passed, " &
               natural'image(failed) & " failed, " &
               natural'image(total) & " total" severity note;
        report "========================================" severity note;

        if failed = 0 then
            report "ALL TESTS PASSED" severity note;
        else
            report "SOME TESTS FAILED" severity error;
        end if;

        wait;
    end process;

end Behavioral;