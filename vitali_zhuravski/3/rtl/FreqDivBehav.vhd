----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2026 14:31:57
-- Design Name: 
-- Module Name: FreqDivBehav - Behavioral
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

entity FreqDivBehav is
    generic (
        K : natural := 10
    );
    port (
        CLK : in  std_logic;
        RST : in  std_logic;
        EN  : in  std_logic;
        Q   : out std_logic
    );
end FreqDivBehav;

architecture Behavioral of FreqDivBehav is
    constant KH : natural := K / 2;
    signal counter : natural;
    signal output : std_logic;
begin
    P0 : process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter <= 0;
            elsif EN = '1' then
                if counter = KH - 1 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    output <= '1' when (counter = (KH - 1)) else '0';
    
--    P0 : process(CLK)
--    begin
--        if rising_edge(CLK) then
--            if RST = '1' then
--                counter <= 0;
--                output <= '0';
--            elsif EN = '1' then
--                if counter = KH - 1 then
--                    counter <= 0;
--                    output <= not output;
--                else
--                    counter <= counter + 1;
--                end if;
--            end if;
--        end if;
--    end process;
    
    Q <= output;

end Behavioral;

--architecture Behavioral of FreqDivBehav is
--    constant KH : natural := K / 2;
--    signal counter : std_logic_vector(integer(ceil(log2(real(KH)))) downto 0);
--    signal output : std_logic;
--begin
--    P0 : process(CLK)
--        variable int_counter : integer;
--    begin
--        if rising_edge(CLK) then
--            if RST = '1' then
--                counter <= (others => '0');
--            elsif EN = '1' then
--                int_counter := to_integer(unsigned(counter));
--                if int_counter = KH - 1 then
--                    counter <= (others => '0');
--                else
--                    counter <= std_logic_vector(to_unsigned(int_counter + 1, counter'length));
--                end if;
--            end if;
--        end if;
--    end process;
    
--    output <= counter(counter'high);
--    Q <= output;

--end Behavioral;

