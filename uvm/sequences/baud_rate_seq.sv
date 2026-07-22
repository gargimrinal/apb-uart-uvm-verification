`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 08:19:09
// Design Name: 
// Module Name: baud_rate_seq
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


class baud_rate_seq extends base_sequence;

    `uvm_object_utils(baud_rate_seq)

    apb_transaction tr;

    function new(string name="baud_rate_seq");
        super.new(name);
    endfunction

   virtual task body();

    bit [7:0] dll_vals[4];
    bit [7:0] dlm_vals[3];
    int i;

    dll_vals[0] = 8'h00;
    dll_vals[1] = 8'h01;
    dll_vals[2] = 8'h10;
    dll_vals[3] = 8'hFF;

    dlm_vals[0] = 8'h00;
    dlm_vals[1] = 8'h01;
    dlm_vals[2] = 8'hFF;

    //-------------------------------------------------
    // Enable DLAB
    //-------------------------------------------------
    tr = apb_transaction::type_id::create("lcr_dlab_on");
    start_item(tr);
    tr.write = 1;
    tr.addr  = 12'h3;
    tr.wdata = 32'h80;
    finish_item(tr);

    //-------------------------------------------------
    // DLL programming
    //-------------------------------------------------
    for(i=0;i<4;i++) begin

        tr = apb_transaction::type_id::create($sformatf("dll_wr_%0d",i));
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h0;
        tr.wdata = dll_vals[i];
        finish_item(tr);

        tr = apb_transaction::type_id::create($sformatf("dll_rd_%0d",i));
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h0;
        finish_item(tr);

    end

    //-------------------------------------------------
    // DLM programming
    //-------------------------------------------------
    for(i=0;i<3;i++) begin

        tr = apb_transaction::type_id::create($sformatf("dlm_wr_%0d",i));
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = dlm_vals[i];
        finish_item(tr);

        tr = apb_transaction::type_id::create($sformatf("dlm_rd_%0d",i));
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

    end

    //-------------------------------------------------
    // Disable DLAB
    //-------------------------------------------------
    tr = apb_transaction::type_id::create("lcr_dlab_off");
    start_item(tr);
    tr.write = 1;
    tr.addr  = 12'h3;
    tr.wdata = 32'h03;
    finish_item(tr);

endtask
endclass
