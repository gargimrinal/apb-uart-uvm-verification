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

        
        cp_addr : coverpoint tr.addr
        {
            bins reg0 = {12'h000};
            bins reg1 = {12'h001};
            bins reg2 = {12'h002};
            bins reg3 = {12'h003};
            bins others[] = {[12'h004:12'hFFF]};
        }

        
        cp_rw : coverpoint tr.write
        {
            bins READ  = {0};
            bins WRITE = {1};
        }

       
        cp_wdata : coverpoint tr.wdata[7:0] iff (tr.write)
        {
            bins zero = {8'h00};
            bins ff   = {8'hFF};

            bins low[]  = {[8'h01:8'h3F]};
            bins mid[]  = {[8'h40:8'hBF]};
            bins high[] = {[8'hC0:8'hFE]};
        }

       
        cp_rdata : coverpoint tr.rdata[7:0] iff (!tr.write)
        {
            bins zero = {8'h00};
            bins ff   = {8'hFF};

            bins low[]  = {[8'h01:8'h3F]};
            bins mid[]  = {[8'h40:8'hBF]};
            bins high[] = {[8'hC0:8'hFE]};
        }


        addr_rw_cross : cross cp_addr, cp_rw;

    endgroup


    function new(string name = "apb_coverage",
                 uvm_component parent = null);

        super.new(name, parent);

        apb_cg = new();

    endfunction


    virtual function void write(apb_transaction t);

        tr = t;

        apb_cg.sample();

    endfunction

  function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("COVERAGE",
    $sformatf(
"\n\
=================================================\n\
        APB FUNCTIONAL COVERAGE REPORT\n\
=================================================\n\
Overall Functional Coverage : %0.2f%%\n\
=================================================",
    apb_cg.get_coverage()),
    UVM_NONE)

endfunction
endclass