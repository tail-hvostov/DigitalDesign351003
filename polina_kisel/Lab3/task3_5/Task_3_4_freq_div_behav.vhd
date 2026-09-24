library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity freq_div_behav is
    Generic( 
        -- Fout= Fclk / K
        K : natural := 100000000 
    );
    Port (
        CLK : in std_logic; -- Такт сигнаол (100 МГц)
        RST : in std_logic; -- Сброс (Active High)
        EN  : in std_logic; -- Разрешение работы
        Q   : out std_logic -- Выход 
    );
End freq_div_behav;

Architecture Behavioral of freq_div_behav is
    signal counter : natural := 0;
    signal q_int   : std_logic := '0';
Begin

    Sim: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then --сброс приоритетнее
                counter <= 0;
                q_int   <= '0';
            elsif EN = '1' then  -- иначе если работа разреш En=1
                -- По усл инверсия происходит каждые (K/2) тактов
                if counter >= (K/2) - 1 then --половина пути?
                    counter <= 0;
                    q_int   <= not q_int;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process Sim;

    Q <= q_int;

End Behavioral;