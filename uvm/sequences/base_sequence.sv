`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 19:05:37
// Design Name: 
// Module Name: base_sequence
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
`timescale 1ns / 1ps

class base_sequence extends uvm_sequence #(apb_transaction);

    `uvm_object_utils(base_sequence)

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(),
                  "Starting Base Sequence",
                  UVM_LOW)
    endtask

endclass
