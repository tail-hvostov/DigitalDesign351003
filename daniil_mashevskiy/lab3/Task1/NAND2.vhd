library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1 is
    Port(
        sw : in std_logic_vector(1 downto 0);
        led : out std_logic_vector(1 downto 0)
    );
end entity Task1;

architecture Behavioral of Task1 is
    component NAND2 
        port(
            A,B : in std_logic;
            F : out std_logic
        );
    end component;
    signal R, S : std_logic;
    signal r_out_fin, s_out_fin : std_logic;
    
    attribute keep : string;
        
    attribute keep of r_out_fin : signal is "true";
    attribute keep of s_out_fin : signal is "true";
begin
    R <= sw(0);
    S <= sw(1);
    LUT0: NAND2 PORT MAP(A => R, B => s_out_fin, F => r_out_fin);
    LUT1: NAND2 PORT MAP(A => S, B => r_out_fin, F => s_out_fin);
    
    led(0) <= r_out_fin;
    led(1) <= s_out_fin;
end Behavioral;
