`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2026 11:53:46
// Design Name: 
// Module Name: apb_write_read_seq
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


class apb_write_read_seq extends base_sequence;

    `uvm_object_utils(apb_write_read_seq)

    apb_transaction tr;

    function new(string name = "apb_write_read_seq");
        super.new(name);
    endfunction

    virtual task body();

      
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h1;
        tr.write = 1'b1;
        tr.wdata = 32'h00000055;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h1;
        tr.write = 1'b0;
        finish_item(tr);


        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h3;
        tr.write = 1'b1;
        tr.wdata = 32'h000000AA;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h3;
        tr.write = 1'b0;
        finish_item(tr);


        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h4;
        tr.write = 1'b1;
        tr.wdata = 32'h0000005A;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h4;
        tr.write = 1'b0;
        finish_item(tr);


        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h7;
        tr.write = 1'b1;
        tr.wdata = 32'h000000A5;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr  = 12'h7;
        tr.write = 1'b0;
        finish_item(tr);

    endtask

endclass
