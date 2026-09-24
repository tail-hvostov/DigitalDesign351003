library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter is
    Generic ( N : natural := 8 );
    Port (
        CLK  : in  std_logic;
        CLR  : in  std_logic; -- Асинхронный сброс
        EN   : in  std_logic;
        MODE : in  std_logic_vector (1 downto 0); 
        DIN  : in  std_logic_vector (N-1 downto 0);
        DOUT : out std_logic_vector (N-1 downto 0)
    );
end universal_counter;

architecture Behavioral of universal_counter is
    signal sig_reg : std_logic_vector(N-1 downto 0) := (others => '0');
begin
    process(CLK, CLR)
        variable fb : std_logic;
    begin
        if CLR = '1' then
            sig_reg <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                if MODE = "00" then -- разрешающий сигнал для сжатия
                    -- fb = x8 xor Din(0)
                    fb := sig_reg(7) xor DIN(0);
                    
                    -- Сдвиг и XOR для полинома x8 + x4 + x3 + x2 + 1
                    sig_reg(7) <= sig_reg(6);
                    sig_reg(6) <= sig_reg(5);
                    sig_reg(5) <= sig_reg(4);
                    sig_reg(4) <= sig_reg(3) xor fb; -- Точка x4
                    sig_reg(3) <= sig_reg(2) xor fb; -- Точка x3
                    sig_reg(2) <= sig_reg(1) xor fb; -- Точка x2
                    sig_reg(1) <= sig_reg(0);
                    sig_reg(0) <= fb;                -- Точка x0 (единица)
                else
                    -- Режим хранения (любой MODE кроме 00)
                    sig_reg <= sig_reg;
                end if;
            end if;
        end if;
    end process;

    DOUT <= sig_reg;
end Behavioral;