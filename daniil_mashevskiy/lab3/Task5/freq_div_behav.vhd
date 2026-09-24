library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_div_behav is
    Generic (
        K         : positive := 67108864;  
        CNT_WIDTH : natural  := 26           
    );
    Port (
        CLK : in  std_logic;
        RST : in  std_logic;
        EN  : in  std_logic;
        Q   : out std_logic
    );
end freq_div_behav;

architecture rtl of freq_div_behav is
    signal count : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                count <= (others => '0');
            elsif EN = '1' then
                if count = K-1 then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    Q <= count(CNT_WIDTH-1);

end rtl;