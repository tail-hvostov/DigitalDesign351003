library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder3to8 is
    Port ( sel : in  std_logic_vector(2 downto 0);
           m   : out std_logic_vector(7 downto 0) );
end decoder3to8;

architecture Behavioral of decoder3to8 is
begin
    process(sel)
    begin
        m <= (others => '0');   
        case sel is
            when "000" => m(0) <= '1';
            when "001" => m(1) <= '1';
            when "010" => m(2) <= '1';
            when "011" => m(3) <= '1';
            when "100" => m(4) <= '1';
            when "101" => m(5) <= '1';
            when "110" => m(6) <= '1';
            when "111" => m(7) <= '1';
            when others => null;
        end case;
    end process;
end Behavioral;