library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity universal_counter is
    Generic ( N : natural := 8 );
    Port (
        CLK  : in  std_logic;
        CLR  : in  std_logic;
        EN   : in  std_logic;
        MODE : in  std_logic_vector(1 downto 0);
        LOAD : in  std_logic;
        Din  : in  std_logic_vector(N-1 downto 0);
        Dout : out std_logic_vector(N-1 downto 0)
    );
end universal_counter;

architecture rtl of universal_counter is
    signal count : natural range 0 to 2**N - 1;
begin
    COUNT_PROC: process(CLK, CLR)
    begin
        if (CLR = '1') then 
            count <= 0;
        elsif (rising_edge(CLK)) then
            if (EN = '1') then
                case MODE is
                    when "00" =>      
                        count <= count + 1;
                    when "01" =>   
                        if (count = N - 2) then
                            count <= 0;
                        else
                            count <= count + 1;
                        end if;
                    when "10" =>       
                        if (LOAD = '1') then
                            count <= to_integer(unsigned(Din));
                        end if;
                    when others => 
                        count <= count;
                end case;
            end if;
        end if;
    end process;

    Dout <= std_logic_vector(to_unsigned(count, N));

end rtl;
