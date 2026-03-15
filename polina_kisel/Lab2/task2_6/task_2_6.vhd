Library IEEE;
Use IEEE.STD_LOGIC_1164.all;

Entity task_2_6 is
    Port(
       S_in   : in  std_logic; -- Сигнал установки (Set)
       R_in   : in  std_logic; -- Сигнал сброса (Reset)
       Q_out  : out std_logic;
       nQ_out : out std_logic
    );
End task_2_6;

Architecture structural of task_2_6 is

signal s0, s1 : std_logic;
attribute keep : string;
attribute keep of s0, s1 : signal is "true";

Begin
    P1: process (S_in, s1)
    Begin 
        s0 <= S_in nor s1;
    end process P1;
    
    P2: process (R_in, s0)
    Begin 
        s1 <= R_in nor s0;
    end process P2;
    
    Q_out <= s1;
    nQ_out <= s0;
    
End structural;