library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller is
    Generic ( CNT_WIDTH : natural := 8 );
    Port (
        CLK  : in  std_logic;
        CLR  : in  std_logic;
        EN   : in  std_logic;
        FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
        Q    : out std_logic
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal counter : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
begin

    process(CLK, CLR)
    begin
        if CLR = '1' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    Q <= '1' when counter < unsigned(FILL) else '0';

end Behavioral;