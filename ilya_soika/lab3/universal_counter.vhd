library ieee;
use ieee.std_logic_1164.all;

entity universal_counter is
    generic (N: natural := 16);
    port (
        CLK: in  std_logic;
        CLR: in  std_logic;
        EN: in  std_logic;
        MODE: in  std_logic_vector(2 downto 0);
        LOAD: in  std_logic;
        Din: in  std_logic_vector(N-1 downto 0);
        Dout: out std_logic_vector(N-1 downto 0)
    );
end universal_counter;

architecture Behavioural of universal_counter is
    signal cur : std_logic_vector(N-1 downto 0);
    signal nxt : std_logic_vector(N-1 downto 0);    
begin
    -- x16+x12+x5+1
    process(cur, EN, MODE, LOAD, Din)
        variable feedback : std_logic;
    begin
        nxt <= cur;
        if LOAD = '1' then
            nxt <= Din;
        elsif EN = '1' and MODE = "000" then
            feedback := cur(15) xor cur(11) xor cur(4);
            nxt(0) <= feedback xor Din(0);
            nxt(N-1 downto 1) <= cur(N-2 downto 0);
        end if;
    end process;
    
    process(CLK, CLR)
    begin
        if CLR = '1' then
            cur <= (others => '0');
        elsif rising_edge(CLK) then
            cur <= nxt;
        end if;
    end process;
    Dout <= cur;
end Behavioural;
