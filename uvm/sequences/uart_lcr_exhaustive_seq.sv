`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 09:16:09
// Design Name: 
// Module Name: uart_lcr_exhaustive_seq
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

class uart_lcr_exhaustive_seq extends uart_base_sequence;

    `uvm_object_utils(uart_lcr_exhaustive_seq)

    apb_transaction tr;

    byte patterns[8];

    function new(string name="uart_lcr_exhaustive_seq");
        super.new(name);
    endfunction

    virtual task body();

        patterns = '{
            8'h00,
            8'hFF,
            8'h55,
            8'hAA,
            8'h33,
            8'hCC,
            8'h0F,
            8'hF0
        };

        //--------------------------------------------------
        // Enable FIFO
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("fifo_en");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        //--------------------------------------------------
        // Enable all UART interrupts
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("ier");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //--------------------------------------------------
        // Sweep every legal LCR configuration
        //--------------------------------------------------

        for(int bits=0; bits<4; bits++) begin

            for(int parity=0; parity<2; parity++) begin

                for(int stop=0; stop<2; stop++) begin

                    bit [7:0] lcr;

                    lcr = 8'h00;
                    lcr[1:0] = bits;
                    lcr[2]   = stop;
                    lcr[3]   = parity;

                    //--------------------------------------
                    // Program LCR
                    //--------------------------------------

                    tr = apb_transaction::type_id::create("lcr_cfg");

                    start_item(tr);
                    tr.write = 1;
                    tr.addr  = 12'h3;
                    tr.wdata = lcr;
                    finish_item(tr);

                    #2000;

                    //--------------------------------------
                    // Send several data patterns
                    //--------------------------------------

                    foreach(patterns[i]) begin

                        //-----------------------------
                        // Write THR
                        //-----------------------------

                        tr = apb_transaction::type_id::create("tx");

                        start_item(tr);
                        tr.write = 1;
                        tr.addr  = 12'h0;
                        tr.wdata = patterns[i];
                        finish_item(tr);

                        #10000;

                        //-----------------------------
                        // Read RBR
                        //-----------------------------

                        tr = apb_transaction::type_id::create("rbr");

                        start_item(tr);
                        tr.write = 0;
                        tr.addr  = 12'h0;
                        finish_item(tr);

                        //-----------------------------
                        // Read LSR
                        //-----------------------------

                        tr = apb_transaction::type_id::create("lsr");

                        start_item(tr);
                        tr.write = 0;
                        tr.addr  = 12'h5;
                        finish_item(tr);

                        //-----------------------------
                        // Read IIR
                        //-----------------------------

                        tr = apb_transaction::type_id::create("iir");

                        start_item(tr);
                        tr.write = 0;
                        tr.addr  = 12'h2;
                        finish_item(tr);

                        #2000;

                    end

                end

            end

        end

    endtask

endclass