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
    constant BLINK_FREQ : natural := CLK_FREQ / 2;
    type states is (A_MAIN_G, A_MAIN_B, A_MAIN_Y, A_SEC_G, A_SEC_G2, A_SEC_Y, M_MAIN_G, M_MAIN_Y, M_SEC_G, M_SEC_Y);
    
    signal blink_clk : std_logic;
    signal sec_clk : std_logic;
    signal time_en : std_logic;
    signal sec_limit : std_logic_vector(3 downto 0);
    signal period_clk : std_logic;
    signal time_clr : std_logic;
    
    signal cur_state : states;
    
    signal main_green_blink : std_logic;
    signal main_green_en : std_logic;
    
    signal button_pressed : std_logic;
    signal button_state : std_logic;
    
    component EvalDivider is
        generic(
            EVAL : natural
        );
        port(
            CLK : in  std_logic;
            CLR : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
    component DynamicDivider is
        generic(
            N : natural range 2 to 20
        );
        port(
            LIMIT : in  std_logic_vector(N - 1 downto 0);
            CLK   : in  std_logic;
            EN    : in  std_logic;
            CLR   : in  std_logic;
            Q     : out std_logic
        );
    end component;
begin
    
    U0 : EvalDivider
    generic map(EVAL => BLINK_FREQ)
    port map(CLK => CLK, CLR => time_clr, EN => time_en, Q => blink_clk);
    
    U1 : EvalDivider
    generic map(EVAL => 2)
    port map(CLK => blink_clk, CLR => time_clr, EN => time_en, Q => sec_clk);
    
    U2 : DynamicDivider
    generic map(N => sec_limit'length)
    port map(CLK => sec_clk, CLR => time_clr, EN => time_en, LIMIT => sec_limit, Q => period_clk);
    
    process(cur_state)
    begin
        case cur_state is
            when A_MAIN_G =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '1';
                SEC_RED <= '1';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '1';
                sec_limit <= X"A";
            when A_MAIN_B =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '0';
                main_green_blink <= '1';
                main_green_en <= '1';
                SEC_RED <= '1';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '1';
                sec_limit <= X"3";
            when A_MAIN_Y =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '1';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '1';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '1';
                sec_limit <= X"2";
            when A_SEC_G =>
                MAIN_RED <= '1';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '1';
                time_en <= '1';
                sec_limit <= X"3";
            when A_SEC_G2 =>
                MAIN_RED <= '1';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '1';
                time_en <= '1';
                sec_limit <= X"3";
            when A_SEC_Y =>
                MAIN_RED <= '1';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '1';
                SEC_GREEN <= '0';
                time_en <= '1';
                sec_limit <= X"2";
            when M_MAIN_G =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '1';
                SEC_RED <= '1';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '0';
                sec_limit <= X"0";
            when M_MAIN_Y =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '1';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '1';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '0';
                sec_limit <= X"0";
            when M_SEC_G =>
                MAIN_RED <= '1';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '1';
                time_en <= '0';
                sec_limit <= X"0";
            when M_SEC_Y =>
                MAIN_RED <= '1';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '1';
                SEC_GREEN <= '0';
                time_en <= '0';
                sec_limit <= X"0";
            when others =>
                MAIN_RED <= '0';
                MAIN_YELLOW <= '0';
                main_green_blink <= '0';
                main_green_en <= '0';
                SEC_RED <= '0';
                SEC_YELLOW <= '0';
                SEC_GREEN <= '0';
                time_en <= '0';
                sec_limit <= X"0";
        end case;
    end process;
    
    process(CLK)
    begin
        if (button_state = '0') and (MANUAL_NEXT = '1') then
            button_pressed <= '1';
        else
            button_pressed <= '0';
        end if;
        button_state <= MANUAL_NEXT;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            time_clr <= '0';
            if RST = '1' then
                if MODE = '1' then
                    cur_state <= M_MAIN_G;
                else
                    time_clr <= '1';
                    cur_state <= A_MAIN_G;
                end if;
            else
                case cur_state is
                    when A_MAIN_G =>
                        if MODE = '1' then
                            cur_state <= M_MAIN_G;
                        elsif (CAR_SENSOR = '1') or rising_edge(period_clk) then
                            time_clr <= '1';
                            cur_state <= A_MAIN_B;
                        end if;
                    when A_MAIN_B =>
                        if rising_edge(period_clk) then
                            time_clr <= '1';
                            cur_state <= A_MAIN_Y;
                        end if;
                    when A_MAIN_Y =>
                        if rising_edge(period_clk) then
                            time_clr <= '1';
                            cur_state <= A_SEC_G;
                        end if;
                    when A_SEC_G =>
                        if rising_edge(period_clk) then
                            time_clr <= '1';
                            if CAR_SENSOR = '1' then
                                cur_state <= A_SEC_G2;
                            else
                                cur_state <= A_SEC_Y;
                            end if;
                        end if;
                    when A_SEC_G2 =>
                        if rising_edge(period_clk) then
                            time_clr <= '1';
                            cur_state <= A_SEC_Y;
                        end if;
                    when A_SEC_Y =>
                        if rising_edge(period_clk) then
                            time_clr <= '1';
                            cur_state <= A_MAIN_G;
                        end if;
                    when M_MAIN_G =>
                        if MODE = '0' then
                            time_clr <= '1';
                            cur_state <= A_MAIN_G;
                        elsif button_pressed = '1' then
                            cur_state <= M_MAIN_Y;
                        end if;
                    when M_MAIN_Y =>
                        if button_pressed = '1' then
                            cur_state <= M_SEC_G;
                        end if;
                    when M_SEC_G =>
                        if button_pressed = '1' then
                            cur_state <= M_SEC_Y;
                        end if;
                    when M_SEC_Y =>
                        if button_pressed = '1' then
                            cur_state <= M_MAIN_G;
                        end if;
                    when others =>
                        time_clr <= '1';
                        cur_state <= A_MAIN_G;
                end case;
            end if;
        end if;
    end process;
    
    MAIN_GREEN <= '0' when main_green_en = '0' else blink_clk when main_green_blink = '1' else '1';

end Behavioral;
