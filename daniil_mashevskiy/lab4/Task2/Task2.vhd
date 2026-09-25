library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task2 is
    Port ( CLK          : in STD_LOGIC;    
           RST          : in STD_LOGIC;    
           MODE         : in STD_LOGIC;    
           CAR_SENSOR   : in STD_LOGIC;    
           MANUAL_NEXT  : in STD_LOGIC;    
           
           MAIN_RED     : out STD_LOGIC;
           MAIN_YELLOW  : out STD_LOGIC;
           MAIN_GREEN   : out STD_LOGIC;
           SEC_RED      : out STD_LOGIC;
           SEC_YELLOW   : out STD_LOGIC;
           SEC_GREEN    : out STD_LOGIC
    );
end Task2;

architecture Behavioral of Task2 is
    type t_state is (
        ST_MAIN_GREEN,
        ST_MAIN_GREEN_BLINK,
        ST_MAIN_YELLOW,
        ST_SEC_GREEN,
        ST_SEC_YELLOW
    );
    signal current_state, next_state : t_state;
    
    constant COUNTER_1HZ_MAX : integer := 100000000; 
    constant COUNTER_2HZ_MAX : integer := 50000000;  
    
    signal counter_1hz : integer range 0 to COUNTER_1HZ_MAX - 1 := 0;
    signal tick_1hz : STD_LOGIC := '0';
    signal counter_2hz : integer range 0 to COUNTER_2HZ_MAX - 1 := 0;
    signal blink_state : STD_LOGIC := '0';
    
    signal time_counter : integer range 0 to 10 := 0;
    signal sec_green_counter : integer range 0 to 6 := 0;
    
    signal manual_next_prev : STD_LOGIC := '0';
    signal manual_next_edge : STD_LOGIC := '0';
    signal mode_reg : STD_LOGIC := '0';
    
    signal main_red_int     : STD_LOGIC := '1';
    signal main_yellow_int  : STD_LOGIC := '0';
    signal main_green_int   : STD_LOGIC := '0';
    signal sec_red_int      : STD_LOGIC := '1';
    signal sec_yellow_int   : STD_LOGIC := '0';
    signal sec_green_int    : STD_LOGIC := '0';
    
