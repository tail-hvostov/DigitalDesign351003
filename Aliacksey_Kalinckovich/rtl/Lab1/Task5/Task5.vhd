library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task5 is
    Port (
        sw_i  : in  STD_LOGIC_VECTOR(15 downto 0);
        led_o : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Task5;

architecture Behavioral of Task5 is
    signal op_left, op_right : UNSIGNED(5 downto 0);
    signal result_final : STD_LOGIC_VECTOR(5 downto 0);
    signal ctrl : STD_LOGIC_VECTOR(3 downto 0);

    function rol_function (vec : UNSIGNED(5 downto 0); shift : UNSIGNED(5 downto 0)) return STD_LOGIC_VECTOR is
        variable temp_vec : UNSIGNED(5 downto 0);
        variable result_vec : UNSIGNED(5 downto 0);
        variable shift_mod : integer;
    begin
        temp_vec := vec;
        shift_mod := to_integer(shift) mod 6;
        result_vec := temp_vec;

        for i in 0 to 5 loop
            if i < shift_mod then
                result_vec := result_vec(4 downto 0) & result_vec(5);
            end if;
        end loop;

        return std_logic_vector(result_vec);
    end function;

begin
    op_left  <= unsigned(sw_i(15 downto 10));
    op_right <= unsigned(sw_i(9 downto 4));
    ctrl <= sw_i(3 downto 0);

    process(ctrl, op_left, op_right)
        variable temp_result : UNSIGNED(5 downto 0);
    begin
        temp_result := op_left;

        for i in 0 to 3 loop
            if ctrl(i) = '1' then
                case i is
                    when 0 =>
                        temp_result := temp_result xor op_right;
                    when 1 =>
                        temp_result := unsigned(rol_function(temp_result, op_right));
                    when 2 =>
                        temp_result := temp_result nand op_right;
                    when 3 =>
                        temp_result := temp_result - op_right;
                    when others =>
                        null;
                end case;
            end if;
        end loop;

        result_final <= std_logic_vector(temp_result);
    end process;

    led_o <= "0000000000" & result_final;
    
end Behavioral;