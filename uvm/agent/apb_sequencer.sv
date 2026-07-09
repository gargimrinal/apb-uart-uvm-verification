`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 09:29:35
// Design Name: 
// Module Name: apb_sequencer
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
class apb_sequencer extends uvm_sequencer #(apb_transaction);

    `uvm_component_utils(apb_sequencer)

    function new(string name = "apb_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
