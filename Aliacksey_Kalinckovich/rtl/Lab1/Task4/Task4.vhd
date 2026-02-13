library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4 is
 Port ( 
    sw_i : in std_logic_vector(3 downto 0);  
    led_o : out std_logic_vector(15 downto 0)
 );
end Task4;

architecture Structural of Task4 is
    component and2_gate
        Port ( IN1, IN2 : in std_logic; Y : out std_logic );
    end component;
    
    component and3_gate
        Port ( IN1, IN2, IN3 : in std_logic; Y : out std_logic );
    end component;
    
    component not_gate
        Port ( X : in std_logic; Y : out std_logic );
    end component;
    
    component or3_gate
        Port ( IN1, IN2, IN3 : in std_logic; Y : out std_logic );
    end component;
    
    signal not_A, not_C, not_D : std_logic;
    signal and3_out, and2_AB_out, and2_BC_out : std_logic;
    signal F_result : std_logic;
    
begin
    U1: not_gate port map (X => sw_i(3), Y => not_A); 
    U2: not_gate port map (X => sw_i(1), Y => not_C); 
    U3: not_gate port map (X => sw_i(0), Y => not_D); 
    
    U4: and3_gate port map (IN1 => not_A, IN2 => not_C, IN3 => not_D, Y => and3_out);
    U5: and2_gate port map (IN1 => sw_i(3), IN2 => sw_i(2), Y => and2_AB_out); 
    U6: and2_gate port map (IN1 => sw_i(2), IN2 => sw_i(1), Y => and2_BC_out);
    
    U7: or3_gate port map (IN1 => and3_out, IN2 => and2_AB_out, IN3 => and2_BC_out, Y => F_result);
    
    led_o <= (others => F_result);
    
end Structural;