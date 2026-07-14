`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 09:31:37
// Design Name: 
// Module Name: uart_transaction
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
class uart_transaction extends uvm_sequence_item;

    // Raw UART pins
    bit tx;
    bit rx;
    bit event_o;

    // Protocol information
    bit start_bit;
    bit stop_bit;
    bit [7:0] data;
    bit parity;

    `uvm_object_utils_begin(uart_transaction)
        `uvm_field_int(tx,        UVM_ALL_ON)
        `uvm_field_int(rx,        UVM_ALL_ON)
        `uvm_field_int(event_o,   UVM_ALL_ON)
        `uvm_field_int(start_bit, UVM_ALL_ON)
        `uvm_field_int(stop_bit,  UVM_ALL_ON)
        `uvm_field_int(data,      UVM_ALL_ON)
        `uvm_field_int(parity,    UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="uart_transaction");
        super.new(name);
    endfunction

endclass