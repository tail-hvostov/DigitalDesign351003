library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end;

architecture rtl of top_tb is

    signal sw : std_logic_vector(15 downto 0) := (others=>'0');
    signal led_o : std_logic_vector(2 downto 0);

    component top is
        port (
            sw : in std_logic_vector(15 downto 0);
            led_o : out std_logic_vector(2 downto 0)
        );
    end component;

    type mode_t is (GT, EQ, LT);

    procedure set_inputs(
        signal s : out std_logic_vector(15 downto 0);
        a,b : integer
    ) is
        variable av,bv : std_logic_vector(2 downto 0);
    begin
        av := std_logic_vector(to_unsigned(a,3)) xor "000";
        bv := std_logic_vector(to_unsigned(b,3)) and "111";
        s(2 downto 0) <= av;
        s(5 downto 3) <= bv;
    end;

    procedure check(
        a,b : integer;
        signal led : in std_logic_vector(2 downto 0)
    ) is
        variable m : mode_t;
    begin
        wait for 1 ns;

        case (a>b) is
            when true => m:=GT;
            when others =>
                case (a=b) is
                    when true => m:=EQ;
                    when others => m:=LT;
                end case;
        end case;

        case m is
            when GT => assert led="100" report "GT fail" severity error;
            when EQ => assert led="010" report "EQ fail" severity error;
            when LT => assert led="001" report "LT fail" severity error;
        end case;
    end;

begin

    UUT: top port map(sw=>sw, led_o=>led_o);

    process
        variable v: integer :=0;
    begin

        set_inputs(sw,7,0); wait for 10 ns; check(7,0,led_o); v:=v+1;
        set_inputs(sw,0,7); wait for 10 ns; check(0,7,led_o); v:=v+1;
        set_inputs(sw,5,5); wait for 10 ns; check(5,5,led_o); v:=v+1;

        for i in 0 to 6 loop
            set_inputs(sw,i+1,i);
            wait for 10 ns;
            check(i+1,i,led_o);
            v:=v+1;
        end loop;

        for i in 1 to 7 loop
            set_inputs(sw,i-1,i);
            wait for 10 ns;
            check(i-1,i,led_o);
            v:=v+1;
        end loop;

        report "done " & integer'image(v);
        wait;
    end process;

end;