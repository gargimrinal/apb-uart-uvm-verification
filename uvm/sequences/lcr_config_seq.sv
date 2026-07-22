`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 07:13:20
// Design Name: 
// Module Name: lcr_config_seq
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


class lcr_config_seq extends base_sequence;

    `uvm_object_utils(lcr_config_seq)

    apb_transaction tr;

    function new(string name="lcr_config_seq");
        super.new(name);
    endfunction

    virtual task body();

        bit [7:0] lcr;

        // Word Length = 5,6,7,8 bits
        for (int wl = 0; wl < 4; wl++) begin

            // Stop bits = 1 / 2
            for (int stop = 0; stop < 2; stop++) begin

                // Parity disabled / enabled
                for (int pen = 0; pen < 2; pen++) begin

                    // Even / Odd parity
                    for (int even = 0; even < 2; even++) begin

                        lcr = 8'h00;

                        lcr[1:0] = wl;
                        lcr[2]   = stop;
                        lcr[3]   = pen;
                        lcr[4]   = even;

                        //---------------------------------
                        // Write LCR
                        //---------------------------------
                        tr = apb_transaction::type_id::create("wr_lcr");
                        start_item(tr);
                        tr.write = 1;
                        tr.addr  = 12'h3;
                        tr.wdata = lcr;
                        finish_item(tr);

                        //---------------------------------
                        // Read LCR
                        //---------------------------------
                        tr = apb_transaction::type_id::create("rd_lcr");
                        start_item(tr);
                        tr.write = 0;
                        tr.addr  = 12'h3;
                        finish_item(tr);

                    end
                end
            end
        end

        //---------------------------------
        // Stick parity
        //---------------------------------
        tr = apb_transaction::type_id::create("stick_parity");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 8'h3B;     // PEN=1 EPS=1 SP=1
        finish_item(tr);

        //---------------------------------
        // Break Control
        //---------------------------------
        tr = apb_transaction::type_id::create("break_ctrl");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 8'h43;     // Break enable
        finish_item(tr);

        //---------------------------------
        // DLAB Enable
        //---------------------------------
        tr = apb_transaction::type_id::create("dlab");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 8'h83;     // DLAB=1
        finish_item(tr);

        //---------------------------------
        // Restore Normal UART
        //---------------------------------
        tr = apb_transaction::type_id::create("restore");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = 8'h03;
        finish_item(tr);

    endtask

endclass