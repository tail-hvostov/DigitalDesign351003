library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_div_behav is
    Generic (K : positive := 4);
    Port (
        CLK: in std_logic;
        RST: in std_logic;
        EN: in std_logic;
        Q: out std_logic        
    );
end freq_div_behav;

architecture rtl of freq_div_behav is
    signal count: std_logic_vector(K - 1 downto 0);
    signal output: std_logic := '0';
begin
    COUNT_PROC: process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                count <= (others => '0');
            elsif (EN = '1') then
                count <= std_logic_vector(to_unsigned(to_integer(unsigned(count)) + 1, K));
            end if;
        end if;
    end process;
    
    output <= count(K - 1);

    Q <= output;
end rtl;
