library IEEE;
Use IEEE.STD_LOGIC_1164.all;

Entity task_2_5 is
    Port(
       Q_out : out std_logic;
       nQ_out : out std_logic
    );
End task_2_5;

Architecture structural of task_2_5 is

    signal s0, s1 : std_logic;

    attribute keep : string;
    attribute keep of s0, s1 : signal is "true";
    
Begin
    s0 <= not s1;
    s1 <= not s0;
    Q_out <= s0;
    nQ_out <= s1;
    
End structural;