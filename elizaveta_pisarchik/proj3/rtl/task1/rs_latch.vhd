library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RSLatch is
  port(
    S, R  : in std_logic;
    Q, nQ : out std_logic
  );
end entity;

architecture rtl of RSLatch is
signal s1, s2 : std_logic;
component NAND2
    port ( A, B : in std_logic;
           F : out std_logic);
end component;
begin
    NAND_1: NAND2 port map (
        A => s2,
        B => S,
        F => s1
    );

    NAND_2: NAND2 port map (
        A => s1,
        B => R,
        F => s2
    );
    
     Q <= s2;
     nQ <= s1;
end rtl;