library IEEE;
use ieee.std_logic_1164.all;

entity lab2_task6_tb is
end lab2_task6_tb;

architecture rtl of lab2_task6_tb is
 signal test_sw_i : std_logic_vector (1 downto 0) := "00";
 signal test_led_o : std_logic;
 constant DELAY : time := 10 ns;
 constant STABLE : time := 2 ns;
 type test is record 
    sw_i : std_logic_vector(1 downto 0); 
    led_o : std_logic;
 end record;
 type data_array is array(0 to 4) of test;
 constant TEST_DATA: data_array := (
    (sw_i => "00", led_o => '1'),
    (sw_i => "01", led_o => '1'),
    (sw_i => "10", led_o => '0'),
    (sw_i => "01", led_o => '0'),
    (sw_i => "11", led_o => '1') 
 );
begin
 uut: entity work.lab2_task6 port map (
  sw_i => test_sw_i,
  led_o => test_led_o
 );
 
 stim_proc: process
 begin
     for i in TEST_DATA'range loop
        test_sw_i <= TEST_DATA(i).sw_i;
        wait for DELAY;
        wait for STABLE;
        assert (test_led_o = TEST_DATA(i).led_o) 
            report "Step: " & integer'image(i) & ", Output:" & std_logic'image(test_led_o)
        severity error;
     end loop; 
     report "Success"; 
     wait;
 end process;
end rtl;
