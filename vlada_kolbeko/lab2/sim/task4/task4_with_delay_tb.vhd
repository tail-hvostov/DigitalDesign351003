library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COMP3_D_TB is
end entity COMP3_D_TB;

architecture Behavioral of COMP3_D_TB is
    constant T          :   time := 400 ns;
    constant N          :   integer := 3;
    
    signal sw_i, led_o  :   std_logic_vector(15 downto 0);
    signal Y            :   std_logic_vector(2 downto 0);
    
    signal A, B         :   integer range 0 to 7;
    
    component COMP3_D is
        port (
            sw_i    : in    std_logic_vector(15 downto 0);
            led_o   : out   std_logic_vector(15 downto 0)
        );
    end component;
begin
    UUT: COMP3_D port map (
        sw_i => sw_i,
        led_o => led_o
    );
    
    sw_i <= 
        (15 downto 6 => '0') 
        & std_logic_vector(TO_UNSIGNED(B, N)) 
        & std_logic_vector(TO_UNSIGNED(A, N));
    Y <= led_o(2 downto 0);
    
    Sim: process
    begin
        report "Simulation started" severity note;

        A <= 0; B <= 0; wait for T;
        assert (Y = "100") 
            report "Comparison of A = 0 and B = 0 is incorrect" 
            severity error;
        
        A <= 1; wait for T;
        assert (Y = "010")
            report "Comparison of A = 1 and B = 0 is incorrect"
            severity error;
            
        A <= 0; B <= 1; wait for T;
        assert (Y = "001")
            report "Comparison of A = 0 and B = 1 is incorrect"
            severity error;
            
        A <= 3; B <= 3; wait for T;
        assert (Y = "100")
            report "Comparison of A = 3 and B = 3 is incorrect"
            severity error;
            
        B <= 2; wait for T;
        assert (Y = "010")
            report "Comparison of A = 3 and B = 2 is incorrect"
            severity error;
            
        A <= 2; B <= 3; wait for T;
        assert (Y = "001")
            report "Comparison of A = 2 and B = 3 is incorrect"
            severity error;
        
        A <= 7; B <= 7; wait for T;
        assert (Y = "100")
            report "Comparison of A = 7 and B = 7 is incorrect"
            severity error;
            
        B <= 5; wait for T;
        assert (Y = "010")
            report "Comparison of A = 7 and B = 5 is incorrect"
            severity error;
            
        A <= 4; B <= 6; wait for T;
        assert (Y = "001")
            report "Comparison of A = 4 and B = 6 is incorrect"
            severity error;
            
        report "Simulation ended successfully" severity note;
    end process Sim;
end Behavioral;