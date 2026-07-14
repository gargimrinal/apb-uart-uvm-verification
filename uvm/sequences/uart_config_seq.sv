`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 19:27:27
// Design Name: 
// Module Name: uart_config_seq
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

class uart_config_seq extends base_sequence;

    `uvm_object_utils(uart_config_seq)

    apb_transaction tr;

    function new(string name="uart_config_seq");
        super.new(name);
    endfunction

    virtual task body();

        //--------------------------------------------------
        // Enable DLAB
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h3;      // LCR
        tr.wdata = 32'h80;     // DLAB = 1

        finish_item(tr);

        //--------------------------------------------------
        // DLL
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h0;
        tr.wdata = 32'h01;

        finish_item(tr);

        //--------------------------------------------------
        // DLM
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h00;

        finish_item(tr);

        //--------------------------------------------------
        // Disable DLAB
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 32'h03;     // 8-bit, DLAB=0

        finish_item(tr);

        //--------------------------------------------------
        // Enable UART interrupts
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h1;      // IER
        tr.wdata = 32'h07;

        finish_item(tr);

        //--------------------------------------------------
        // FIFO Control Register
        //--------------------------------------------------
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h2;      // FCR
        tr.wdata = 32'h07;

        finish_item(tr);

    endtask

endclass