library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller is
    Generic (
        CNT_WIDTH : natural := 8
    );
    Port (
        CLK  : in  std_logic;
        CLR  : in  std_logic;
        EN   : in  std_logic;
        FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
        Q    : out std_logic
    );
end pwm_controller;

architecture Behavioral of pwm_controller is

    constant MAX_CNT : unsigned(CNT_WIDTH-1 downto 0) := (others => '1');
    signal cnt : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
    signal pwm_out : std_logic := '0';

begin

    process(CLK, CLR)
    begin
        if CLR = '1' then
            cnt <= (others => '0');
            pwm_out <= '0';
        elsif rising_edge(CLK) then
            if EN = '1' then
                if cnt = MAX_CNT then
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
                
                if cnt < unsigned(FILL) then
                    pwm_out <= '1';
                else
                    pwm_out <= '0';
                end if;
            end if;
        end if;
    end process;

    Q <= pwm_out;

end Behavioral;