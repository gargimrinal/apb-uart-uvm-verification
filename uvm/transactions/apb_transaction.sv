`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 09:22:25
// Design Name: 
// Module Name: apb_transaction
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
class apb_transaction extends uvm_sequence_item;

    // APB Transaction Fields
    rand bit [11:0] addr;
    rand bit [31:0] wdata;
         bit [31:0] rdata;
    rand bit        write;

    // Factory Registration
    `uvm_object_utils_begin(apb_transaction)
        `uvm_field_int(addr , UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor
    function new(string name = "apb_transaction");
        super.new(name);
    endfunction

endclass
