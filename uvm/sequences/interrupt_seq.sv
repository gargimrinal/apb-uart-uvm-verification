`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 14:10:53
// Design Name: 
// Module Name: interrupt_seq
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
// Interrupt Verification Sequence
//////////////////////////////////////////////////////////////////////////////////

class interrupt_seq extends base_sequence;

    `uvm_object_utils(interrupt_seq)

    apb_transaction tr;

    function new(string name="interrupt_seq");
        super.new(name);
    endfunction

    virtual task body();

        //------------------------------------------------------
        // Configure UART (DLAB = 0)
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("lcr_cfg");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 32'h03;          // Normal UART mode
        finish_item(tr);

        //------------------------------------------------------
        // Enable RX Interrupt
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("ier_rx");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h01;
        finish_item(tr);

        //------------------------------------------------------
        // Read IER
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier_rx");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //------------------------------------------------------
        // Read IIR
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_iir_rx");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //------------------------------------------------------
        // Enable TX Interrupt
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("ier_tx");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h02;
        finish_item(tr);

        //------------------------------------------------------
        // Read IER
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier_tx");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //------------------------------------------------------
        // Read IIR
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_iir_tx");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //------------------------------------------------------
        // Enable Line Status Interrupt
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("ier_line");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h04;
        finish_item(tr);

        //------------------------------------------------------
        // Read IER
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier_line");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //------------------------------------------------------
        // Read IIR
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_iir_line");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //------------------------------------------------------
        // Enable All Interrupts
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("ier_all");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //------------------------------------------------------
        // Read IER
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier_all");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

        //------------------------------------------------------
        // Read IIR
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_iir_all");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //------------------------------------------------------
        // Disable All Interrupts
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("ier_disable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h00;
        finish_item(tr);

        //------------------------------------------------------
        // Final Readback
        //------------------------------------------------------
        tr = apb_transaction::type_id::create("read_ier_disable");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h1;
        finish_item(tr);

    endtask

endclass