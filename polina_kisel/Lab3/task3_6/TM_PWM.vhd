library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TM_PWM is
 Generic ( 
    CNT_WIDTH : natural := 8;
    K : natural := 10000
  );
 Port ( 
         CLK  : in  std_logic; -- Тактовый сигнал
         CLR  : in  std_logic; -- Асинхронный сброс
         EN   : in  std_logic; -- Разрешение работы
         FILL : in  std_logic_vector (CNT_WIDTH-1 downto 0); -- Коэф. заполнения (fILL имеет размер 8 бит (от 7 до 0))
         Q    : out std_logic  -- Выход ШИМ
 );
end TM_PWM;

architecture Behavioral of TM_PWM is
    signal clk_div: std_logic:= '0';
    signal pwm_out : std_logic;
begin

UC_FREQ_DIV: entity work.freq_div_behav
generic map (K => K)
port map (
CLK => CLK ,
RST => CLR ,
EN  => EN  ,
Q   => clk_div  
);    
    
    
UC_CLK_DIV: entity work.pwm_controller
generic map (CNT_WIDTH =>  CNT_WIDTH )
port map(
CLK   =>  clk_div ,
CLR   =>  CLR ,
EN    =>  EN  ,
FILL  =>  FILL,
Q     =>  pwm_out   
);

Q<= pwm_out;
end Behavioral;