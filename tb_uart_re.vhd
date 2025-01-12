----------------------------------------------------------------------------------
-- Engineer: Arsalan Dabbagh
-- 
-- Create Date: 12/01/2025
-- Module Name: tb_uart_re
-- Project Name: uart_receiver
-- Description: 
-- Testbench for UART receiver.  
-- 
--
-- Dependencies:
-- - IEEE.STD_LOGIC_1164 
-- - IEEE.NUMERIC_STD 
--
-- 
-- Revision History:
-- Revision 0.01 - File Created
-- 
-- 
-- Additional Comments:
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_uart_re is
-- Testbench has no ports
end tb_uart_re;

architecture Behavioral of tb_uart_re is

    -- Component Declaration for the Unit Under Test (UUT)
    component uart_re is
        generic(
            DATA_WIDTH  : integer   := 8;
            STOP_WIDTH  : integer   := 1;
            START_BIT   : std_logic := '0';
            STOP_BIT    : std_logic := '1'
        );
        Port (
            BCLK    : in std_logic;
            RST     : in std_logic;
            RXD     : in std_logic;
            DOUT    : out std_logic_vector(DATA_WIDTH - 1 downto 0);
            BSY     : out std_logic
        );
    end component;

    -- Testbench Signals
    signal BCLK    : std_logic := '0';
    signal RST     : std_logic := '0';
    signal RXD     : std_logic := '1'; -- Idle state of UART line
    signal DOUT    : std_logic_vector(7 downto 0); -- Adjusted for default DATA_WIDTH
    signal BSY     : std_logic;

    -- Clock generation parameters
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: uart_re
        generic map(
            DATA_WIDTH  => 8,       -- Default value
            STOP_WIDTH  => 1,       -- Default value
            START_BIT   => '0',     -- Default value
            STOP_BIT    => '1'      -- Default value
        )
        port map(
            BCLK    => BCLK,
            RST     => RST,
            RXD     => RXD,
            DOUT    => DOUT,
            BSY     => BSY
        );

    -- Clock generation
    clock_process: process
    begin
        while true loop
            BCLK <= '0';
            wait for CLK_PERIOD / 2;
            BCLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset the system
        RST <= '1';
        wait for 50 ns;
        RST <= '0';
        wait for 50 ns;
        RST <= '1';

        -- Send a valid UART frame: Start bit, 8 data bits, stop bit
        -- Start bit
        RXD <= '0'; -- START_BIT
        wait for 10 CLK_PERIOD;

        -- Data bits (e.g., 8'b10101010)
        RXD <= '1'; -- Bit 0
        wait for CLK_PERIOD;
        RXD <= '0'; -- Bit 1
        wait for CLK_PERIOD;
        RXD <= '1'; -- Bit 2
        wait for CLK_PERIOD;
        RXD <= '0'; -- Bit 3
        wait for CLK_PERIOD;
        RXD <= '1'; -- Bit 4
        wait for CLK_PERIOD;
        RXD <= '0'; -- Bit 5
        wait for CLK_PERIOD;
        RXD <= '1'; -- Bit 6
        wait for CLK_PERIOD;
        RXD <= '0'; -- Bit 7
        wait for CLK_PERIOD;

        -- Stop bit
        RXD <= '1'; -- STOP_BIT
        wait for 10 CLK_PERIOD;

        -- Observe the output
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
