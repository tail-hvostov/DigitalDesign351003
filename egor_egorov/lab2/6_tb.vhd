library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture rtl of top_tb is

    signal sw : std_logic_vector(1 downto 0) := "00";
    signal led_o : std_logic_vector(1 downto 0);

    constant delay : time := 20 ns;

    component top is
        port (
            sw : in std_logic_vector(1 downto 0);
            led_o : out std_logic_vector(1 downto 0)
        );
    end component;

    type phase_t is (PH_SET, PH_HOLD1, PH_RESET, PH_HOLD2, PH_TOGGLE, PH_FORBID, PH_RELEASE);

    procedure check_state(
        signal led : in std_logic_vector(1 downto 0);
        constant exp1, exp0 : std_logic;
        constant msg : string
    ) is
    begin
        wait for 1 ns;
        assert (led(1)=exp1 and led(0)=exp0)
        report msg severity error;
    end procedure;

begin

    UUT: top port map (
        sw => sw,
        led_o => led_o
    );

    process
        variable phase : phase_t := PH_SET;
    begin

        case phase is
            when PH_SET =>
                sw <= "10";
                wait for delay;
                check_state(led_o, '1', '0', "Set failed");
                phase := PH_HOLD1;

            when PH_HOLD1 =>
                sw <= "00";
                wait for delay;
                check_state(led_o, '1', '0', "Hold after Set failed");
                phase := PH_RESET;

            when PH_RESET =>
                sw <= "01";
                wait for delay;
                check_state(led_o, '0', '1', "Reset failed");
                phase := PH_HOLD2;

            when PH_HOLD2 =>
                sw <= "00";
                wait for delay;
                check_state(led_o, '0', '1', "Hold after Reset failed");
                phase := PH_TOGGLE;

            when PH_TOGGLE =>
                sw <= "10"; wait for delay;
                sw <= "00"; wait for delay;
                sw <= "01"; wait for delay;
                sw <= "00"; wait for delay;
                check_state(led_o, '0', '1', "Toggle sequence failed");
                phase := PH_FORBID;

            when PH_FORBID =>
                sw <= "11";
                wait for 50 ns;
                assert led_o = "00"
                report "Forbidden state outputs not both 0" severity warning;
                phase := PH_RELEASE;

            when PH_RELEASE =>
                sw <= "00";
                wait for 200 ns;
                case (led_o = "01" or led_o = "10") is
                    when true => null;
                    when others =>
                        assert false report "Metastable/oscillation issue" severity warning;
                end case;
                report "Test completed successfully";
                wait;

        end case;

    end process;

end rtl;