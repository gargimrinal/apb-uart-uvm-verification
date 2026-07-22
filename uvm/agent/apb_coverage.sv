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


class apb_coverage extends uvm_subscriber #(apb_transaction);

    `uvm_component_utils(apb_coverage)

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
        // Write Data
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
        // Read Data
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
        // Register Address
        //----------------------------------------------------
        cp_addr : coverpoint tr.addr
        {
            bins thr_rbr = {12'h0};
            bins ier_dlm = {12'h1};
            bins fcr_iir = {12'h2};
            bins lcr     = {12'h3};
            bins lsr     = {12'h5};

            ignore_bins unused = {12'h4,12'h6,12'h7};
        }

        //----------------------------------------------------
        // LCR Coverage
        //----------------------------------------------------
        cp_lcr : coverpoint tr.wdata[7:0]
            iff (tr.write && tr.addr == 12'h3)
        {
            bins wl5 = {8'h00};
            bins wl6 = {8'h01};
            bins wl7 = {8'h02};
            bins wl8 = {8'h03};

            bins stop2 = {8'h07};

            bins parity_enable = {8'h0B};
            bins parity_even   = {8'h1B};
            bins stick_parity  = {8'h3B};

            bins break_ctrl = {8'h43};

            bins dlab = {8'h80};
        }

        //----------------------------------------------------
        // IER Coverage
        //----------------------------------------------------
        cp_ier : coverpoint tr.wdata[2:0]
            iff (tr.write && tr.addr == 12'h1)
        {
            bins values[] = {[0:7]};
        }

        //----------------------------------------------------
        // FIFO Control Coverage
        //----------------------------------------------------
        cp_fcr : coverpoint tr.wdata[7:0]
            iff (tr.write && tr.addr == 12'h2)
        {
            bins trigger1  = {8'h01};
            bins reset     = {8'h07};
            bins trigger4  = {8'h41};
            bins trigger8  = {8'h81};
            bins trigger14 = {8'hC1};
        }

        //----------------------------------------------------
        // Divisor Latch Coverage
        //----------------------------------------------------
        cp_divisor : coverpoint tr.wdata[7:0]
            iff (tr.write &&
                (tr.addr == 12'h0 || tr.addr == 12'h1))
        {
            bins zero = {8'h00};
            bins one  = {8'h01};
            bins max  = {8'hFF};
            bins others[] = {[8'h02:8'hFE]};
        }
  

        //----------------------------------------------------
        // LSR Coverage
        //----------------------------------------------------
        cp_lsr : coverpoint tr.rdata[7:0]
            iff (!tr.write && tr.addr == 12'h5)
        {
            bins idle  = {8'h60};
            bins other = default;
        }
//dlab
cp_dlab : coverpoint tr.wdata[7]
    iff (tr.write && tr.addr == 12'h3)
{
    bins disabled = {0};
    bins enabled  = {1};
}

dlab_transition : cross cp_dlab, cp_addr;

        //----------------------------------------------------
        // Cross Coverage
        //----------------------------------------------------
        addr_rw_cross : cross cp_addr, cp_rw;
        lcr_rw_cross  : cross cp_lcr, cp_rw;
        ier_rw_cross  : cross cp_ier, cp_rw;
        fcr_rw_cross  : cross cp_fcr, cp_rw;
 
     endgroup


    //----------------------------------------------------
    // Constructor
    //----------------------------------------------------
    function new(string name = "apb_coverage",
                 uvm_component parent = null);

        super.new(name, parent);
        apb_cg = new();

    endfunction


    //----------------------------------------------------
    // Sample Coverage
    //----------------------------------------------------
    virtual function void write(apb_transaction t);

        tr = t;
        apb_cg.sample();

    endfunction


    //----------------------------------------------------
    // Return Overall Coverage
    //----------------------------------------------------
    function real get_coverage_percentage();
        return apb_cg.get_coverage();
    endfunction

endclass