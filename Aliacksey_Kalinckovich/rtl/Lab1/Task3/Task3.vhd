library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3 is
  Port (
    sw_i : in std_logic_vector(7 downto 0);
    led_o : out std_logic_vector(15 downto 0)
   );
end Task3;

architecture rtl of Task3 is
    constant I_value : std_logic_vector(7 downto 0) := "00101011";  -- 0x2B
    constant J_value : std_logic_vector(7 downto 0) := "11010010";  -- 0xD2
    
    constant xor_constant : std_logic_vector(7 downto 0) := "11111001";  -- 0xF9
    
    signal result_8bit : std_logic_vector(7 downto 0);
    signal extended_signal : std_logic_vector(7 downto 0);
begin
    result_8bit <= sw_i xor xor_constant;
    
    extended_signal <= (others => result_8bit(7));  
    
    led_o <= extended_signal & result_8bit;
end rtl;