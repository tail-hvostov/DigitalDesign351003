library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task5TB is
end Task5TB;

architecture sim of Task5TB is
    component universal_counter
        generic ( N : integer range 1 to 64 := 8 );
        port (
            CLK  : in std_logic;
            CLR  : in std_logic;
            EN   : in std_logic;
            MODE : in std_logic_vector (1 downto 0);
            LOAD : in std_logic;
            Din  : in std_logic_vector (N-1 downto 0);
            Dout : out std_logic_vector (N-1 downto 0)
        );
    end component;
    constant N : integer := 8;
    constant T : time := 10 ns;
    signal CLK  : std_logic := '0';
    signal CLR  : std_logic := '0';
    signal EN   : std_logic := '0';
    signal MODE : std_logic_vector(1 downto 0) := "00";
    signal LOAD : std_logic := '0';
    signal Din  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout : std_logic_vector(N-1 downto 0);
begin
    DUT: universal_counter
        generic map (N => N)
        port map (
            CLK => CLK, CLR => CLR, EN => EN,
            MODE => MODE, LOAD => LOAD, Din => Din, Dout => Dout
        );

    CLK_PROCESS: process
    begin
        CLK <= '0'; wait for T/2;
        CLK <= '1'; wait for T/2;
    end process;

    TESTING: process
    begin
        MODE <= "00";
        CLR <= '1'; 
        wait for 5 ns;
        assert (Dout = "00000001") report "ASYNC RESET ONE-HOT FAIL" severity error;
        
        CLR <= '0'; 
        wait for T/2;

        EN <= '1';
        wait for T;
        assert (Dout = "00000010") report "ONE-HOT SHIFT FAIL" severity error;
        
        wait for T * (N-2);

        MODE <= "01";
        CLR <= '1'; 
        wait for 5 ns;
        assert (Dout = "11111110") report "ASYNC RESET ONE-COLD FAIL" severity error;
        
        CLR <= '0'; 
        wait for T;

        MODE <= "10";
        CLR <= '1'; 
        LOAD <= '1';
        Din <= "10110000";
        wait for T;
        assert (Dout = "10110000") report "LOAD DATA FAIL" severity error;

        CLR <= '0'; 
        wait for T;
        assert (Dout = "01100001") report "RING SHIFT FAIL" severity error;

        EN <= '0';
        wait for T * 2;
        assert (Dout = "01100001") report "ENABLE PRIORITY FAIL" severity error;

        CLR <= '0';
        report "ALL TESTS PASSED" severity note;
        wait;
    end process;
end sim;