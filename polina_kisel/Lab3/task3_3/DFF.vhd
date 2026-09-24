library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is
  Port (
  D, CLK, CLR: in std_logic;
  Q: out std_logic
   );
end DFF;

architecture Behavioral of DFF is

begin

UP_DFF:process (CLK)
begin
if CLR = '0' then
     Q <= '0';
elsif rising_edge(CLK) then
     Q <= D; 
end if;
end process UP_DFF;

end Behavioral;
