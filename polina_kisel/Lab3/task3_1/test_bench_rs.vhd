Library IEEE;
Use IEEE.STD_LOGIC_1164.all;

Entity tb_task3_1_rs is
End tb_task3_1_rs;

Architecture behavior of tb_task3_1_rs is
    Component task3_1_rs is
        Port(
           S_in   : in  std_logic;
           R_in   : in  std_logic;
           Q_out  : out std_logic;
           nQ_out : out std_logic
        );
    End Component;

    signal S_tb   : std_logic := '0';
    signal R_tb   : std_logic := '0';
    signal Q_tb   : std_logic;
    signal nQ_tb  : std_logic;
    

Begin
    RS_Nand_with_NOT: task3_1_rs
        Port map (
            S_in   => S_tb,
            R_in   => R_tb,
            Q_out  => Q_tb,
            nQ_out => nQ_tb
        );

    sim_process: process
    begin
    
        wait for 20 ns;

        -- Reset
        S_tb <= '0'; 
        R_tb <= '1';
        wait for 20 ns;
        assert (Q_tb = '1' and nQ_tb = '0')
        report "Reset failed: Q should be 0, nQ should be 1"
        severity error;

        -- Store после Reset
        S_tb <= '0'; 
        R_tb <= '0';
        wait for 20 ns;
        assert (Q_tb = '1' and nQ_tb = '0')
        report "Store after Reset failed"
        severity error;

        -- Set
        S_tb <= '1'; 
        R_tb <= '0';
        wait for 20 ns;
        assert (Q_tb = '0' and nQ_tb = '1')
        report "Set failed: Q should be 1, nQ should be 0"
        severity error;

        -- Store после Set
        S_tb <= '0'; 
        R_tb <= '0';
        wait for 20 ns;
        assert (Q_tb = '0' and nQ_tb = '1')
        report "Store after Set failed"
        severity error;
        
        -- запрещенка
         S_tb <= '1'; 
         R_tb <= '1';
         wait for 20 ns;
         assert (Q_tb = '1' and nQ_tb = '1')
         report " forbidden failed"
         severity error;
         
         wait for 20 ns;
         
          -- метастабильность
          S_tb <= '0'; 
          R_tb <= '0';
          wait for 20 ns;
         

        wait;
    end process sim_process;

End behavior;