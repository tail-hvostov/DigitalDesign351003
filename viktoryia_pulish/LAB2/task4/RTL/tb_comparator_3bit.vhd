library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_comparator_3bit is
end tb_comparator_3bit;

architecture rtl of tb_comparator_3bit is

    signal test_sw_i : std_logic_vector(5 downto 0);
    signal test_led_o : std_logic_vector(2 downto 0);
    signal test_first, test_second  : integer;
    
    constant DELAY : time := 40 ns;

begin

    uut: entity work.comparator_3bit
    port map (
        sw_i  => test_sw_i,
        led_o => test_led_o
    );
    
    test_sw_i(2 downto 0) <= std_logic_vector(to_unsigned(test_first,3));
    test_sw_i(5 downto 3) <= std_logic_vector(to_unsigned(test_second,3));
    
    stim_proc: process
    begin
    
        test_first  <= 2;
        test_second <= 2;
        wait for DELAY;
        assert (test_led_o = "010")
            report "Error. Input: 2 and 2"
            severity error;
    
        test_first  <= 6;
        test_second <= 3;
        wait for DELAY;
        assert (test_led_o = "001")
            report "Error. Input: 6 and 3"
            severity error;
    
        test_first  <= 1;
        test_second <= 5;
        wait for DELAY;
        assert (test_led_o = "100")
            report "Error. Input: 1 and 5"
            severity error;
    
        report "All 3 tests passed successfully";
    
        wait;

    end process;

end rtl;