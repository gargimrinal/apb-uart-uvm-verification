`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2026 12:09:26
// Design Name: 
// Module Name: apb_coverage
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

class apb_coverage extends uvm_subscriber #(apb_transaction);

    `uvm_component_utils(apb_coverage)

    // Transaction handle
    apb_transaction tr;

   covergroup apb_cg;

    option.per_instance = 1;

    //----------------------------------------------------
    // Read / Write
    //----------------------------------------------------
    cp_rw : coverpoint tr.write
    {
        bins READ  = {0};
        bins WRITE = {1};
    }

    //----------------------------------------------------
    // Write Data Coverage
    //----------------------------------------------------
    cp_wdata : coverpoint tr.wdata[7:0] iff (tr.write)
    {
        bins zero = {8'h00};
        bins ff   = {8'hFF};

        bins low[]  = {[8'h01:8'h3F]};
        bins mid[]  = {[8'h40:8'hBF]};
        bins high[] = {[8'hC0:8'hFE]};
    }

    //----------------------------------------------------
    // Read Data Coverage
    //----------------------------------------------------
    cp_rdata : coverpoint tr.rdata[7:0] iff (!tr.write)
    {
        bins zero = {8'h00};
        bins ff   = {8'hFF};

        bins low[]  = {[8'h01:8'h3F]};
        bins mid[]  = {[8'h40:8'hBF]};
        bins high[] = {[8'hC0:8'hFE]};
    }

    //----------------------------------------------------
    // Address Coverage
    //----------------------------------------------------
    cp_addr : coverpoint tr.addr
    {
        bins THR_RBR_DLL = {12'h0};
        bins IER_DLM     = {12'h1};
        bins FCR_IIR     = {12'h2};
        bins LCR         = {12'h3};
        bins LSR         = {12'h5};

        // Registers not implemented through APB
        ignore_bins unused = {12'h4, 12'h6, 12'h7};
    }

    //----------------------------------------------------
    // Cross Coverage
    //----------------------------------------------------
    addr_rw_cross : cross cp_addr, cp_rw;

endgroup    function new(string name = "apb_coverage",
                 uvm_component parent = null);

        super.new(name, parent);

        apb_cg = new();
 

    endfunction


    virtual function void write(apb_transaction t);

        tr = t;

        apb_cg.sample();
endfunction 

function real get_coverage_percentage();
    return apb_cg.get_coverage();

    endfunction


endclass