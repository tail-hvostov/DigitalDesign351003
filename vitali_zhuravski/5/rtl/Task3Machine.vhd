----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2026 17:52:46
-- Design Name: 
-- Module Name: Task3Machine - Behavioral
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

-- out = addr; 
-- X='0' -> addr?1, 
-- X='1' -> addr+1 (mod 16)

entity Task3Machine is
    generic(
        ADDR_LENGTH : natural := 4;
        ROM : std_logic_vector :=
            X"0" & X"F" & X"1" &
            X"1" & X"0" & X"2" &
            X"2" & X"1" & X"3" &
            X"3" & X"2" & X"4" &
            X"4" & X"3" & X"5" &
            X"5" & X"4" & X"6" &
            X"6" & X"5" & X"7" &
            X"7" & X"6" & X"8" &
            X"8" & X"7" & X"9" &
            X"9" & X"8" & X"A" &
            X"A" & X"9" & X"B" &
            X"B" & X"A" & X"C" &
            X"C" & X"B" & X"D" &
            X"D" & X"C" & X"E" &
            X"E" & X"D" & X"F" &
            X"F" & X"E" & X"0"
    );
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        CE  : in  std_logic;
        X   : in  std_logic;
        DO  : out std_logic_vector(ADDR_LENGTH - 1 downto 0)
    );
end Task3Machine;

architecture Behavioral of Task3Machine is
    subtype t_instruction is std_logic_vector(ADDR_LENGTH * 3 - 1 downto 0);
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
    
    constant INST_OUT_HIGH : natural := t_instruction'high;
    constant INST_OUT_LOW : natural := t_instruction'length - ADDR_LENGTH;
    constant INST_A_HIGH : natural := INST_OUT_HIGH - ADDR_LENGTH;
    constant INST_A_LOW : natural := INST_OUT_LOW - ADDR_LENGTH;
    constant INST_B_HIGH : natural := INST_A_HIGH - ADDR_LENGTH;
    constant INST_B_LOW : natural := INST_A_LOW - ADDR_LENGTH;
    
    signal cur_inst_addr : std_logic_vector(ADDR_LENGTH - 1 downto 0);
    signal next_inst_addr : std_logic_vector(cur_inst_addr'range);
    signal cur_instruction : t_instruction;
begin
    assert ROM'length = 2**ADDR_LENGTH * ADDR_LENGTH*3;
    
    cur_instruction <= inst_rom(to_integer(unsigned(cur_inst_addr)));
    DO <= cur_instruction(INST_OUT_HIGH downto INST_OUT_LOW);
    
    process(cur_instruction, X)
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
            if CE = '1' then
                cur_inst_addr <= next_inst_addr;
            end if;
        end if;
    end process;

end Behavioral;
