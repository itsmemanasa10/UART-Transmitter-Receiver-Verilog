# UART Transmitter and Receiver | Verilog

## Overview

A Verilog-based UART transmitter and receiver designed for a
50 MHz system clock and 115200 baud communication.

## Features

- 50 MHz system clock
- 115200 baud rate
- 8-bit data transmission
- 1 start bit
- 1 stop bit
- No parity
- LSB-first transmission
- 16x receiver oversampling
- FSM-based transmitter and receiver
- UART loopback verification

## Architecture

The design consists of three main blocks:

1. Baud Rate Generator
2. UART Transmitter
3. UART Receiver

The transmitter output is connected to the receiver input
during simulation for loopback verification.

## Project Structure

```text
rtl/
├── baud_gen.v
├── uart_sender.v
├── uart_rx.v
└── uart_top.v

tb/
└── tb_uart.v
