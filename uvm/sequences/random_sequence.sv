`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 19:16:54
// Design Name: 
// Module Name: random_sequence
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

class apb_random_seq extends base_sequence;

    `uvm_object_utils(apb_random_seq)

    apb_transaction tr;

    function new(string name = "apb_random_seq");
        super.new(name);
    endfunction

   virtual task body();

    repeat (500) begin

        tr = apb_transaction::type_id::create("tr");

        start_item(tr);

        assert(tr.randomize() with {

            // Only implemented registers
            addr inside {12'h0, 12'h1, 12'h2, 12'h3};

            // Keep DLAB disabled during random testing
            if (write && (addr == 12'h3))
                wdata[7] == 1'b0;

        })
        else
            `uvm_fatal("RANDFAIL", "Randomization failed")

        finish_item(tr);

    end

endtask
endclass