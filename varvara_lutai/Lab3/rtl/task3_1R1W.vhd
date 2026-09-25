----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 13:09:41
-- Design Name: 
-- Module Name: task3_1R1W - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
Generic(
M : integer := 4;
N : integer := 2
--M : integer;
--N : integer
);
Port (
RST  : in  std_logic;
CLK    : in  std_logic;
WA    : in  std_logic_vector ( M-1 downto 0);
WDP  : in  std_logic_vector ( N-1 downto 0 );
WE    : in  std_logic;
RE : in std_logic;
RA  : in  std_logic_vector ( M-1 downto 0 );
RDP : out std_logic_vector ( N-1 downto 0 )
);
end reg_file;

architecture Behavioral of reg_file is
component reg_unit is generic (N: natural); port (
CLK : in std_logic;
RST : in std_logic;
EN : in std_logic;
Din : in std_logic_vector (N-1 downto 0);  
Dout : out std_logic_vector (N-1 downto 0)
); end component;
subtype t_reg_word is std_logic_vector( N-1 downto 0 );
type t_reg_file is array ( 0 to M-1 ) of t_reg_word; -- 0 to M-1
signal REG_FILE_I, REG_FILE_O: t_reg_file;
--signal write_adr : integer range 0 to M-1;
--signal read_adr : integer range 0 to M-1; --0 to M-1

begin
    REGS: for i in 0 to M-1 generate --0 to M-1
        --REGUi0 : reg_unit generic map (N) port map (RST=> RST, CLK => CLK, EN => WE, Din => REG_FILE_I(i), Dout => REG_FILE_O(i));
        REGUi0 : reg_unit generic map (N) port map (RST=> RST, CLK => CLK, EN => WE, Din => REG_FILE_I(i), Dout => REG_FILE_O(i));
    end generate;
--    P0: process (WA, WDP)
--    variable write_adr: integer range 0 to M-1;
--    begin
--        write_adr := to_integer(unsigned(WA));
--        REG_FILE_I ( write_adr ) <= WDP;
--    end process;
--    read_adr <= to_integer(unsigned(RA));
--    RDP <= REG_FILE_O( read_adr ) when RE = '1';
    
--    P0: process (WA, WDP)
--    variable write_adr, read_adr: integer range 0 to M-1;
    
--    begin
--        write_adr := to_integer(unsigned(WA));
--        REG_FILE_I ( to_integer(unsigned(WA)) ) <= WDP;
--        read_adr := to_integer(unsigned(RA));
--        if RE = '1' then
--            RDP <= REG_FILE_O( read_adr );
--        end if;
--    end process;
    REG_FILE_I ( to_integer(unsigned(WA)) ) <= WDP;
    RDP <= REG_FILE_O( to_integer(unsigned(RA)) ) when RE = '1';
    
--    P1: process (RA, RE, REG_FILE_O)
--    variable read_adr: integer range 0 to M-1;
--    begin
--        read_adr := to_integer(unsigned(RA));
--        if RE = '1' then
--            RDP <= REG_FILE_O( read_adr );
--        end if;
--    end process;

end Behavioral;
