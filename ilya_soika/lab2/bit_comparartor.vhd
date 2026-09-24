library ieee;
use ieee.std_logic_1164.all;

entity bit_comparator is
    port (
        bitA, bitB: in std_logic;
        prev_res: in std_logic_vector(1 downto 0);
        res: out std_logic_vector(1 downto 0)
    );
end bit_comparator;

architecture Behaviour of bit_comparator is
begin
    -- < - 10, = - 11, > - 01
    process(bitA, bitB, prev_res)
    begin
        if prev_res = "11" then      
            if (bitA = '0') and (bitB = '1') then
                res <= "10";         
            elsif (bitA = '1') and (bitB = '0') then
                res <= "01";         
            else
                res <= "11";         
            end if;
        else
            res <= prev_res;         
        end if;
    end process;
end Behaviour;
