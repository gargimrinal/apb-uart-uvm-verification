`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 09:58:22
// Design Name: 
// Module Name: uart_base_sequence
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
`timescale 1ns/1ps

class uart_base_sequence extends uvm_sequence #(uart_transaction);

    `uvm_object_utils(uart_base_sequence)

    function new(string name = "uart_base_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(),
                  "Starting UART Base Sequence",
                  UVM_LOW)
    endtask

endclass