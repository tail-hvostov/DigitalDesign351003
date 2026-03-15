----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 14:08:46
-- Design Name: 
-- Module Name: task1_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity task1_4 is
    port(
    -- x3= sw_i3 x2=sw_i2 x1=sw_i1 x0=sw_i0
         sw_i3,sw_i2,sw_i1,sw_i0 : in std_logic;
           led_o : out std_logic 
    );   
end task1_4;
 
 
--Вар 11: F-F1AA(16-я) (2я): 1111(x3) 0001(x2) 1010(x1) 1010(x0)
architecture Structural of task1_4 is
  signal nx3, nx1, nx0 : std_logic;
  signal ax013, ax32, ax30 : std_logic;
begin
    nx3 <= not sw_i3;
    nx1 <= not sw_i1;
    nx0 <= not sw_i0;
 
    ax30 <= nx3 and sw_i0;
    ax32 <= sw_i3 and sw_i2;
    ax013 <= nx1 and nx0 and sw_i3;
 
    led_o <= ax30 or ax32 or ax013;
 
 
end Structural;
