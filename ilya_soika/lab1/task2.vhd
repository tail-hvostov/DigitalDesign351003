library ieee;
use ieee.std_logic_1164.all;

entity testTop2 is 
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
    led15 : out std_logic;
    sw0 : in std_logic;
    sw1 : in std_logic;
    sw2 : in std_logic;
    sw3 : in std_logic;
    sw4 : in std_logic;
    sw5 : in std_logic;
    sw6 : in std_logic;
    sw7 : in std_logic;
    sw8 : in std_logic;
    sw9 : in std_logic;
    sw10 : in std_logic;
    sw11 : in std_logic;
    sw12 : in std_logic;
    sw13 : in std_logic;
    sw14 : in std_logic;
    sw15 : in std_logic
    );
end testTop2;

architecture rtl of testTop2 is
begin 
    led0 <= sw0;
    led1 <= sw1;
    led2 <= sw2;
    led3 <= sw3;
    
    led4 <= sw4;
    led5 <= sw5;
    led6 <= sw6;
    led7 <= sw7;
    
    led8 <= sw8;
    led9 <= sw9;
    led10 <= sw10;
    led11 <= sw11;
    
    led12 <= sw12;
    led13 <= sw13;
    led14 <= sw14;
    led15 <= sw15;   
end rtl;