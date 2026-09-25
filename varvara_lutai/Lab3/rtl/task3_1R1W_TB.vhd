----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2026 21:12:43
-- Design Name: 
-- Module Name: task3_1R1W_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity task3_1R1W_TB is
--  Port ( );
end task3_1R1W_TB;

architecture Behavioral of task3_1R1W_TB is
component reg_file is
Generic(
M : integer := 4;
N : integer := 8
);
Port (
RST  : in  std_logic;
CLK    : in  std_logic;
WA    : in  std_logic_vector ( M-1 downto 0 );
WDP  : in  std_logic_vector ( N-1 downto 0 );
WE    : in  std_logic;
RE : in std_logic;
RA  : in  std_logic_vector ( M-1 downto 0 );
RDP : out std_logic_vector ( N-1 downto 0 )
);
end component;
signal reset, clock, enable, readEnable: std_logic;
signal wAddress, rAddress : std_logic_vector (3 downto 0);
--signal wAddress, rAddress : integer range 3 downto 0;
signal wDataPort, rDataPort : std_logic_vector (7 downto 0);
begin
    REGFILE: reg_file generic map (N => 8, M => 4) port map (RST => reset, CLK => clock, WA => wAddress, WDP => wDataPort, WE => enable, RA => rAddress, RE => readEnable, RDP => rDataPort);
    CLK_PROCESS: process
            constant T : time := 100 ns;
        begin
            clock <= '0';
            wait for 2*T;
            clock <= '1';
            wait for 2*T;
        end process;
    P0: process 
    constant T : time := 100 ns;
    begin
        --сброс
        wait for 20*T;
        reset <= '1';
        readEnable <= '1';
        
        --в регистр 3
        wait for 20*T;
        reset <= '0';
        enable <= '1';
        wAddress <= "0011";
        wDataPort <= "00001111"; -- 15
        rAddress <= "0011";    
           
        --запись в регистр 2
        wait for 20*T;
        reset <= '0';
        enable <= '1';
        wAddress <= "0010";
        wDataPort <= "00100000"; -- 32
        rAddress <= "0010";
        
        --в регистр 1
        wait for 20*T;
        reset <= '0';
        enable <= '1';
        wAddress <= "0001";
        wDataPort <= "00000101"; -- 5
        rAddress <= "0001";
        
        --в регистр 0
        wait for 20*T;
        reset <= '0';
        enable <= '1';
        wAddress <= "0000";
        wDataPort <= "00000111"; -- 7
        rAddress <= "0000";
        
--        wait for 20*T;
--        reset <= '0';
--        enable <= '1';
--        wAddress <= "0001";
--        wDataPort <= "00000101"; -- 5
--        rAddress <= "0001";
    end process P0;
end Behavioral;
