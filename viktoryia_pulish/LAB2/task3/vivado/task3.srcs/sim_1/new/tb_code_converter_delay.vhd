library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_code_converter_delay is
end tb_code_converter_delay;

architecture rtl of tb_code_converter_delay is

    component code_converter_delay
        port(
            sw_i  : in  STD_LOGIC_VECTOR(4 downto 0);
            led_o : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    signal sw, led : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

begin

    uut: code_converter_delay port map(sw, led);

    stim_proc: process
    begin
        sw <= "01111"; wait for 10 ns;
        assert (led = "00011") report "Error: Input 01111" severity error;

        sw <= "10111"; wait for 10 ns;
        assert (led = "00101") report "Error: Input 10111" severity error;

        sw <= "11011"; wait for 10 ns;
        assert (led = "00110") report "Error: Input 11011" severity error;

        sw <= "11101"; wait for 10 ns;
        assert (led = "01001") report "Error: Input 11101" severity error;

        sw <= "11110"; wait for 10 ns;
        assert (led = "01010") report "Error: Input 11110" severity error;

        report "All 5 test cases passed successfully" severity note;
        wait;
    end process;

end rtl;