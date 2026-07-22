`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2026 07:52:03
// Design Name: 
// Module Name: uart_interrupt_seq
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
class uart_interrupt_seq extends base_sequence;

    `uvm_object_utils(uart_interrupt_seq)

    apb_transaction tr;

    function new(string name="uart_interrupt_seq");
        super.new(name);
    endfunction

    virtual task body();

        // Configure UART
        tr = apb_transaction::type_id::create("lcr_cfg");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 32'h03;
        finish_item(tr);

        // Enable FIFO
        tr = apb_transaction::type_id::create("fifo_enable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        // Enable Interrupts
        tr = apb_transaction::type_id::create("ier_enable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        // Fill TX FIFO
        repeat (8) begin
            tr = apb_transaction::type_id::create("tx");
            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = $urandom_range(0,255);
            finish_item(tr);
        end

        // Wait for UART transmission to finish
        #100000;

        // Read IIR
        repeat (8) begin
            tr = apb_transaction::type_id::create("iir_read");
            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h2;
            finish_item(tr);
        end

        // Read LSR
        repeat (5) begin
            tr = apb_transaction::type_id::create("lsr_read");
            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;
            finish_item(tr);
        end

    endtask

endclass