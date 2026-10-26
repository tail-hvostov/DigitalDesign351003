----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2026 00:25:02
-- Design Name: 
-- Module Name: Task4Machine - Behavioral
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

entity Task4Machine is
    generic(
        ADDR_LENGTH : natural := 4;
        ROM : std_logic_vector :=
            "1" & X"0" & X"F" & X"1" &
            "1" & X"0" & X"0" & X"2" &
            "1" & X"2" & X"1" & X"3" &
            "1" & X"2" & X"2" & X"4" &
            "1" & X"2" & X"3" & X"5" &
            "1" & X"5" & X"4" & X"6" &
            "1" & X"5" & X"5" & X"7" &
            "1" & X"5" & X"6" & X"8" &
            "1" & X"5" & X"7" & X"9" &
            "1" & X"9" & X"8" & X"A" &
            "1" & X"9" & X"9" & X"B" &
            "1" & X"9" & X"A" & X"C" &
            "1" & X"9" & X"B" & X"D" &
            "1" & X"9" & X"C" & X"E" &
            "1" & X"9" & X"D" & X"F" &
            "0" & X"F" & X"E" & X"0"
    );
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        CE  : in  std_logic;
        X   : in  std_logic;
        DO  : out std_logic_vector(ADDR_LENGTH - 1 downto 0)
    );
end Task4Machine;

architecture Behavioral of Task4Machine is
    subtype t_instruction is std_logic_vector(ADDR_LENGTH * 3 downto 0);
    type t_inst_rom is array(0 to 2 ** ADDR_LENGTH - 1) of t_instruction;

    function unpack_rom(v : std_logic_vector) return t_inst_rom is
        constant W : natural := t_instruction'length;
        constant N : natural := t_inst_rom'length;
        variable result : t_inst_rom;
    begin
        for i in 0 to N - 1 loop
            result(i) := v(i * W to (i + 1) * W - 1);
        end loop;
        return result;
    end function;
    
    constant inst_rom : t_inst_rom := unpack_rom(ROM);
    
    constant INST_OUT_HIGH : natural := t_instruction'high - 1;
    constant INST_OUT_LOW : natural := t_instruction'length - ADDR_LENGTH - 1;
    constant INST_A_HIGH : natural := INST_OUT_HIGH - ADDR_LENGTH;
    constant INST_A_LOW : natural := INST_OUT_LOW - ADDR_LENGTH;
    constant INST_B_HIGH : natural := INST_A_HIGH - ADDR_LENGTH;
    constant INST_B_LOW : natural := INST_A_LOW - ADDR_LENGTH;
    
    signal cur_inst_addr : std_logic_vector(ADDR_LENGTH - 1 downto 0);
    signal next_inst_addr : std_logic_vector(cur_inst_addr'range);
    signal cur_instruction : t_instruction;
    signal pCE : std_logic;
    signal EN : std_logic;
begin
    assert ROM'length = 2**ADDR_LENGTH * t_instruction'length;
    
    cur_instruction <= inst_rom(to_integer(unsigned(cur_inst_addr)));
    pCE <= cur_instruction(t_instruction'high);
    EN <= pCE and CE;
    DO <= cur_instruction(INST_OUT_HIGH downto INST_OUT_LOW);
    
    process(cur_instruction, X, cur_inst_addr)
        variable a : std_logic_vector(next_inst_addr'range);
        variable b : std_logic_vector(next_inst_addr'range);
    begin
        a := cur_instruction(INST_A_HIGH downto INST_A_LOW);
        b := cur_instruction(INST_B_HIGH downto INST_B_LOW);
        if X = '0' then
            next_inst_addr <= a;
        else
            next_inst_addr <= b;
        end if;
    end process;
    
    process(CLR, CLK)
    begin
        if CLR = '1' then
            cur_inst_addr <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                cur_inst_addr <= next_inst_addr;
            end if;
        end if;
    end process;

end Behavioral;
