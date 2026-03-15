library IEEE;
use ieee.std_logic_1164.all;

entity rs_latch_tb is
end rs_latch_tb;

architecture rtl of rs_latch_tb is
 signal test_sw_i : std_logic_vector (1 downto 0) := "10";
 signal test_led_o : std_logic_vector(1 downto 0);
 constant DELAY : time := 10 ns;
 constant STABLE : time := 2 ns;
 type test is record 
    sw_i : std_logic_vector(1 downto 0); 
    led_o : std_logic_vector(1 downto 0);
 end record;
 type data_array is array(0 to 3) of test;
 constant TEST_DATA: data_array := (
    (sw_i => "10", led_o => "10"),
    (sw_i => "00", led_o => "10"),
    (sw_i => "01", led_o => "01"),
    (sw_i => "00", led_o => "01")
 );
begin
 uut: entity work.rs_latch port map (
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
            report "Step: " & integer'image(i) & ", Output:" & std_logic'image(test_led_o(1)) & std_logic'image(test_led_o(0))
        severity error;
     end loop; 
     report "Success"; 
     wait;
 end process;
end rtl;
