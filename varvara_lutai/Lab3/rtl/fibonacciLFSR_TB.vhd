----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2026 23:52:43
-- Design Name: 
-- Module Name: fibonacciLFSR_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fibonacciLFSR_TB is
--  Port ( );
end fibonacciLFSR_TB;

architecture Behavioral of fibonacciLFSR_TB is
component LFSR_Fibonacci is
Generic (N : natural := 8);
Port ( 
    CLK: in std_logic;
    CLR: in std_logic; 
    EN: in std_logic;
    Dout: out std_logic_vector (N-1 downto 0)
);
end component LFSR_Fibonacci;
component universal_counter is
  Generic (N : natural := 8);
  Port ( 
    CLK: in std_logic;
    CLR: in std_logic; 
    EN: in std_logic;
    MODE: in std_logic_vector (1 downto 0);
    LOAD: in std_logic;
    Din: in std_logic_vector (N-1 downto 0);
    Dout: out std_logic_vector (N-1 downto 0)
  );
end component universal_counter;

signal CLK : std_logic := '0';
signal CLR, EN, load : std_logic;
signal din, Q, REF : std_logic_vector ( 7 downto 0 );
signal mode : std_logic_vector ( 1 downto 0 );


constant HPeriod : time := 50 ns;
constant Period : time := 2*HPeriod;
constant N : integer := 8;
constant L : integer := 2**N-1;

subtype tv is integer range 0 to 2;
type t_test_array is array( 1 to L ) of tv;
signal TEST_ARRAY : t_test_array := ( others => 0 );
--signal ADR : integer range 1 to L; 

begin
    CLK <= not CLK  after HPeriod;
    UC: universal_counter port map ( CLR => CLR, CLK => CLK, EN => EN, MODE => mode, LOAD => load, Din => din, Dout => Q);
    --UUT: LFSR_Fibonacci port map ( CLR => CLR, CLK => CLK, EN => EN, Dout => Q);
    Main: process
    begin
        CLR <= '0'; EN <= '0';
        wait for Period;
        CLR <= '1'; wait for Period;
        CLR <= '0'; wait for Period;
--        mode <= "01";
--        load <= '1';
--        din <= "10101010";
--        wait for Period;
        EN  <= '1';
        wait for Period;
        CLR <= '1'; EN <= '0';
        wait for Period;
        CLR <= '0'; EN <= '1';
        mode <= "00";
        wait for Period;
        REF <= Q;
        wait for L*Period;  
        EN  <= '0'; wait for Period;
        assert Q=REF 
          report "Erroneous Orbit Length" severity error;
        for i in 1 to L loop
            assert TEST_ARRAY( i ) = 1
               report "M-sequence was not generated!" severity failure;
        end loop;
        report "End of Simulation" severity failure; 
    end process Main;
    Monitor: process ( EN, CLK, Q )
    variable ADR : integer range 1 to L; 
    variable L : line;
        begin
            if mode = "00" then
                if EN = '1' then
                    if falling_edge( CLK ) then  
                        ADR := to_integer(unsigned( Q ) );
                        TEST_ARRAY( ADR ) <= TEST_ARRAY( ADR ) + 1;
                        --report bin(to_integer(unsigned(Q(7 downto 4))));
                    end if;
                end if;
            end if;   
        end process Monitor;  


end Behavioral;
