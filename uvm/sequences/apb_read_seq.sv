`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:46:54
// Design Name: 
// Module Name: apb_read_seq
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

class apb_read_seq extends uvm_sequence #(apb_transaction);

    `uvm_object_utils(apb_read_seq)

    apb_transaction tr;

    function new(string name = "apb_read_seq");
        super.new(name);
    endfunction

    virtual task body();

        tr = apb_transaction::type_id::create("tr");

        start_item(tr);

        tr.addr  = 12'h000;
        tr.write = 1'b0;

        finish_item(tr);

    endtask

endclass
