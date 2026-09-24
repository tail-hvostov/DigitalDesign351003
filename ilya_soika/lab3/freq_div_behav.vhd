library ieee;
use ieee.std_logic_1164.all;

entity freq_div_behav is
    generic (K: natural := 10);
    port (
        CLK: in std_logic; 
        RST: in std_logic; 
        EN: in std_logic; 
        Q: out std_logic 
    );
end freq_div_behav;

architecture behavioural of freq_div_behav is
    signal counter: natural range 0 to (K/2 - 1);
    signal q_int: std_logic;
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter <= 0;
                q_int <= '0';
            elsif EN = '1' then
                if counter = (K/2 - 1) then
                    counter <= 0;
                    q_int <= not q_int;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    Q <= q_int;
end behavioural;