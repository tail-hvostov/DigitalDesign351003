library ieee;
use ieee.std_logic_1164.all;

entity testTop3 is 
    port (
    led0, led1, led2, led3, led4, led5, led6, led7 : out std_logic;
    led8, led9, led10, led11, led12, led13, led14, led15 : out std_logic;
    sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7 : in std_logic;
    sw8, sw9, sw10, sw11, sw12, sw13, sw14, sw15 : in std_logic
    );
end testTop3;

architecture rtl of testTop3 is
    signal isRightNumber: std_logic;
begin
    -- I = AA = 1010 1010
    --   xor    0111 1010
    -- J = D0 = 1101 0000
    isRightNumber <= '1' when (sw0 = '0' and sw1 = '1' and 
                               sw2 = '0' and sw3 = '1' and
                               sw4 = '1' and sw5 = '1' and
                               sw6 = '1' and sw7 = '0') else '0';
    process(isRightNumber)
        begin
        if isRightNumber = '1' then
            led15 <= '0'; led14 <= '0'; led13 <= '0'; led12 <= '0'; 
            led11 <= '0'; led10 <= '0'; led9 <= '0'; led8 <= '0'; 
            led7 <= '1'; led6 <= '1'; led5 <= '0'; led4 <= '1'; 
            led3 <= '0'; led2 <= '0'; led1 <= '0'; led0 <= '0'; 
        else
            led15 <= '0'; led14 <= '0'; led13 <= '0'; led12 <= '0'; 
            led11 <= '0'; led10 <= '0'; led9 <= '0'; led8 <= '0'; 
            led7 <= '0'; led6 <= '0'; led5 <= '0'; led4 <= '0'; 
            led3 <= '0'; led2 <= '0'; led1 <= '0'; led0 <= '0'; 
        end if;
    end process;
    
end rtl;