----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2026 17:44:56
-- Design Name: 
-- Module Name: task7 - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity REGFILE2R1W is
    Generic ( DATA_WIDTH : integer := 16;
              ADDR_WIDTH : natural := 5 );
    Port ( CLR  : in  std_logic;
           CLK    : in  std_logic;
           W_EN    : in  std_logic;
           W_ADDR    : in  std_logic_vector ( ADDR_WIDTH-1 downto 0 );
           W_DATA  : in  std_logic_vector ( DATA_WIDTH-1 downto 0 );
           R_ADDR_0   : in  std_logic_vector ( ADDR_WIDTH-1 downto 0 );
           R_ADDR_1   : in  std_logic_vector ( ADDR_WIDTH-1 downto 0 );
           R_DATA_0 : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
           R_DATA_1 : out std_logic_vector ( DATA_WIDTH-1 downto 0 ) );
End REGFILE2R1W;


Architecture Behavioral of REGFILE2R1W is
constant M : integer := 2**ADDR_WIDTH;
constant ZEROS : std_logic_vector( DATA_WIDTH-1 downto 0 ) := ( others => '0' );
subtype t_reg_word is std_logic_vector( DATA_WIDTH-1 downto 0 );
type t_reg_file is array ( 0 to M-1 ) of t_reg_word;
signal REG_FILE : t_reg_file;
signal write_adr : integer range 0 to M-1;
signal read_adr1 : integer range 0 to M-1;
signal read_adr0 : integer range 0 to M-1;


Begin
--    write_adr <= to_integer( unsigned(W_ADDR) );
--    read_adr0 <= to_integer( unsigned(R_ADDR_0) );
--    read_adr1 <= to_integer( unsigned(R_ADDR_1) );
  
    PWRITE: process ( CLR, CLK, W_DATA, W_EN )
    begin
        if CLR = '1' then
            for i in 0 to M-1 loop
                REG_FILE( i ) <= ZEROS;
            end loop;
        elsif rising_edge( CLK ) then
            if W_EN = '1' then
--                REG_FILE( write_adr ) <= W_DATA;
                  REG_FILE( to_integer( unsigned(W_ADDR) ) ) <= W_DATA;
            end if;
        end if;
    end process PWRITE;
    
--    R_DATA_0 <= REG_FILE( read_adr0 );
--    R_DATA_1 <= REG_FILE( read_adr1 );
--    R_DATA_0 <= REG_FILE( to_integer( unsigned(R_ADDR_0) ) );
--    R_DATA_1 <= REG_FILE( to_integer( unsigned(R_ADDR_1) ) );    
    R_DATA_0 <= W_DATA when ((W_ADDR = R_ADDR_0) and (W_EN = '1')) else  REG_FILE( to_integer( unsigned(R_ADDR_0) ) );
    R_DATA_1 <= W_DATA when ((W_ADDR = R_ADDR_1) and (W_EN = '1')) else  REG_FILE( to_integer( unsigned(R_ADDR_1) ) );

End Behavioral;

