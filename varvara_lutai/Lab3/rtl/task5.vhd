----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 18:58:59
-- Design Name: 
-- Module Name: task5 - Behavioral
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



entity universal_counter is
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
end universal_counter;

--Вариант 3
architecture Behavioral of universal_counter is
component LFSR_Fibonacci is
Generic (N : natural := 8);
Port ( 
    CLK: in std_logic;
    CLR: in std_logic; 
    EN: in std_logic;
    Dout: out std_logic_vector (N-1 downto 0)
);
end component LFSR_Fibonacci;
signal cur_state, nxt_state, lfsr_output, store_output : std_logic_vector ( N-1 downto 0 );
signal EN_lfsr : std_logic;
begin
    LFSR: LFSR_Fibonacci generic map (N => 8) port map (CLK => CLK, CLR => CLR, EN => EN_lfsr, Dout => lfsr_output);
--    MODE_DETECT: process (MODE)
--    begin
--        if MODE = "00" then --лфср по схеме фибоначчи 
--            EN_lfsr <= '1';
--        else
--    end process;
    EN_lfsr <= EN when MODE = "00";
    PSHIFTS: process (MODE, LOAD, EN, cur_state)
    begin
--        if MODE = "00" then --лфср по схеме фибоначчи 
--            EN_lfsr <= '1';
--            --nxt_state <= '0' & cur_state( N-1 downto 1 );
--        else
--            EN_lfsr <= '0';
--            if MODE = "01" then --Параллельная загрузка
--                if LOAD = '1' then
--                    nxt_state <= Din;
--                end if;
--            else --хранение значения
--                nxt_state <= cur_state;
--            end if;
--        end if;
          if MODE = "01" then --Параллельная загрузка
            if EN = '1' then
                if LOAD = '1' then
                    store_output <= Din;
                end if;
            end if;
          elsif not(MODE = "00") then
              store_output <= cur_state;
          end if;
    end process PSHIFTS;

nxt_state <= lfsr_output when MODE = "00" else store_output;

SREG: process ( CLK, MODE, nxt_state, Din )
begin
    if rising_edge( CLK ) then
       cur_state <= nxt_state;
    end if; 
end process SREG;

Dout <= cur_state;

end Behavioral;
