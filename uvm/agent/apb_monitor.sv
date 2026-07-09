`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 13:45:14
// Design Name: 
// Module Name: apb_monitor
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

class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_if vif;

    uvm_analysis_port #(apb_transaction) ap;

    function new(string name="apb_monitor", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF","APB interface not found")
    endfunction

virtual task run_phase(uvm_phase phase);

    apb_transaction tr;

    forever begin

        @(posedge vif.PCLK);

        if(vif.PSEL && vif.PENABLE) begin

            tr = apb_transaction::type_id::create("tr");

            tr.addr  = vif.PADDR;
            tr.write = vif.PWRITE;

            if(tr.write)
                tr.wdata = vif.PWDATA;
            else
                tr.rdata = vif.PRDATA;

            ap.write(tr);

        end

    end

endtask
endclass
