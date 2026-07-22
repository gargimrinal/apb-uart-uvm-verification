`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 09:24:50
// Design Name: 
// Module Name: apb_uart_pkg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
package apb_uart_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "apb_transaction.sv"
`include "uart_transaction.sv"
    `include "uart_base_sequence.sv"
    `include "uart_monitor.sv"
    `include "uart_scoreboard.sv"
    `include "uart_coverage.sv"
    `include "uart_env.sv"
    `include "uart_frame_config_seq.sv"
    `include "uart_interrupt_seq.sv"
   `include "uart_baud_sweep_seq.sv"
    `include "uart_lcr_exhaustive_seq.sv"
    `include "uart_fifo_fill_empty_seq.sv"
    `include "uart_random_frame_seq.sv"
    `include "uart_tx_stress_seq.sv"
    `include "uart_rx_stress_seq.sv"
    


    `include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"
`include "apb_scoreboard.sv"
`include "apb_coverage.sv"
`include "apb_env.sv"
`include "base_sequence.sv"
`include "apb_write_seq.sv"
`include "apb_read_seq.sv"
`include "random_sequence.sv"
  `include "apb_write_read_seq.sv"
  `include "lcr_config_seq.sv"
  `include "fifo_control_seq.sv"
 `include "baud_rate_seq.sv"
`include "dlab_access_seq.sv"
`include  "interrupt_seq.sv"
 `include "lsr_status_seq.sv"
`include "coverage_closure_seq.sv"
  `include "regression_sequence.sv"
  `include "uart_regression_seq.sv"
`include "base_test.sv"
endpackage
