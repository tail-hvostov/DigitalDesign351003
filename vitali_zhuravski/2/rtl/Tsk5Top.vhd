library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

entity tsk5_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk5_top;

--architecture structure of tsk5_top is
--    signal Q : std_logic;
--    signal nQ : std_logic;
--begin
--    led_out(15 downto 2) <= "00000000000000";
    
--    U1 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => Q, O => nQ);
    
--    U2 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => nQ, O => Q);
        
--    led_out(1) <= Q;
--    led_out(0) <= nQ;
--end structure;

architecture structure of tsk5_top is
    signal Q : std_logic_vector(15 downto 0);
    signal nQ : std_logic_vector(15 downto 0);
    
    attribute KEEP: string;
    attribute KEEP of Q: signal is "TRUE";
    attribute KEEP of nQ: signal is "TRUE";
    attribute DONT_TOUCH: string;
    attribute DONT_TOUCH of Q: signal is "TRUE";
    attribute DONT_TOUCH of nQ: signal is "TRUE";
begin
    Q <= not nQ;
    nQ <= not Q;
--    U1 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => Q, O => nQ);
    
--    U2 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => nQ, O => Q);
        
    led_out <= Q;
end structure;