library IEEE;
use ieee.std_logic_1164.all;

entity lab2_task1_tb is
end lab2_task1_tb;

architecture rtl of lab2_task1_tb is
 signal test_sw_i : std_logic_vector (3 downto 0);
 signal test_led_o : std_logic_vector (3 downto 0);
 constant DELAY : time := 180 ns;
 type sub_array is array (0 to 1) of std_logic_vector(3 downto 0);
 type data_array is array (0 to 9) of sub_array;
 constant TEST_DATA: data_array := (
    ("0000", "0000"),
    ("0001", "0001"),
    ("0011", "0010"),
    ("0010", "0011"),
    ("0110", "0100"),
    ("0111", "1000"),
    ("0101", "1001"),
    ("0100", "1010"),
    ("1100", "1011"),
    ("1101", "1100")
 );
begin
 uut: entity work.lab2_task3 port map (
  sw_i => test_sw_i,
  led_o => test_led_o
 );
 
 stim_proc: process
 begin
     for i in TEST_DATA'range loop
        test_sw_i <= TEST_DATA(i)(0);
        wait for DELAY;
        assert (test_led_o = TEST_DATA(i)(1)) 
        severity error;
     end loop; 
     report "Success"; 
     wait;
 end process;
end rtl;
