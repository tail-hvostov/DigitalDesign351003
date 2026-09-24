Library IEEE;
Use IEEE.STD_LOGIC_1164.all;

Entity task3_1_rs is
    Port(
       S_in   : in  std_logic; -- Сигнал установки (Set)
       R_in   : in  std_logic; -- Сигнал сброса (Reset)
       Q_out  : out std_logic;
       nQ_out : out std_logic
    );
End task3_1_rs;

Architecture structural of task3_1_rs is

signal s0, s1 : std_logic;
attribute DONT_TOUCH : string;
attribute DONT_TOUCH of s0, s1 : signal is "true";

Begin
    P1: process (S_in, s1)
    Begin 
        s0 <= (not S_in) nand s1 after 2 ns;
    end process P1;
    
    P2: process (R_in, s0)    
    Begin 
        s1 <= (not R_in) nand s0 after 2 ns;
    end process P2;
    
    Q_out <= s1;
    nQ_out <= s0;
    
End structural;