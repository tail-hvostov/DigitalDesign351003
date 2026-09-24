library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testTop5 is
    port (
        sw : in std_logic_vector(15 downto 0);
        led : out std_logic_vector(15 downto 0)
    );
end testTop5;

architecture rtl of testTop5 is
    signal result: std_logic_vector(5 downto 0);
    signal num1, num2 : std_logic_vector(5 downto 0);
begin
    -- nand, >>2, -, xor
    num1 <= sw(15 downto 10);
    num2 <= sw(9 downto 4);
    process(sw)
    begin
        if (sw(0) = '1') then
            result <= num1 nand num2;
        elsif (sw(1) = '1') then
            result <= num1;
            result(5 downto 4) <= "00";
            result(3 downto 0) <= num1(5 downto 2);
        elsif (sw(2) = '1') then
            result <= std_logic_vector(unsigned(num1) - unsigned(num2));   
        elsif (sw(3) = '1') then
            result <= num1 xor num2;
        else 
            result <= "000000";
        end if;
    end process;
    led(5 downto 0) <= result;
end rtl;