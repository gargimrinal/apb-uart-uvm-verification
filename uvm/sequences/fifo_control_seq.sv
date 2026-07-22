`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 08:00:56
// Design Name: 
// Module Name: fifo_control_seq
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


class fifo_control_seq extends base_sequence;

    `uvm_object_utils(fifo_control_seq)

    apb_transaction tr;

    function new(string name="fifo_control_seq");
        super.new(name);
    endfunction

    virtual task body();

        //-------------------------------------------------
        // Enable FIFO
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("fifo_enable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;      // FCR
        tr.wdata = 32'h01;
        finish_item(tr);

        //-------------------------------------------------
        // Reset RX/TX FIFO
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("fifo_reset");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h07;
        finish_item(tr);

        //-------------------------------------------------
        // Trigger Level = 1 Byte
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("trigger1");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        //-------------------------------------------------
        // Trigger Level = 4 Bytes
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("trigger4");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h41;
        finish_item(tr);

        //-------------------------------------------------
        // Trigger Level = 8 Bytes
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("trigger8");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h81;
        finish_item(tr);

        //-------------------------------------------------
        // Trigger Level = 14 Bytes
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("trigger14");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'hC1;
        finish_item(tr);

        //-------------------------------------------------
        // Read IIR after FIFO configuration
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("read_iir");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //-------------------------------------------------
        // Read LSR
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("read_lsr");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);
        //-------------------------------------------------
        // Fill TX FIFO with 16 bytes
        //-------------------------------------------------
        for (int i = 0; i < 16; i++) begin

            tr = apb_transaction::type_id::create($sformatf("tx_fifo_%0d", i));
            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;        // THR
            tr.wdata = i;
            finish_item(tr);

        end

        //-------------------------------------------------
        // Read LSR several times
        //-------------------------------------------------
        repeat (5) begin

            tr = apb_transaction::type_id::create("lsr_status");
            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;        // LSR
            finish_item(tr);

        end

        //-------------------------------------------------
        // Read IIR several times
        //-------------------------------------------------
        repeat (5) begin

            tr = apb_transaction::type_id::create("iir_status");
            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h2;        // IIR
            finish_item(tr);

        end

        //-------------------------------------------------
        // Overflow Attempt
        //-------------------------------------------------
        for (int i = 16; i < 20; i++) begin

            tr = apb_transaction::type_id::create($sformatf("overflow_%0d", i));
            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = i;
            finish_item(tr);

        end

        //-------------------------------------------------
        // Reset FIFO Again
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("fifo_reset_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h07;
        finish_item(tr);

        //-------------------------------------------------
        // Verify FIFO Empty
        //-------------------------------------------------
        repeat (5) begin

            tr = apb_transaction::type_id::create("lsr_after_reset");
            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;
            finish_item(tr);

        end

        //-------------------------------------------------
        // Change Trigger Levels Again
        //-------------------------------------------------
       
        tr = apb_transaction::type_id::create("trigger1_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        tr = apb_transaction::type_id::create("trigger4_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h41;
        finish_item(tr);

        tr = apb_transaction::type_id::create("trigger8_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h81;
        finish_item(tr);

        tr = apb_transaction::type_id::create("trigger14_again");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'hC1;
        finish_item(tr);
    endtask

endclass