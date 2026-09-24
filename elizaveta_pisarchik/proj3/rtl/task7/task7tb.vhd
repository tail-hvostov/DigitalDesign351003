library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task7TB is
end Task7TB;

architecture sim of Task7TB is
    component reg_file_2r1w
        generic (
            ADDR_WIDTH : natural := 5;
            DATA_WIDTH : natural := 16
        );
        port(
            CLK      : in  std_logic;
            CLR      : in  std_logic;
            W_EN     : in  std_logic;
            W_ADDR   : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            W_DATA   : in  std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_0 : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_0 : out std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_1 : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_1 : out std_logic_vector (DATA_WIDTH-1 downto 0)
        );
    end component;
    constant AW : integer := 5;
    constant DW : integer := 16;
    constant T  : time := 10 ns;
    signal CLK      : std_logic := '0';
    signal CLR      : std_logic := '0';
    signal W_EN     : std_logic := '0';
    signal W_ADDR   : std_logic_vector(AW-1 downto 0) := (others => '0');
    signal W_DATA   : std_logic_vector(DW-1 downto 0) := (others => '0');
    signal R_ADDR_0 : std_logic_vector(AW-1 downto 0) := (others => '0');
    signal R_DATA_0 : std_logic_vector(DW-1 downto 0);
    signal R_ADDR_1 : std_logic_vector(AW-1 downto 0) := (others => '0');
    signal R_DATA_1 : std_logic_vector(DW-1 downto 0);
begin
    DUT: reg_file_2r1w
        generic map (ADDR_WIDTH => AW, DATA_WIDTH => DW)
        port map (
            CLK => CLK, CLR => CLR, W_EN => W_EN,
            W_ADDR => W_ADDR, W_DATA => W_DATA,
            R_ADDR_0 => R_ADDR_0, R_DATA_0 => R_DATA_0,
            R_ADDR_1 => R_ADDR_1, R_DATA_1 => R_DATA_1
        );

    CLK_PROCESS: process
    begin
        while true loop
            CLK <= '0'; wait for T/2;
            CLK <= '1'; wait for T/2;
        end loop;
    end process;

    TESTING: process
        variable exp_D0 : std_logic_vector(DW-1 downto 0);
        variable exp_D1 : std_logic_vector(DW-1 downto 0);
    begin
        -- Сброс
        CLR <= '1';
        wait for T * 2;
        CLR <= '0';
        wait for T;
        R_ADDR_0 <= "00101";
        wait for 1 ns;
        exp_D0 := x"0000";
        assert (R_DATA_0 = exp_D0) report "RESET FAIL" severity error;

        -- Последовательная запись
        W_EN <= '1';
        W_ADDR <= "00001"; W_DATA <= x"AAAA"; wait for T;
        W_ADDR <= "00010"; W_DATA <= x"BBBB"; wait for T;
        W_ADDR <= "00011"; W_DATA <= x"CCCC"; wait for T;
        W_EN <= '0';
        wait for T;

        --Последовательное чтение
        R_ADDR_0 <= "00001";
        R_ADDR_1 <= "00010";
        wait for 1 ns;
        exp_D0 := x"AAAA";
        exp_D1 := x"BBBB";
        assert (R_DATA_0 = exp_D0) report "READ PORT 0 FAIL" severity error;
        assert (R_DATA_1 = exp_D1) report "READ PORT 1 FAIL" severity error;
        wait for T;

        --Проверка forwarding
        W_EN <= '1';
        W_ADDR <= "00011"; W_DATA <= x"DDDD";
        R_ADDR_0 <= "00011"; 
        wait for T/2;
        exp_D0 := x"DDDD";
        assert (R_DATA_0 = exp_D0) report "FORWARDING FAIL" severity error;
        wait for T/2;
        W_EN <= '0';

        --Чтение и запись разных сразу
        W_EN <= '1';
        W_ADDR <= "00100"; W_DATA <= x"1234"; -- Пишем в R4
        R_ADDR_0 <= "00011"; -- Читаем R3 (должно быть DDDD)
        R_ADDR_1 <= "00001"; -- Читаем R1 (должно быть AAAA)
        wait for 1 ns;
        exp_D0 := x"DDDD";
        exp_D1 := x"AAAA";
        assert (R_DATA_0 = exp_D0) report "SIMULTANEOUS READ/WRITE P0 FAIL" severity error;
        assert (R_DATA_1 = exp_D1) report "SIMULTANEOUS READ/WRITE P1 FAIL" severity error;
        wait for T;
        W_EN <= '0';

        --Попытка записи при W_EN = '0'
        W_ADDR <= "00001"; W_DATA <= x"FFFF";
        W_EN <= '0';
        wait for T;
        R_ADDR_0 <= "00001";
        wait for 1 ns;
        exp_D0 := x"AAAA";
        assert (R_DATA_0 = exp_D0) report "W_EN PROTECTION FAIL" severity error;

        report "REGISTER FILE TEST COMPLETE" severity note;
        wait;
    end process;
end sim;