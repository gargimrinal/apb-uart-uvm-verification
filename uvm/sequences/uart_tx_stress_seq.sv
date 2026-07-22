`timescale 1ns / 1ps

class uart_tx_stress_seq extends base_sequence;

    `uvm_object_utils(uart_tx_stress_seq)

    apb_transaction tr;

    byte tx_pattern[32];

    function new(string name="uart_tx_stress_seq");
        super.new(name);
    endfunction

    virtual task body();

        //-------------------------------------------------
        // Data Patterns
        //-------------------------------------------------

        tx_pattern = '{
            8'h00,8'hFF,8'h55,8'hAA,
            8'h0F,8'hF0,8'h33,8'hCC,
            8'h12,8'h34,8'h56,8'h78,
            8'h9A,8'hBC,8'hDE,8'hEF,
            8'h01,8'h02,8'h04,8'h08,
            8'h10,8'h20,8'h40,8'h80,
            8'h11,8'h22,8'h44,8'h88,
            8'h7E,8'h81,8'h5A,8'hA5
        };

        //-------------------------------------------------
        // Enable FIFO
        //-------------------------------------------------

        tr = apb_transaction::type_id::create("fifo_enable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        //-------------------------------------------------
        // Enable Interrupts
        //-------------------------------------------------

        tr = apb_transaction::type_id::create("ier");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //-------------------------------------------------
        // Send 32 Bytes
        //-------------------------------------------------

        for (int i=0; i<32; i++) begin

            tr = apb_transaction::type_id::create($sformatf("tx_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = tx_pattern[i];
            finish_item(tr);

            // Give UART time to drain FIFO without polling LSR
            #1000;

        end

        //-------------------------------------------------
        // Read LSR
        //-------------------------------------------------

        repeat(100) begin

            tr = apb_transaction::type_id::create("lsr");

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;
            finish_item(tr);

        end

        //-------------------------------------------------
        // Read IIR
        //-------------------------------------------------

        repeat(100) begin

            tr = apb_transaction::type_id::create("iir");

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h2;
            finish_item(tr);

        end

    endtask

endclass