begin
    MAIN_RED    <= main_red_int;
    MAIN_YELLOW <= main_yellow_int;
    MAIN_GREEN  <= main_green_int;
    SEC_RED     <= sec_red_int;
    SEC_YELLOW  <= sec_yellow_int;
    SEC_GREEN   <= sec_green_int;
    
    process(CLK)     
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter_1hz <= 0;
                tick_1hz <= '0';
            else
                if counter_1hz = COUNTER_1HZ_MAX - 1 then
                    counter_1hz <= 0;
                    tick_1hz <= '1';
                else
                    counter_1hz <= counter_1hz + 1;
                    tick_1hz <= '0';
                end if;
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter_2hz <= 0;
                blink_state <= '0';
            else
                if counter_2hz = COUNTER_2HZ_MAX - 1 then
                    counter_2hz <= 0;
                    blink_state <= not blink_state;
                else
                    counter_2hz <= counter_2hz + 1;
                end if;
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                manual_next_prev <= '0';
            else
                manual_next_prev <= MANUAL_NEXT;
            end if;
        end if;
    end process;
    manual_next_edge <= MANUAL_NEXT and not manual_next_prev;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                mode_reg <= '0';
            elsif current_state = ST_MAIN_GREEN then
                mode_reg <= MODE;
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                current_state <= ST_MAIN_GREEN;
                time_counter <= 0;
                sec_green_counter <= 0;
            else
                current_state <= next_state;
                
                if tick_1hz = '1' then
                    case current_state is
                        when ST_MAIN_GREEN =>
                            if mode_reg = '0' and time_counter < 9 then
                                time_counter <= time_counter + 1;
                            end if;
                        when ST_MAIN_GREEN_BLINK =>
                            if mode_reg = '0' and time_counter < 2 then
                                time_counter <= time_counter + 1;
                            end if;
                        when ST_MAIN_YELLOW =>
                            if mode_reg = '0' and time_counter < 1 then
                                time_counter <= time_counter + 1;
                            end if;
                        when ST_SEC_GREEN =>
                            if mode_reg = '0' and sec_green_counter < 5 then
                                sec_green_counter <= sec_green_counter + 1;
                            end if;
                        when ST_SEC_YELLOW =>
                            if mode_reg = '0' and time_counter < 1 then
                                time_counter <= time_counter + 1;
                            end if;
                        when others => null;
                    end case;
                end if;
                
                if current_state /= next_state then
                    if next_state = ST_MAIN_GREEN or next_state = ST_MAIN_GREEN_BLINK or 
                       next_state = ST_MAIN_YELLOW or next_state = ST_SEC_YELLOW then
                        time_counter <= 0;
                    end if;
                    if next_state = ST_SEC_GREEN then
                        sec_green_counter <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(current_state, mode_reg, time_counter, sec_green_counter, 
             manual_next_edge, CAR_SENSOR, tick_1hz)
    begin
        next_state <= current_state;
        
        case current_state is
            when ST_MAIN_GREEN =>
                if mode_reg = '0' then
                    if tick_1hz = '1' and time_counter = 9 then
                        next_state <= ST_MAIN_GREEN_BLINK;
                    end if;
                else
                    if manual_next_edge = '1' then
                        next_state <= ST_MAIN_YELLOW;
                    end if;
                end if;
                
            when ST_MAIN_GREEN_BLINK =>
                if mode_reg = '0' then
                    if tick_1hz = '1' and time_counter = 2 then
                        next_state <= ST_MAIN_YELLOW;
                    end if;
                else
                    if manual_next_edge = '1' then
                        next_state <= ST_MAIN_YELLOW;
                    end if;
                end if;
                
            when ST_MAIN_YELLOW =>
                if mode_reg = '0' then
                    if tick_1hz = '1' and time_counter = 1 then
                        next_state <= ST_SEC_GREEN;
                    end if;
                else
                    if manual_next_edge = '1' then
                        next_state <= ST_SEC_GREEN;
                    end if;
                end if;
                
            when ST_SEC_GREEN =>
                if mode_reg = '0' then
                    if tick_1hz = '1' then
                        if sec_green_counter >= 2 then
                            if CAR_SENSOR = '0' then
                                next_state <= ST_SEC_YELLOW;
                            elsif sec_green_counter >= 5 then
                                next_state <= ST_SEC_YELLOW;
                            end if;
                        end if;
                    end if;
                else
                    if manual_next_edge = '1' then
                        next_state <= ST_SEC_YELLOW;
                    end if;
                end if;
                
            when ST_SEC_YELLOW =>
                if mode_reg = '0' then
                    if tick_1hz = '1' and time_counter = 1 then
                        next_state <= ST_MAIN_GREEN;
                    end if;
                else
                    if manual_next_edge = '1' then
                        next_state <= ST_MAIN_GREEN;
                    end if;
                end if;
                
            when others =>
                next_state <= ST_MAIN_GREEN;
        end case;
    end process;
    
    process(current_state, blink_state)
    begin
        main_red_int <= '1';
        main_yellow_int <= '0';
        main_green_int <= '0';
        sec_red_int <= '1';
        sec_yellow_int <= '0';
        sec_green_int <= '0';
        
        case current_state is
            when ST_MAIN_GREEN =>
                main_red_int <= '0';
                main_green_int <= '1';
                sec_red_int <= '1';
                
            when ST_MAIN_GREEN_BLINK =>
                main_red_int <= '0';
                main_green_int <= blink_state;
                sec_red_int <= '1';
                
            when ST_MAIN_YELLOW =>
                main_red_int <= '0';
                main_yellow_int <= '1';
                sec_red_int <= '1';
                
            when ST_SEC_GREEN =>
                main_red_int <= '1';
                sec_red_int <= '0';
                sec_green_int <= '1';
                
            when ST_SEC_YELLOW =>
                main_red_int <= '1';
                sec_red_int <= '0';
                sec_yellow_int <= '1';
        end case;
    end process;
    
end Behavioral;