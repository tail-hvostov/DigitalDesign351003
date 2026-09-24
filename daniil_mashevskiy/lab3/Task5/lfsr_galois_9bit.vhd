library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr_galois_9bit is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        mode  : in  std_logic_vector(1 downto 0);
        din   : in  std_logic_vector(8 downto 0);
        dout  : out std_logic_vector(8 downto 0)
    );
end lfsr_galois_9bit;

architecture Behavioral of lfsr_galois_9bit is
    signal reg : std_logic_vector(8 downto 0) := (others => '1');
    signal fb  : std_logic;
begin

    fb <= reg(8);

    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '1');
        elsif rising_edge(clk) then
            case mode is
                when "00" =>  
                    reg(8) <= reg(7);
                    reg(7) <= reg(6);
                    reg(6) <= reg(5);
                    reg(5) <= reg(4) xor fb; 
                    reg(4) <= reg(3);
                    reg(3) <= reg(2);
                    reg(2) <= reg(1);
                    reg(1) <= reg(0);
                    reg(0) <= fb;
                
                when "01" =>  
                    reg <= din;
                
                when others =>
                    reg <= reg;
            end case;
        end if;
    end process;

    dout <= reg;

end Behavioral;