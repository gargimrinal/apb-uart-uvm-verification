`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:09:57
// Design Name: 
// Module Name: apb_agent
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

class apb_agent extends uvm_agent;

    `uvm_component_utils(apb_agent)

    apb_driver     drv;
    apb_sequencer  seqr;
    apb_monitor    mon;

    function new(string name = "apb_agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        drv  = apb_driver   ::type_id::create("drv",  this);
        seqr = apb_sequencer::type_id::create("seqr", this);
        mon  = apb_monitor  ::type_id::create("mon",  this);

    endfunction

    virtual function void connect_phase(uvm_phase phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass