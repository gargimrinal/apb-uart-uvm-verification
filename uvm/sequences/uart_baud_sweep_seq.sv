`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 09:22:17
// Design Name: 
// Module Name: uart_baud_sweep_seq
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

class uart_baud_sweep_seq extends uart_base_sequence;

    `uvm_object_utils(uart_baud_sweep_seq)

    apb_transaction tr;

    bit [7:0] baud_values[6];
    byte patterns[8];

    function new(string name="uart_baud_sweep_seq");
        super.new(name);
    endfunction

    virtual task body();

        baud_values = '{
            8'h01,
            8'h02,
            8'h04,
            8'h08,
            8'h10,
            8'h20
        };

        patterns = '{
            8'h00,
            8'hFF,
            8'h55,
            8'hAA,
            8'h12,
            8'h34,
            8'h78,
            8'hF0
        };

        //--------------------------------------------------
        // FIFO Enable
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("fifo");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        //--------------------------------------------------
        // Interrupt Enable
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("ier");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //--------------------------------------------------
        // Sweep Baud Divisors
        //--------------------------------------------------

        foreach(baud_values[i]) begin

            // DLAB ON
            tr = apb_transaction::type_id::create("dlab_on");

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h3;
            tr.wdata = 32'h83;
            finish_item(tr);

            // DLL
            tr = apb_transaction::type_id::create("dll");

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = baud_values[i];
            finish_item(tr);

            // DLM
            tr = apb_transaction::type_id::create("dlm");

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h1;
            tr.wdata = 32'h00;
            finish_item(tr);

            // DLAB OFF
            tr = apb_transaction::type_id::create("dlab_off");

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h3;
            tr.wdata = 32'h03;
            finish_item(tr);

            #5000;

            //--------------------------------------------------
            // Send Patterns
            //--------------------------------------------------

            foreach(patterns[j]) begin

                tr = apb_transaction::type_id::create("tx");

                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h0;
                tr.wdata = patterns[j];
                finish_item(tr);

                // Wait longer for larger baud divisors
                #(baud_values[i] * 3000);

                tr = apb_transaction::type_id::create("rbr");

                start_item(tr);
                tr.write = 0;
                tr.addr  = 12'h0;
                finish_item(tr);

                tr = apb_transaction::type_id::create("lsr");

                start_item(tr);
                tr.write = 0;
                tr.addr  = 12'h5;
                finish_item(tr);

                tr = apb_transaction::type_id::create("iir");

                start_item(tr);
                tr.write = 0;
                tr.addr  = 12'h2;
                finish_item(tr);

                #2000;

            end

        end

    endtask

endclass