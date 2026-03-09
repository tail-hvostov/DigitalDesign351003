library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_tb is
end entity;

architecture sim of comparator_tb is
    constant N_BITS : integer := 3;
    
    signal sw : std_logic_vector(15 downto 0) := (others => '0');
    signal led_o : std_logic_vector(2 downto 0);
    
    component top is
        port ( 
            sw : in std_logic_vector(15 downto 0);
            led_o : out std_logic_vector(2 downto 0)
        );
    end component;
    
    procedure set_inputs(
        signal sw_sig : out std_logic_vector(15 downto 0);
        a_val, b_val : in integer
    ) is
        variable a_vec, b_vec : std_logic_vector(N_BITS-1 downto 0);
    begin
        a_vec := std_logic_vector(to_unsigned(a_val, N_BITS));
        b_vec := std_logic_vector(to_unsigned(b_val, N_BITS));
        
        sw_sig(2 downto 0) <= a_vec;
        sw_sig(5 downto 3) <= b_vec;  
    end procedure;
    
    procedure check_result(
        a_val, b_val : in integer;
        signal led : in std_logic_vector(2 downto 0)
    ) is
    begin
        wait for 1 ns;
        
        if a_val > b_val then
            assert led(2) = '1' and led(1) = '0' and led(0) = '0'
                report "test failed (expected A > B)" severity error;
        elsif a_val = b_val then
            assert led(2) = '0' and led(1) = '1' and led(0) = '0'
                report "test failed (expected A = B)" severity error;
        else
            assert led(2) = '0' and led(1) = '0' and led(0) = '1'
                report "test failed (expected A < B)" severity error;
        end if;
    end procedure;
    
begin
    UUT: top
        port map (
            sw => sw,
            led_o => led_o
        );
        
    set_inputs(sw, 7, 0);
    wait for 10 ns;
    check_result(7, 0, led_o);
    
    set_inputs(sw, 0, 7);
    wait for 10 ns;
    check_result(0, 7, led_o);
    
    set_inputs(sw, 5, 5);
    wait for 10 ns;
    check_result(5, 5, led_o);
    
    for i in 0 to 6 loop
        set_inputs(sw, i+1, i);
        wait for 10 ns;
        check_result(i+1, i, led_o);
    end loop;
    
    for i in 1 to 7 loop
        set_inputs(sw, i-1, i);
        wait for 10 ns;
        check_result(i-1, i, led_o);
    end loop;
    
    wait;

end architecture;