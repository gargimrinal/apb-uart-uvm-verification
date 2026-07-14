`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 09:38:44
// Design Name: 
// Module Name: uart_scoreboard
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
class uart_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_scoreboard)

    uvm_analysis_imp #(uart_transaction, uart_scoreboard) analysis_imp;

    int tx_high;
    int tx_low;

    function new(string name="uart_scoreboard",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_imp = new("analysis_imp", this);
    endfunction

    virtual function void write(uart_transaction tr);

        if(tr.tx)
            tx_high++;
        else
            tx_low++;

    endfunction

    function void report_phase(uvm_phase phase);

        `uvm_info("UART_SB",
            $sformatf(
"\n\
================ UART SCOREBOARD ================\n\
TX HIGH Samples : %0d\n\
TX LOW Samples  : %0d\n\
=================================================",
            tx_high,
            tx_low),
            UVM_NONE)

    endfunction

endclass