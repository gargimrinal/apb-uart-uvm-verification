`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 17:57:28
// Design Name: 
// Module Name: dlab_access_seq
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
//////////////////////////////////////////////////////////////////////////////////
// DLAB Register Access Verification Sequence
//////////////////////////////////////////////////////////////////////////////////

class dlab_access_seq extends base_sequence;

    `uvm_object_utils(dlab_access_seq)

    apb_transaction tr;

    function new(string name = "dlab_access_seq");
        super.new(name);
    endfunction

    virtual task body();

        //-------------------------------------------------
        // Enable DLAB (LCR[7] = 1)
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("enable_dlab");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;       // LCR
        tr.wdata = 32'h80;
        finish_item(tr);

        //-------------------------------------------------
        // Program DLL
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("write_dll");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h0;       // DLL when DLAB=1
        tr.wdata = 32'h55;
        finish_item(tr);

        //-------------------------------------------------
        // Program DLM
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("write_dlm");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;       // DLM when DLAB=1
        tr.wdata = 32'hAA;
        finish_item(tr);

        //-------------------------------------------------
        // Read DLL
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("read_dll");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h0;
        finish_item(tr);

        //-------------------------------------------------
        // Read DLM
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("read_dlm");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //-------------------------------------------------
        // Disable DLAB (Normal UART Registers)
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("disable_dlab");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 32'h03;      // 8-bit, DLAB=0
        finish_item(tr);

        //-------------------------------------------------
        // Write THR (Address 0 now maps to THR)
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("write_thr");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h0;
        tr.wdata = 32'h5A;
        finish_item(tr);

        //-------------------------------------------------
        // Write IER (Address 1 now maps to IER)
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("write_ier");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //-------------------------------------------------
        // Read IER
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //-------------------------------------------------
        // Enable DLAB Again
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("enable_dlab_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 32'h80;
        finish_item(tr);

        //-------------------------------------------------
        // Read DLL Again
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("verify_dll");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h0;
        finish_item(tr);

        //-------------------------------------------------
        // Read DLM Again
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("verify_dlm");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

    endtask

endclass