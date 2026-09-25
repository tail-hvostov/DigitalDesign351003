----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026 21:16:23
-- Design Name: 
-- Module Name: Task3Machine - Behavioral
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

entity Task3Machine is
    generic(
        FLOOR_COUNT : natural := 4
    );
    port(
        CLK                : in  std_logic;
        RST                : in  std_logic;
        CALL               : in  std_logic_vector(1 to FLOOR_COUNT);
        FLOOR_SENSOR       : in  std_logic_vector(1 to FLOOR_COUNT);
        DOOR_OPEN_SENSOR   : in  std_logic;
        DOOR_CLOSED_SENSOR : in  std_logic;
        TIMEOUT            : in  std_logic;
        
        MOTOR_UP           : out std_logic;
        MOTOR_DOWN         : out std_logic;
        DOOR_OPEN_CMD      : out std_logic;
        DOOR_CLOSE_CMD     : out std_logic
    );
end Task3Machine;

architecture Behavioral of Task3Machine is

    function find_above(requests : std_logic_vector(CALL'range); cur_floor : natural) return boolean is
    begin
        for i in requests'range loop
            if (i > cur_floor) and (requests(i) = '1') then
                return true;
            end if;
        end loop;
        return false;
    end function;
    
    function find_below(requests : std_logic_vector(CALL'range); cur_floor : natural) return boolean is
    begin
        for i in requests'range loop
            if (i < cur_floor) and (requests(i) = '1') then
                return true;
            end if;
        end loop;
        return false;
    end function;

    type machine_states is (IDLE, GO_UP, GO_DOWN, DOOR_OPENING, WAITING, DOOR_CLOSING);
    constant STATE_COUNT : positive := machine_states'pos(machine_states'high) + 1;
    type output_template_array is array(0 to STATE_COUNT - 1) of std_logic_vector(0 to 3);
    
    constant OUTPUT_TEMPLATES : output_template_array := (
        0 => "0000",
        1 => "1000",
        2 => "0100",
        3 => "0010",
        4 => "0000",
        5 => "0001"
    );
    constant NO_CALL : std_logic_vector(CALL'range) := (others => '0');
    
    signal state : machine_states;
    signal next_state : machine_states;
    signal output_template : std_logic_vector(0 to 3);
    signal force_down : std_logic;
    
    signal requests : std_logic_vector(CALL'range);
    signal cur_floor : natural range FLOOR_SENSOR'low to FLOOR_SENSOR'high;
begin
    
    process(FLOOR_SENSOR)
    begin
        cur_floor <= FLOOR_SENSOR'low;
        for i in FLOOR_SENSOR'low to FLOOR_SENSOR'high loop
            if FLOOR_SENSOR(i) = '1' then
                cur_floor <= i;
                exit;
            end if;
        end loop;
    end process;

    process(CLK)
        variable pure_call : std_logic_vector(CALL'range);
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                requests <= (others => '0');
            else
                pure_call := CALL;
                pure_call(cur_floor) := '0';
                requests <= requests or pure_call;
                
                if state = DOOR_OPENING then
                    requests(cur_floor) <= '0';
                end if;
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                force_down <= '0';
            elsif (state = IDLE) and (requests /= NO_CALL) then
                if (force_down = '1') and find_below(requests, cur_floor) then
                    force_down <= '1';
                elsif find_above(requests, cur_floor) then
                    force_down <= '0';
                else
                    force_down <= '1';
                end if;
            end if;
        end if;
    end process;

    process(state, requests, cur_floor, DOOR_OPEN_SENSOR, TIMEOUT, DOOR_CLOSED_SENSOR, force_down)
    begin
        next_state <= state;
        case state is
            when IDLE =>
                if requests /= NO_CALL then
                    if (force_down = '1') and find_below(requests, cur_floor) then
                        next_state <= GO_DOWN;
                    elsif find_above(requests, cur_floor) then
                        next_state <= GO_UP;
                    else
                        next_state <= GO_DOWN;
                    end if;
                end if;
            when GO_UP | GO_DOWN =>
                if requests(cur_floor) = '1' then
                    next_state <= DOOR_OPENING;
                end if;
            when DOOR_OPENING =>
                if DOOR_OPEN_SENSOR = '1' then
                    next_state <= WAITING;
                end if;
            when WAITING =>
                if TIMEOUT = '1' then
                    next_state <= DOOR_CLOSING;
                end if;
            when DOOR_CLOSING =>
                if DOOR_CLOSED_SENSOR = '1' then
                    next_state <= IDLE;
                end if;
        end case;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;
    
    output_template <= OUTPUT_TEMPLATES(machine_states'pos(state));
    MOTOR_UP <= output_template(0);
    MOTOR_DOWN <= output_template(1);
    DOOR_OPEN_CMD <= output_template(2);
    DOOR_CLOSE_CMD <= output_template(3);
    
end Behavioral;
