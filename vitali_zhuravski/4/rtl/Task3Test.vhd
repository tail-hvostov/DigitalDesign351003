----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Create Date: 25.09.2026
-- Design Name: 
-- Module Name: Task3Test - Behavioral
-- Description: Testbench for Task3Machine (Elevator FSM)
-- 
-- FLOOR_SENSOR encoding (one-hot):
--   "1000" = floor 1
--   "0100" = floor 2
--   "0010" = floor 3
--   "0001" = floor 4
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3Test is
end Task3Test;

architecture Behavioral of Task3Test is

    component Task3Machine is
        generic(
            FLOOR_COUNT : natural := 4
        );
        port(
            CLK                : in  std_logic;
            RST                : in  std_logic;
            CALL               : in  std_logic_vector(1 to 4);
            FLOOR_SENSOR       : in  std_logic_vector(1 to 4);
            DOOR_OPEN_SENSOR   : in  std_logic;
            DOOR_CLOSED_SENSOR : in  std_logic;
            TIMEOUT            : in  std_logic;
            MOTOR_UP           : out std_logic;
            MOTOR_DOWN         : out std_logic;
            DOOR_OPEN_CMD      : out std_logic;
            DOOR_CLOSE_CMD     : out std_logic
        );
    end component;

    signal CLK                : std_logic := '0';
    signal RST                : std_logic := '0';
    signal CALL               : std_logic_vector(1 to 4) := "0000";
    signal FLOOR_SENSOR       : std_logic_vector(1 to 4) := "1000";
    signal DOOR_OPEN_SENSOR   : std_logic := '0';
    signal DOOR_CLOSED_SENSOR : std_logic := '1';
    signal TIMEOUT            : std_logic := '0';
    signal MOTOR_UP           : std_logic;
    signal MOTOR_DOWN         : std_logic;
    signal DOOR_OPEN_CMD      : std_logic;
    signal DOOR_CLOSE_CMD     : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    CLK <= not CLK after CLK_PERIOD / 2;

    U0 : Task3Machine
        generic map(FLOOR_COUNT => 4)
        port map(
            CLK                => CLK,
            RST                => RST,
            CALL               => CALL,
            FLOOR_SENSOR       => FLOOR_SENSOR,
            DOOR_OPEN_SENSOR   => DOOR_OPEN_SENSOR,
            DOOR_CLOSED_SENSOR => DOOR_CLOSED_SENSOR,
            TIMEOUT            => TIMEOUT,
            MOTOR_UP           => MOTOR_UP,
            MOTOR_DOWN         => MOTOR_DOWN,
            DOOR_OPEN_CMD      => DOOR_OPEN_CMD,
            DOOR_CLOSE_CMD     => DOOR_CLOSE_CMD
        );

    process

        procedure press_call(floor : integer) is
        begin
            CALL(floor) <= '1';
            wait for 3 * CLK_PERIOD;
            CALL(floor) <= '0';
            wait for 2 * CLK_PERIOD;
        end procedure;

        procedure go_to_floor(floor : integer) is
        begin
            case floor is
                when 1 => FLOOR_SENSOR <= "1000";
                when 2 => FLOOR_SENSOR <= "0100";
                when 3 => FLOOR_SENSOR <= "0010";
                when 4 => FLOOR_SENSOR <= "0001";
                when others => null;
            end case;
            wait for 3 * CLK_PERIOD;
        end procedure;

        procedure open_door is
        begin
            DOOR_CLOSED_SENSOR <= '0';
            DOOR_OPEN_SENSOR <= '1';
            wait for 3 * CLK_PERIOD;
        end procedure;

        procedure close_door is
        begin
            TIMEOUT <= '1';
            wait for 2 * CLK_PERIOD;
            TIMEOUT <= '0';
            wait for 2 * CLK_PERIOD;
            DOOR_OPEN_SENSOR <= '0';
            DOOR_CLOSED_SENSOR <= '1';
            wait for 3 * CLK_PERIOD;
        end procedure;

    begin
        -- ========================================
        -- INIT
        -- ========================================
        RST <= '0';
        CALL <= "0000";
        FLOOR_SENSOR <= "1000";
        DOOR_OPEN_SENSOR <= '0';
        DOOR_CLOSED_SENSOR <= '1';
        TIMEOUT <= '0';

        wait for 2 * CLK_PERIOD;
        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        wait for 3 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 1: Floor 1 -> Floor 3
        -- ========================================
        report "=== SCENARIO 1: Call floor 1 -> floor 3 ===" severity note;

        press_call(3);
        -- Expected: GO_UP, MOTOR_UP='1'
        report "Expect MOTOR_UP=1" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(2);
        -- Passing through floor 2, no request here
        wait for 5 * CLK_PERIOD;

        go_to_floor(3);
        -- Arrived at floor 3, requests(3)='1' -> DOOR_OPENING
        report "Expect DOOR_OPEN_CMD=1" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        -- WAITING
        report "Expect WAITING (no motor, no door cmd)" severity note;
        wait for 5 * CLK_PERIOD;

        close_door;
        -- DOOR_CLOSING -> IDLE
        report "Expect IDLE" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 2: Floor 3 -> Floor 1 (down)
        -- ========================================
        report "=== SCENARIO 2: Call floor 3 -> floor 1 ===" severity note;

        press_call(1);
        -- Expected: GO_DOWN, MOTOR_DOWN='1'
        report "Expect MOTOR_DOWN=1" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(2);
        wait for 5 * CLK_PERIOD;

        go_to_floor(1);
        -- Arrived at floor 1
        report "Expect DOOR_OPEN_CMD=1" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 5 * CLK_PERIOD;

        close_door;
        report "Expect IDLE" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 3: Floor 1 -> Floor 4, add call during movement
        -- ========================================
        report "=== SCENARIO 3: Floor 1 -> Floor 4, add CALL(2) during movement ===" severity note;

        press_call(4);
        report "Expect MOTOR_UP=1" severity note;
        wait for 5 * CLK_PERIOD;

        -- While moving up, someone presses floor 2
        press_call(2);
        wait for 3 * CLK_PERIOD;

        -- Arrive at floor 2, requests(2)='1' -> should stop
        go_to_floor(2);
        report "Expect DOOR_OPEN_CMD=1 (stop at floor 2)" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 3 * CLK_PERIOD;

        close_door;
        -- After closing, requests(4) still active -> GO_UP
        report "Expect MOTOR_UP=1 (continue to floor 4)" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(3);
        wait for 5 * CLK_PERIOD;

        go_to_floor(4);
        report "Expect DOOR_OPEN_CMD=1 (arrived floor 4)" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 3 * CLK_PERIOD;

        close_door;
        report "Expect IDLE" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 4: Floor 4 -> Floor 2
        -- ========================================
        report "=== SCENARIO 4: Call floor 4 -> floor 2 ===" severity note;

        press_call(2);
        report "Expect MOTOR_DOWN=1" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(3);
        wait for 5 * CLK_PERIOD;

        go_to_floor(2);
        report "Expect DOOR_OPEN_CMD=1" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 3 * CLK_PERIOD;

        close_door;
        report "Expect IDLE" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 5: Reset during movement
        -- ========================================
        report "=== SCENARIO 5: Reset during movement ===" severity note;

        press_call(4);
        report "Expect MOTOR_UP=1" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(2);
        wait for 3 * CLK_PERIOD;

        -- Reset while moving
        RST <= '1';
        wait for 5 * CLK_PERIOD;
        RST <= '0';
        FLOOR_SENSOR <= "1000";
        DOOR_OPEN_SENSOR <= '0';
        DOOR_CLOSED_SENSOR <= '1';
        wait for 3 * CLK_PERIOD;
        report "Expect IDLE, all outputs 0 after reset" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        -- SCENARIO 6: Multiple calls, SCAN order
        -- ========================================
        report "=== SCENARIO 6: Multiple calls (2,4), SCAN order ===" severity note;

        -- Press both 2 and 4 while on floor 1
        CALL(2) <= '1';
        CALL(4) <= '1';
        wait for 3 * CLK_PERIOD;
        CALL(2) <= '0';
        CALL(4) <= '0';
        wait for 3 * CLK_PERIOD;

        report "Expect MOTOR_UP=1 (GO_UP)" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(2);
        report "Expect DOOR_OPEN_CMD=1 (stop at 2 first)" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 3 * CLK_PERIOD;
        close_door;

        -- Should continue to floor 4
        report "Expect MOTOR_UP=1 (continue to 4)" severity note;
        wait for 5 * CLK_PERIOD;

        go_to_floor(3);
        wait for 5 * CLK_PERIOD;

        go_to_floor(4);
        report "Expect DOOR_OPEN_CMD=1 (stop at 4)" severity note;
        wait for 3 * CLK_PERIOD;

        open_door;
        wait for 3 * CLK_PERIOD;
        close_door;

        report "Expect IDLE" severity note;
        wait for 5 * CLK_PERIOD;

        -- ========================================
        report "=== ALL SCENARIOS COMPLETE ===" severity note;
        wait;
    end process;

end Behavioral;