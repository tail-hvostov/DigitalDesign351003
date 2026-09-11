----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2026 14:22:34
-- Design Name: 
-- Module Name: EvalDivider - Behavioral
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

entity EvalDivider is
    generic(
        EVAL : natural
    );
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        EN  : in  std_logic;
        Q   : out std_logic
    );
end EvalDivider;

architecture Behavioral of EvalDivider is
    constant HALF : natural := EVAL / 2;
    signal head_q : std_logic;
    signal store : std_logic;
    signal next_store : std_logic;

    component EvalDivider is
        generic(
            EVAL : natural
        );
        port(
            CLK : in  std_logic;
            CLR : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
    component OddDivider is
        generic(
            ODD : natural
        );
        port(
            CLK : in  std_logic;
            CLR : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
begin

    U0 : if (HALF rem 2 = 0) generate
        U01 : EvalDivider
        generic map(EVAL => HALF)
        port map(CLK => CLK, CLR => CLR, EN => EN, Q => head_q);
    end generate;
    
    U1 : if (HALF = 1) generate
        head_q <= CLK;
    end generate;
    
    U2 : if ((HALF /= 1) and (HALF rem 2 = 1)) generate
        U21 : OddDivider
        generic map(ODD => HALF)
        port map(CLK => CLK, CLR => CLR, EN => EN, Q => head_q);
    end generate;
    
    process(CLK, head_q, CLR)
    begin
        if CLR= '1' then
            store <= '0';
        elsif rising_edge(head_q) then
            if EN = '1' then
                store <= next_store;
            end if;
        end if;
    end process;
    
    next_store <= not store;
    Q <= store;

end Behavioral;
