library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter_TB is
end universal_counter_TB;

architecture Behavioral of universal_counter_TB is
    constant N      : natural           := 8;
    constant SEQ    : std_logic_vector  := X"B5";
    constant T      : time              := 20 ns;

    signal CLK      : std_logic;
    signal CLR      : std_logic;
    signal EN       : std_logic;
    signal MODE     : std_logic_vector(1 downto 0);
    signal LOAD     : std_logic;
    signal D_IN     : std_logic_vector(N - 1 downto 0);
    signal D_OUT    : std_logic_vector(N - 1 downto 0);

    component universal_counter is
        generic ( 
            N : natural := 8 
        );
        port (
            CLK     : in    std_logic;
            CLR     : in    std_logic;
            EN      : in    std_logic;
            MODE    : in    std_logic_vector(1 downto 0);
            LOAD    : in    std_logic;
            D_IN    : in    std_logic_vector(N - 1 downto 0);
            D_OUT   : out   std_logic_vector(N - 1 downto 0)
        );
    end component;

begin
    UUT: universal_counter
        generic map ( 
            N => N 
        )
        port map (
            CLK   => CLK,
            CLR   => CLR,
            EN    => EN,
            MODE  => MODE,
            LOAD  => LOAD,
            D_IN  => D_IN,
            D_OUT => D_OUT
        );

    ClkGen: process
    begin
        CLK <= '0'; 
        wait for (T / 2);
        
        CLK <= '1'; 
        wait for (T / 2);
    end process ClkGen;

    Sim: process
    begin
        report "universal_counter simulation started" 
        severity note;
    
        CLR  <= '1';
        EN   <= '0';
        MODE <= "00";
        LOAD <= '0';
        D_IN <= SEQ;
        wait for 2*T;
        
        assert (D_OUT = (D_OUT'range => '0'))
            report "initial asynchronous clear failed" 
            severity error;
                
        CLR <= '0';
        EN  <= '1'; 
        LOAD <= '1';
        wait for T;
        
        assert (D_OUT = SEQ)
            report "parallel load failed" 
            severity error;

        LOAD <= '0';
        MODE <= "11";
        wait for 5*T;
        
        report "mode 11 operation completed" 
        severity note;

        EN <= '0';
        wait for 2*T;
        
        report "data storage (EN=0) checked" 
        severity note;
        
        CLR <= '1';
        wait for T;
        
        assert (D_OUT = (D_OUT'range => '0'))
            report "clear during operation failed" 
            severity error;
        
        report "universal_counter simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;