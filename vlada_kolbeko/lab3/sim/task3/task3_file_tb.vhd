library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_file_TB is
end reg_file_TB;

architecture Behavioral of reg_file_TB is
    constant M       :   natural := 4;
    constant N       :   natural := 4;
    constant A       :   natural := 2; 
    constant T       :   time := 20 ns;
    
    signal CLK, INIT, WE, OE_N :   std_logic;
    signal WA, RA              :   std_logic_vector(1 downto 0);
    signal WDP                 :   std_logic_vector(N - 1 downto 0);
    signal RDP                 :   std_logic_vector(N - 1 downto 0);
    
    component reg_file is
        generic (
            M   : natural   := 4;
            N   : natural   := 4;
            A   : natural   := 2
        );
        port (
            INIT    : in    std_logic;
            WE      : in    std_logic;
            CLK     : in    std_logic;
            OE_N    : in    std_logic;
            WA      : in    std_logic_vector(A - 1 downto 0);
            WDP     : in    std_logic_vector(N - 1 downto 0);
            RA      : in    std_logic_vector(A - 1 downto 0);
            RDP     : out   std_logic_vector(N - 1 downto 0)
        );
    end component;

begin
    UUT: reg_file 
        generic map (
            M => M,
            N => N,
            A => A
        )
        port map (
            INIT => INIT,
            WE   => WE,
            CLK  => CLK,
            OE_N => OE_N,
            WA   => WA,
            WDP  => WDP,
            RA   => RA,
            RDP  => RDP
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
        report "reg_file simulation started" 
        severity note;
        
        INIT <= '1';
        WE <= '0';
        OE_N <= '0';
        WA <= "00";
        RA <= "00";
        WDP <= X"F";
        wait for T;
        
        RA <= "11";
        assert (RDP = X"0")
            report "initial reset failed"
            severity error;
            
        INIT <= '0';
        wait for T;
            
        WE <= '1';
        WA <= "01";
        WDP <= X"5";
        wait for T;
        
        WE <= '1';
        WA <= "11";
        WDP <= X"A";
        wait for T;
        
        WE <= '0';
        RA <= "01";
        wait for T;
        
        assert (RDP = X"5")
            report "read Reg 1 failed"
            severity error;
            
        RA <= "11";
        wait for T;
        
        assert (RDP = X"A")
            report "read Reg 3 failed"
            severity error;

        WE <= '0';
        WA <= "01";
        WDP <= X"F"; 
        wait for T;
        
        RA <= "01";
        assert (RDP = X"5")
            report "store mode failed (data changed when WE = 0)"
            severity error;

        OE_N <= '1';
        wait for T;
        wait for 1 ns;
        assert (RDP = (RDP'range => 'Z'))
            report "OE_N failed: RDP is not high-impedance (Z) when OE_N = '1'"
            severity error;
            
        OE_N <= '0';
        wait for T;
        wait for 1 ns;
        assert (RDP = X"A")
            report "OE_N failed: RDP did not return to valid data when OE_N = '0'"
            severity error;
        
        WE <= '0';
        WA <= "01";
        WDP <= X"F"; 
        wait for T;
                    
        RA <= "01";
        assert (RDP = X"5")
            report "store mode failed (data changed when WE = 0)"
            severity error;
            
        INIT <= '1';
        WE <= '1';
        WA <= "11";
        WDP <= X"7";
        wait for T;
                    
        RA <= "11";
        assert (RDP = X"0")
            report "INIT priority failed"
            severity error;
            
        report "reg_file simulation finished" 
        severity note;
                    
        wait;
    end process Sim;
end Behavioral;