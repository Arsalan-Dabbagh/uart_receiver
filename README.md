# UART Receiver Module and Testbench

This repository contains the VHDL implementation of a UART (Universal Asynchronous Receiver Transmitter) Receiver module (`uart_re`) and its corresponding testbench (`tb_uart_re`). The UART receiver is designed to process serial data streams and convert them into parallel data for use in FPGA-based systems.

---

## Overview

### UART Receiver (`uart_re`)
The `uart_re` module implements a UART receiver with the following features:
- **Generic Parameters**:
  - `DATA_WIDTH`: Configurable number of data bits (default: 8 bits).
  - `STOP_WIDTH`: Number of stop bits (default: 1).
  - `START_BIT`: Start bit value (default: `'0'`).
  - `STOP_BIT`: Stop bit value (default: `'1'`).
- **Input/Output Ports**:
  - `BCLK`: Clock signal.
  - `RST`: Asynchronous reset.
  - `RXD`: Serial data input.
  - `DOUT`: Parallel data output.
  - `BSY`: Busy signal indicating reception activity.

### Testbench (`tb_uart_re`)
The testbench is used to verify the functionality of the `uart_re` module. It:
- Simulates a clock signal and generates input stimuli.
- Sends a UART frame consisting of a start bit, data bits, and stop bit.
- Observes the `DOUT` and `BSY` signals to validate the UART receiver's behavior.

---

## File Structure

```plaintext
.
├── uart_re.vhd          # UART Receiver Module
├── tb_uart_re.vhd       # Testbench for UART Receiver
├── README.md            # Project Documentation


