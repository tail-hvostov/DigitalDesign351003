----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2026 00:09:58
-- Design Name: 
-- Module Name: lfsr_fibonacci - Behavioral
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

entity LFSR_Fibonacci is
Generic (N : natural := 8);
Port ( 
    CLK: in std_logic;
    CLR: in std_logic; 
    EN: in std_logic;
    Dout: out std_logic_vector (N-1 downto 0)
);
end LFSR_Fibonacci;
architecture behavioral of LFSR_Fibonacci is
    signal cur_state, nxt_state: std_logic_vector (N-1 downto 0);
    constant POLY : std_logic_vector (7 downto 0) := "10111000";
    constant Ai : std_logic_vector (POLY'range) := POLY;
    signal d, d_new : std_logic_vector ( Ai'range );
    signal feedback : std_logic;
    constant SEED   : std_logic_vector ( Ai'range ) := (0 => '1', others => '0' );
begin
    d_new <= feedback & d( Ai'high downto 1 );
    SREG: process ( CLR, CLK, EN, d_new )
    begin
        if rising_edge( CLK ) then
            if CLR = '1' then
                d <= SEED;
            elsif EN = '1' then 
                d <= d_new;
            end if;
        end if;
    end process SREG;
    PFB: process ( d )
    variable vfb : std_logic;
    begin
        vfb := d( 0 );
        for i in 0 to Ai'high-1 loop
            if Ai( i ) = '1' then
                vfb := vfb xor d( i + 1 );
            end if;
        end loop PFB;
        feedback <= vfb;
    end process;
    Dout <= d;
    
end behavioral;
