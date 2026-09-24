library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit_TB is
end reg_unit_TB;

architecture Behavioral of reg_unit_TB is
    constant N_TB       :   natural := 4; 
    constant T          :   time := 20 ns;
    
    signal CLK, RST, EN :   std_logic;
    signal D_IN         :   std_logic_vector(N_TB - 1 downto 0);
    signal D_OUT        :   std_logic_vector(N_TB-1 downto 0);
    
    component reg_unit is
        generic (
            N : natural := 34
        );
        port (
            CLK   : in    std_logic;
            RST   : in    std_logic;
            EN    : in    std_logic;
            D_IN  : in    std_logic_vector(N - 1 downto 0);
            D_OUT : out   std_logic_vector(N - 1 downto 0)
        );
    end component;

begin
    UUT: reg_unit 
        generic map (
            N => N_TB
        )
        port map (
            CLK  => CLK,
            RST  => RST,
            EN   => EN,
            D_IN  => D_IN,
            D_OUT => D_OUT
        );
    
    ClkGen: process
    begin
        CLK <= '0';
        wait for T / 2;
        
        CLK <= '1';
        wait for T / 2;
    end process ClkGen;
    
    Sim: process
    begin
        report "reg_unit simulation started" 
        severity note;
        
        RST <= '1';
        EN  <= '1';
        D_IN <= X"A";
        wait for T;  
        assert (D_OUT = X"0")
            report "initial synchronous reset failed"
            severity error;
            
        RST <= '0';
        wait for T;
            
        EN  <= '1';
        D_IN <= X"5";
        wait for T;
        assert (D_OUT = X"5")
            report "write data failed"
            severity error;
            
        EN  <= '0';
        D_IN <= X"F";
        wait for T;
        assert (D_OUT = X"5")
            report "store mode failed (data changed when EN = 0)"
            severity error;
            
        EN  <= '1';
        D_IN <= X"C";
        wait for T;
        assert (D_OUT = X"C")
            report "second write failed"
            severity error;
            
        RST <= '1';
        EN  <= '1';
        D_IN <= X"A";
        wait for T;
        assert (D_OUT = X"0")
            report "reset priority failed (reset should override EN/D_IN)"
            severity error;

        report "reg_unit simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;