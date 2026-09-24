library ieee;
use ieee.std_logic_1164.all;

entity freq_div_behav is
    generic (K: natural := 10);
    port (
        CLK: in std_logic;
        RST: in std_logic;
        EN: in std_logic;
        Q: out std_logic
    );
end freq_div_behav;

architecture behavioural of freq_div_behav is
    signal counter: natural range 0 to (K/2 - 1);
    signal q_int: std_logic;
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter <= 0;
                q_int <= '0';
            elsif EN = '1' then
                if counter = (K/2 - 1) then
                    counter <= 0;
                    q_int <= not q_int;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    Q <= q_int;
end behavioural;

library ieee;
use ieee.std_logic_1164.all;

-- Universal N-bit Shift Register
-- MODE="00" : Shift Left  (LSB gets '0', data moves toward MSB)
-- MODE="01" : Shift Right (MSB gets '0', data moves toward LSB)
-- MODE="10" : Rotate Left  (MSB wraps to LSB)
-- MODE="11" : Parallel Load (Din -> Dout)
--
-- LOAD overrides MODE and always performs parallel load.
-- CLR is asynchronous reset, active high.
-- EN gates all operations (when EN='0' register holds its value).

entity universal_counter is
    generic (N : natural := 8);
    port (
        CLK  : in  std_logic;                       -- System Clock, Rising Edge
        CLR  : in  std_logic;                       -- Asynchronous reset, Active High
        EN   : in  std_logic;                       -- Enable, Active High
        MODE : in  std_logic_vector(1 downto 0);    -- Mode select
        LOAD : in  std_logic;                       -- Parallel load enable
        Din  : in  std_logic_vector(N-1 downto 0); -- Parallel load data
        Dout : out std_logic_vector(N-1 downto 0)  -- Parallel data read
    );
end universal_counter;

architecture Behavioural of universal_counter is
    signal cur : std_logic_vector(N-1 downto 0);
    signal nxt : std_logic_vector(N-1 downto 0);
begin

    -- Combinational: compute next state
    process(cur, EN, MODE, LOAD, Din)
    begin
        nxt <= cur; -- default: hold

        if LOAD = '1' then
            -- Parallel load overrides everything (when EN is irrelevant for LOAD)
            nxt <= Din;
        elsif EN = '1' then
            case MODE is
                when "00" =>
                    -- Shift Left: MSB <- ... <- LSB <- '0'
                    nxt <= cur(N-2 downto 0) & '0';

                when "01" =>
                    -- Shift Right: '0' -> MSB -> ... -> LSB
                    nxt <= '0' & cur(N-1 downto 1);

                when "10" =>
                    -- Rotate Left: MSB wraps around to LSB
                    nxt <= cur(N-2 downto 0) & cur(N-1);

                when "11" =>
                    -- Parallel Load (same as LOAD='1' path, kept for completeness)
                    nxt <= Din;

                when others =>
                    nxt <= cur;
            end case;
        end if;
    end process;

    -- Sequential: register with async reset
    process(CLK, CLR)
    begin
        if CLR = '1' then
            cur <= (others => '0');
        elsif rising_edge(CLK) then
            cur <= nxt;
        end if;
    end process;

    Dout <= cur;

end Behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Top-level module for Basys3 (or similar) FPGA board
-- Demonstrates universal shift register (task 5) using:
--   freq_div_behav  - slow clock so shifts are visible on LEDs
--   universal_counter - universal N-bit shift register
--
-- Board pinout assumption (Basys3):
--   CLK   - 100 MHz on-board oscillator
--   sw    - 16 slide switches
--   led   - 16 LEDs
--   btnC  - Centre button  -> asynchronous reset (CLR)
--   btnU  - Up button      -> enable (EN)
--   btnR  - Right button   -> parallel load (LOAD)
--
-- Switch mapping:
--   sw(15 downto 8) - Din[7:0] (data to load)
--   sw(1 downto 0)  - MODE select
--       "00" : Shift Left
--       "01" : Shift Right
--       "10" : Rotate Left
--       "11" : Parallel Load (also possible via btnR LOAD path)

entity top is
    port (
        clk  : in  std_logic;
        sw   : in  std_logic_vector(15 downto 0);
        led  : out std_logic_vector(15 downto 0);
        btnC : in  std_logic;   -- Reset (CLR), active high
        btnU : in  std_logic;   -- Enable (EN), active high
        btnR : in  std_logic    -- Parallel load (LOAD), active high
    );
end top;

architecture Behavioural of top is

    -- K_DIV = 100_000_000 / 2 => ~0.5 Hz (visible shift on LEDs each second)
    -- Reduce for simulation or faster boards.
    constant K_DIV : natural := 100_000_000;

    constant N_REG : natural := 8;

    signal clk_slow : std_logic;
    signal din_reg  : std_logic_vector(N_REG-1 downto 0);
    signal dout_reg : std_logic_vector(N_REG-1 downto 0);

    component freq_div_behav is
        generic (K : natural := 10);
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;

    component universal_counter is
        generic (N : natural := 8);
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            MODE : in  std_logic_vector(1 downto 0);
            LOAD : in  std_logic;
            Din  : in  std_logic_vector(N-1 downto 0);
            Dout : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin

    -- Frequency divider: 100 MHz -> ~0.5 Hz slow clock
    u_div : freq_div_behav
        generic map (K => K_DIV)
        port map (
            CLK => clk,
            RST => btnC,
            EN  => '1',
            Q   => clk_slow
        );

    -- Data to load comes from upper 8 switches
    din_reg <= sw(15 downto 8);

    -- Universal shift register instance
    u_shift : universal_counter
        generic map (N => N_REG)
        port map (
            CLK  => clk_slow,
            CLR  => btnC,
            EN   => btnU,
            MODE => sw(1 downto 0),   -- lower 2 switches select mode
            LOAD => btnR,
            Din  => din_reg,
            Dout => dout_reg
        );

    -- Show register content on LEDs (upper 8 LEDs)
    -- Lower 8 LEDs echo the current mode and enable status
    led(15 downto 8) <= dout_reg;
    led(7  downto 2) <= (others => '0');
    led(1  downto 0) <= sw(1 downto 0);  -- mode indicator on lower LEDs

end Behavioural;
