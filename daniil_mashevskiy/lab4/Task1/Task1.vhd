library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task1 is
    Port ( CLK : in STD_LOGIC;      
           RST : in STD_LOGIC;      
           EN  : in STD_LOGIC;     
           Q   : out STD_LOGIC_VECTOR (2 downto 0)
    );
end Task1;

architecture Behavioral of Task1 is
    type t_state is (A, B1, C1, D, C2, B2, E, F);
    signal current_state, next_state : t_state;
    
    constant COUNTER_MAX : integer := 100_000_000;
    signal counter : integer range 0 to COUNTER_MAX - 1 := 0;
    signal tick_1hz : STD_LOGIC := '0';
    
    signal rst_reg : STD_LOGIC := '0';
    
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if counter = COUNTER_MAX - 1 then
                counter <= 0;
                tick_1hz <= '1';
            else
                counter <= counter + 1;
                tick_1hz <= '0';
            end if;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            rst_reg <= RST;
        end if;
    end process;
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if tick_1hz = '1' then
                if rst_reg = '1' then
                    current_state <= A;
                elsif EN = '1' then
                    current_state <= next_state;
                end if;
            end if;
        end if;
    end process;

    process(current_state)
    begin
        case current_state is
            when A  => next_state <= B1;
            when B1 => next_state <= C1;
            when C1 => next_state <= D;
            when D  => next_state <= C2;
            when C2 => next_state <= B2;
            when B2 => next_state <= E;
            when E  => next_state <= F;
            when F  => next_state <= A;
            when others => next_state <= A;
        end case;
    end process;
    
    process(current_state)
    begin
        case current_state is
            when A  => Q <= "000";
            when B1 => Q <= "001";
            when B2 => Q <= "001";
            when C1 => Q <= "010";
            when C2 => Q <= "010";
            when D  => Q <= "011";
            when E  => Q <= "100";
            when F  => Q <= "101";
            when others => Q <= "000";
        end case;
    end process;
    
end Behavioral;