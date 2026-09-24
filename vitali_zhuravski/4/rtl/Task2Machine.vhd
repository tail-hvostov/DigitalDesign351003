----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.09.2026 18:08:47
-- Design Name: 
-- Module Name: Task2Machine - Behavioral
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

entity Task2Machine is
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
end Task2Machine;

architecture Behavioral of Task2Machine is
    type machine_states is (A_MAIN_G, A_MAIN_GB, A_MAIN_Y, A_SEC_G, A_SEC_G2, A_SEC_Y,
                            M_MAIN_G, M_MAIN_Y, M_SEC_G, M_SEC_Y);
    constant STATE_COUNT : positive := machine_states'pos(machine_states'high) + 1;
    type output_template_array is array(1 to STATE_COUNT) of std_logic_vector(1 to 7);
    
    -- MR, MY, MG, MGB, SR, SY, SG
    constant OUTPUT_TEMPLATES : output_template_array := (
        1  => "0010100",
        2  => "0001100",
        3  => "0100100",
        4  => "1000001",
        5  => "1000001",
        6  => "1000010",
        
        7  => "0010100",
        8  => "0100100",
        9  => "1000001",
        10 => "1000010"
    );
    
    signal state : machine_states;
    signal next_state : machine_states;
    signal output_template_i : natural range 1 to STATE_COUNT;
    signal output_template : std_logic_vector(1 to 7);
    
    signal sec_counter : natural range 0 to 10;
    signal clk_counter : natural range 0 to CLK_FREQ - 1;
    signal blink_out : std_logic;
    signal sec_out : std_logic;
    signal manual_out : std_logic;
    signal prev_manual_out : std_logic;
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if MANUAL_NEXT = '1' then
                if prev_manual_out = '0' then
                    manual_out <= '1';
                    prev_manual_out <= '1';
                else
                    manual_out <= '0';
                end if;
            else
                manual_out <= '0';
                prev_manual_out <= '0';
            end if;
        end if;
    end process;

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                clk_counter <= 0;
            elsif clk_counter = CLK_FREQ - 1 then
                clk_counter <= 0;
            else
                clk_counter <= 1 + clk_counter;
            end if;
        end if;
    end process;
    blink_out <= '0' when (clk_counter < CLK_FREQ / 4) or
                          (clk_counter >= CLK_FREQ / 2 and clk_counter < 3 * CLK_FREQ / 4) else '1';
    sec_out <= '1' when clk_counter = (CLK_FREQ - 1) else '0';
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if next_state /= state then
                sec_counter <= 0;
            elsif sec_out = '1' then
                sec_counter <= 1 + sec_counter;
            end if;
        end if;
    end process;
   
    process(state, RST, MODE, sec_counter, CAR_SENSOR, manual_out)
    begin
        next_state <= state;
        if RST = '1' then
            if MODE= '0' then
                next_state <= A_MAIN_G;
            else
                next_state <= M_MAIN_G;
            end if;
        else
            case state is
                when A_MAIN_G =>
                    if MODE = '1' then
                        next_state <= M_MAIN_G;
                    elsif (sec_counter = 10) or (CAR_SENSOR = '1') then
                        next_state <= A_MAIN_GB;
                    end if;
                when A_MAIN_GB =>
                    if sec_counter = 3 then
                        next_state <= A_MAIN_Y;
                    end if;
                when A_MAIN_Y =>
                    if sec_counter = 2 then
                        next_state <= A_SEC_G;
                    end if;
                when A_SEC_G =>
                    if sec_counter = 3 then
                        if CAR_SENSOR = '0' then
                            next_state <= A_SEC_Y;
                        else
                            next_state <= A_SEC_G2;
                        end if;
                    end if;
                when A_SEC_G2 =>
                    if sec_counter = 3 then
                        next_state <= A_SEC_Y;
                    end if;
                when A_SEC_Y =>
                    if sec_counter = 2 then
                        next_state <= A_MAIN_G;
                    end if;
                when M_MAIN_G =>
                    if MODE = '0' then
                        next_state <= A_MAIN_G;
                    elsif manual_out = '1' then
                        next_state <= M_MAIN_Y;
                    end if;
                when M_MAIN_Y =>
                    if manual_out = '1' then
                        next_state <= M_SEC_G;
                    end if;
                when M_SEC_G =>
                    if manual_out = '1' then
                        next_state <= M_SEC_Y;
                    end if;
                when M_SEC_Y =>
                    if manual_out = '1' then
                        next_state <= M_MAIN_G;
                    end if;
            end case;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;
    
    with state select output_template_i <=
        1  when A_MAIN_G,
        2  when A_MAIN_GB,
        3  when A_MAIN_Y,
        4  when A_SEC_G,
        5  when A_SEC_G2,
        6  when A_SEC_Y,
        
        7  when M_MAIN_G,
        8  when M_MAIN_Y,
        9  when M_SEC_G,
        10 when M_SEC_Y,
        
        1  when others;
    output_template <= OUTPUT_TEMPLATES(output_template_i);
    MAIN_RED <= output_template(1);
    MAIN_YELLOW <= output_template(2);
    MAIN_GREEN <= blink_out when output_template(4) = '1' else output_template(3);
    SEC_RED <= output_template(5);
    SEC_YELLOW <= output_template(6);
    SEC_GREEN <= output_template(7);
end Behavioral;
