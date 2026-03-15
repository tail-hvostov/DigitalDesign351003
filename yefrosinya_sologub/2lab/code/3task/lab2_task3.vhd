library IEEE;
use ieee.std_logic_1164.all;

entity lab2_task3 is
 port (
  sw_i : in std_logic_vector(3 downto 0);
  led_o : out std_logic_vector(3 downto 0)
 );
end lab2_task3;

architecture Structural of lab2_task3 is
 component Gate is 
  generic (GATE_TYPE : string := "AND2"; DELAY : time);
  port (
   X0: in std_logic;
   X1: in std_logic := '0';
   O: out std_logic
  );
 end component;
 component Interconnect is
  generic (
   WIDTH : integer := 1;
   DELAY : time := 1 ns
  );
  port (
   bus_i: in std_logic_vector(WIDTH-1 downto 0);
   bus_o: out std_logic_vector(WIDTH-1 downto 0)
  );
 end component;
 
 constant G_DELAY : time := 10 ns;
 constant W_DELAY : time := 20 ns;
 constant WIRE_WIDTH: integer := 4;
 
 signal sw_delayed, result_delayed: std_logic_vector(WIRE_WIDTH-1 downto 0);
 signal not0, not0_delayed, not1_delayed, not2_delayed, not3_delayed, not1, not2, not3, or1, or1_delayed, or2, and1, and1_delayed, and2, and3, and4, and5, and6, and10, xor1, xor2, xor3, F3, F2, F1, F0 : std_logic;
 signal xor1_delayed, xor2_delayed, and2_delayed, and3_delayed, and10_delayed, or2_delayed : std_logic;
 signal and5_delayed, and4_delayed, and6_delayed : std_logic;
begin 
 W1: Interconnect 
  generic map (WIDTH => WIRE_WIDTH, DELAY => W_DELAY) 
  port map (bus_i => sw_i, bus_o => sw_delayed);
  
 -- X0'
 U1: Gate 
  generic map ("NOT", G_DELAY) 
  port map (X0 => sw_delayed(0), O => not0);
 W2: Interconnect 
  generic map (WIDTH => 1, DELAY => W_DELAY) 
  port map (bus_i(0) => not0, bus_o(0) => not0_delayed);
 
 -- X1'
 U2: Gate generic map ("NOT", G_DELAY) port map (X0 => sw_delayed(1), O => not1);
 W3: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => not1, bus_o(0) => not1_delayed);
 
 --X2'
 U3: Gate generic map ("NOT", G_DELAY) port map (X0 => sw_delayed(2), O => not2);
 W4: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => not2, bus_o(0) => not2_delayed);
 
 --X3'
 U4: Gate generic map ("NOT", G_DELAY) port map (X0 => sw_delayed(3), O => not3);
 W5: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => not3, bus_o(0) => not3_delayed);


 --F3: X1' + X0
 U5: Gate generic map ("OR2", G_DELAY) port map (X0 => not1_delayed, X1 => sw_delayed(0), O => or1);
 W6: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => or1, bus_o(0) => or1_delayed);
 --F3: X2*(X1'+X0)
 U6: Gate generic map (DELAY => G_DELAY) port map (sw_delayed(2), or1_delayed, F3);
 
 
 ----------------
 --F2: X1*X2
 U7: Gate generic map (DELAY => G_DELAY) port map (sw_delayed(1), sw_delayed(2), and1);
 W7: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and1, bus_o(0) => and1_delayed);
 
 --F2: X3 xor X1*X2
 U8: Gate generic map ("XOR2", G_DELAY) port map (sw_delayed(3), and1_delayed, xor1);
 W8: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => xor1, bus_o(0) => xor1_delayed);

 --F2: X0 xor X1*X2
 U9: Gate generic map ("XOR2", G_DELAY) port map (sw_delayed(0), and1_delayed, xor2);
 W9: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => xor2, bus_o(0) => xor2_delayed); 
 
 --F2: (X3 xor X1*X2)*(X0 xor X1*X2)
 U10: Gate generic map (DELAY => G_DELAY) port map (xor1_delayed, xor2_delayed, F2);

 
 
 ---------------------
 --F1: X0'*X1'
 -- ZERO DELAYED
 U11: Gate generic map (DELAY => G_DELAY) port map (not0_delayed, not1_delayed, and2);
 W10: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and2, bus_o(0) => and2_delayed);  
 
 --F1: X0'*X1'*X2
 U12: Gate generic map (DELAY => G_DELAY) port map (and2_delayed, sw_delayed(2), and3);
 W11: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and3, bus_o(0) => and3_delayed);
 
 --F1: X1*X2'
 U121: Gate generic map (DELAY => G_DELAY) port map (sw_delayed(1), not2_delayed, and10);
 W12: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and10, bus_o(0) => and10_delayed);
 
 --F1: X0'*X1'*X2 + X1*X2'
 U13: Gate generic map ("OR2", G_DELAY) port map (and3_delayed, and10_delayed, F1);
 
 
 ---------------
 --F0: X3 + X1*X2'
 U14: Gate generic map ("OR2", G_DELAY) port map (sw_delayed(3), and10_delayed, or2);
 W13: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => or2, bus_o(0) => or2_delayed);
 
  --F0: X0' * (X3 + X1*X2')
 U141: Gate generic map ("AND2", G_DELAY) port map (not0_delayed, or2_delayed, and5);
 W14: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and5, bus_o(0) => and5_delayed);

 --F0: X1'*X3'
 U15: Gate generic map (DELAY => G_DELAY) port map (not1_delayed, not3_delayed, and4);
 W15: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and4, bus_o(0) => and4_delayed); 
 
 --F0: X0 * X1'*X3'
 U16: Gate generic map (DELAY => G_DELAY) port map (sw_delayed(0), and4_delayed, and6);
 W16: Interconnect 
   generic map (WIDTH => 1, DELAY => W_DELAY) 
   port map (bus_i(0) => and6, bus_o(0) => and6_delayed);

 --F0: X0' * (X3 + X1*X2') + X0 * X1'*X3'
 U17: Gate generic map ("OR2", G_DELAY) port map (and5_delayed, and6_delayed, F0);
   

  W31: Interconnect 
  generic map (WIDTH => WIRE_WIDTH, DELAY => W_DELAY) 
  port map (
    bus_i(0) => F0, 
    bus_i(1) => F1, 
    bus_i(2) => F2, 
    bus_i(3) => F3,
    bus_o => result_delayed);
  
 led_o <= result_delayed;
end architecture;
