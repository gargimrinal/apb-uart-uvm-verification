`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:38:26
// Design Name: 
// Module Name: apb_write_seq
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

class apb_write_seq extends uvm_sequence #(apb_transaction);

    `uvm_object_utils(apb_write_seq)

    apb_transaction tr;

    function new(string name = "apb_write_seq");
        super.new(name);
    endfunction

    virtual task body();

        tr = apb_transaction::type_id::create("tr");

        start_item(tr);

        tr.addr  = 12'h000;
        tr.wdata = 32'hA5A5_1234;
        tr.write = 1'b1;

        finish_item(tr);

    endtask

endclass
