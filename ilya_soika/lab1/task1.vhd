library ieee;
use ieee.std_logic_1164.all;

entity testTop is 
port (
    led0 : out std_logic;
    led1 : out std_logic;
    led2 : out std_logic;
    led3 : out std_logic;
    led4 : out std_logic;
    led5 : out std_logic;
    led6 : out std_logic;
    led7 : out std_logic;
    led8 : out std_logic;
    led9 : out std_logic;
    led10 : out std_logic;
    led11 : out std_logic;
    led12 : out std_logic;
    led13 : out std_logic;
    led14 : out std_logic;
    led15 : out std_logic
    );
end testTop;

architecture rtl of testTop is
begin
    -- 5C6F = 0101 1100 0110 1111 
    led0 <= '1';
    led1 <= '1';
    led2 <= '1';
    led3 <= '1';
    
    led4 <= '0';
    led5 <= '1';
    led6 <= '1';
    led7 <= '0';
    
    led8 <= '0';
    led9 <= '0';
    led10 <= '1';
    led11 <= '1';
    
    led12 <= '1';
    led13 <= '0';
    led14 <= '1';
    led15 <= '0';   
end rtl;