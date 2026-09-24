library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Triggger is
    Port(
        D   : in  std_logic;
        CLK : in  std_logic;
        RST : in  std_logic;
        Q   : out std_logic
    );
end entity;

architecture Structural of Triggger is
    signal TMP : std_logic;
begin
    process(CLK, RST)
    begin 
        if RST = '1' then
            TMP <= '0';
        elsif rising_edge(CLK) then
            TMP <= D;
        end if;
    end process;
    Q <= TMP;
end architecture Structural;