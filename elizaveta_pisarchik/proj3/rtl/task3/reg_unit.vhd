library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit is
    generic (N : integer := 34);
    port (   
        CLK : in  std_logic;  -- system clock, rising edge
        RST : in  std_logic; -- syncronous reset, active hight
        EN : in  std_logic; -- enable, active hight
        Din : in  std_logic_vector(N-1 downto 0); -- input data
        Dout : out std_logic_vector(N-1 downto 0) -- output data
    );
end reg_unit;

architecture rtl of reg_unit is
signal reg_data : std_logic_vector(N-1 downto 0) := (others => '0');
begin
    P0: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                reg_data <= (others => '0');
            elsif EN = '1' then
                reg_data <= Din;
            end if;
        end if;
    end process;
    Dout <= reg_data;
end rtl;