----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 21:29:14
-- Design Name: 
-- Module Name: Task4Machine - Behavioral
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

entity Task4Machine is
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
end Task4Machine;

architecture Behavioral of Task4Machine is
    type machine_states is (AWAIT, UNLOCKED, DEADLOCK);
    constant STATE_COUNT : positive := machine_states'pos(machine_states'high) + 1;
    type output_template_array is array(0 to STATE_COUNT - 1) of std_logic_vector(0 to 2);
    type awaited_seqs_array is array(0 to 3) of std_logic_vector(BTN'range);
        
    constant OUTPUT_TEMPLATES : output_template_array := (
        0 => "001",
        1 => "100",
        2 => "010"
    );
    -- BTN(0) > BTN(1) > BTN(2) > BTN(1)
    constant AWAITED_SEQS : awaited_seqs_array := (
        0 => "001",
        1 => "010",
        2 => "100",
        3 => "010"
    );
    constant NO_BTNS : std_logic_vector(BTN'range) := (others => '0');
    
    signal state : machine_states;
    signal next_state : machine_states;
    signal seq_counter : natural range AWAITED_SEQS'low to AWAITED_SEQS'high;
    signal next_seq_counter : natural range AWAITED_SEQS'low to AWAITED_SEQS'high;
    signal err_counter : natural range 0 to MAX_ERRORS - 1;
    signal next_err_counter :  natural range 0 to MAX_ERRORS - 1;
    signal output_template : std_logic_vector(0 to 2);
    
    signal blink_out : std_logic;
    signal sec_out : std_logic;
    signal btn_out : std_logic_vector(BTN'range);
    signal prev_btn_out : std_logic_vector(BTN'range);
    
    signal sec_counter : natural range 0 to 10;
    signal clk_counter : natural range 0 to CLK_FREQ - 1;
begin
    
    process(state, btn_out, seq_counter, err_counter, sec_counter, ADMIN_UNLOCK, BTN)
    begin
        next_state <= state;
        next_seq_counter <= seq_counter;
        next_err_counter <= err_counter;
        case state is
            when AWAIT =>
                if btn_out /= NO_BTNS then
                    if AWAITED_SEQS(seq_counter) = btn_out then
                        next_err_counter <= 0;
                        if seq_counter < AWAITED_SEQS'high then
                            next_seq_counter <= seq_counter + 1;
                        else
                            next_state <= UNLOCKED;
                        end if;
                    else
                        if err_counter < MAX_ERRORS - 1 then
                            next_seq_counter <= 0;
                            next_err_counter <= err_counter + 1;
                        else
                            next_state <= DEADLOCK;
                        end if;
                    end if;
                end if;
            when UNLOCKED =>
                if sec_counter = 5 then
                    next_state <= AWAIT;
                    next_seq_counter <= 0;
                    next_err_counter <= 0;
                end if;
            when DEADLOCK =>
                if (ADMIN_UNLOCK = '1') and (BTN(0) = '1') then
                    next_state <= AWAIT;
                    next_seq_counter <= 0;
                    next_err_counter <= 0;
                end if;
        end case;
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
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                state <= AWAIT;
                err_counter <= 0;
                seq_counter <= 0;
            else
                state <= next_state;
                err_counter <= next_err_counter;
                seq_counter <= next_seq_counter;
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                btn_out <= (others => '0');
                prev_btn_out <= (others => '0');
            else
                for i in BTN'low to BTN'high loop
                    if BTN(i) = '1' then
                        if prev_btn_out(i) = '0' then
                            btn_out(i) <= '1';
                            prev_btn_out(i) <= '1';
                        else
                            btn_out(i) <= '0';
                        end if;
                    else
                        btn_out(i) <= '0';
                        prev_btn_out(i) <= '0';
                    end if;
                end loop;
            end if;
        end if;
    end process;
    
    output_template <= OUTPUT_TEMPLATES(machine_states'pos(state));
    LED_GREEN <= output_template(0);
    LED_RED <= output_template(1);
    LED_BLUE <= '0' when output_template(2) = '0' else blink_out;
end Behavioral;
