----------------------------------------------------------------------------------
-- Engineer: Arsalan Dabbagh
-- 
-- Create Date: 12/01/2025
-- Module Name: uart_re
-- Project Name: uart_receiver
-- Description: 
-- This module implements a UART receiver for serial communication.  
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
-- - Ensure that the input clock (BCLK) meets the required baud rate for 
--   proper UART operation.
--
--
-- Licensed under the CERN-OHL-P v2.0.
-- See the LICENSE file or https://cern.ch/cern-ohl-p for detailsS
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_re is
    generic (
        DATA_WIDTH  : integer   := 8;   -- Number of data bits in the frame
        STOP_WIDTH  : integer   := 1;   -- Number of stop bits in the frame
        START_BIT   : std_logic := '0'; -- Expected value for the start bit
        STOP_BIT    : std_logic := '1'  -- Expected value for the stop bit
    );
    port (
        BCLK    : in std_logic;                             -- Input clock signal
        RST     : in std_logic;                             -- Reset signal
        RXD     : in std_logic;                             -- Serial data input
        DOUT    : out std_logic_vector(DATA_WIDTH - 1 downto 0); -- Parallel data output
        BSY     : out std_logic                              -- Busy signal
    );
end uart_re;

architecture Behavioral of uart_re is

    -- Define the states of the state machine
    type state_type is (
        idle_state,     -- Waiting for the start bit
        receive_state,  -- Receiving data bits
        stop_state      -- Checking the stop bit and completing the frame
    );

    -- Signals for state tracking and data processing
    signal current_state: state_type := idle_state; -- Holds the current state
    signal next_state: state_type;                 -- Determines the next state
    signal data_buf: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Buffer for received data
    signal index_counter: integer range 0 to DATA_WIDTH := 0;  -- Tracks bit position

begin

    -- Handles the state transitions and operations based on the input clock (BCLK)
    clock_process: process(BCLK, RST)
    begin
        -- Check for a rising edge on the clock signal
        if rising_edge(BCLK) then
            case current_state is
                -- IDLE STATE: Wait for the start bit
                when idle_state =>
                    data_buf <= (others => '0'); -- Clear the data buffer
                    BSY <= '0';                  -- Indicate idle state
                    if RST = '0' then           -- Reset the system
                        next_state <= idle_state;
                    elsif RST = '1' and RXD = START_BIT then -- Detect start bit
                        BSY <= '1';             -- Indicate busy state
                        next_state <= receive_state; -- Transition to receive state
                    end if;
                    
                -- RECEIVE STATE: Collect data bits into the buffer
                when receive_state => 
                    if index_counter < DATA_WIDTH - 1 then
                        data_buf(index_counter) <= RXD; -- Store received bit
                        index_counter <= index_counter + 1; -- Increment bit position
                        next_state <= receive_state; -- Stay in receive state
                    elsif index_counter = DATA_WIDTH - 1 then
                        index_counter <= 0;          -- Reset bit position
                        next_state <= stop_state;    -- Transition to stop state
                    end if;

                -- STOP STATE: Verify the stop bit and complete reception
                when stop_state =>
                    if RXD = STOP_BIT then          -- Verify stop bit
                        DOUT <= data_buf;           -- Output received data
                        BSY <= '0';                 -- Clear busy signal
                        next_state <= idle_state;   -- Return to idle state
                    else
                        DOUT <= (others => '0');    -- Clear output on error
                        BSY <= '0';                 -- Clear busy signal
                        next_state <= idle_state;   -- Return to idle state
                    end if;    
            end case;   
        end if;
    end process;
    
    -- Update the current state with the next state
    current_state <= next_state;

end Behavioral;
