`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 09:40:04
// Design Name: 
// Module Name: uart_coverage
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
class uart_coverage extends uvm_subscriber #(uart_transaction);

    `uvm_component_utils(uart_coverage)

    uart_transaction tr;

  covergroup uart_cg;

    option.per_instance = 1;

    //-----------------------------------------
    // TX Activity
    //-----------------------------------------
    cp_tx : coverpoint tr.tx
    {
        bins idle  = {1};
        bins start = {0};
    }

    //-----------------------------------------
    // RX Activity
    //-----------------------------------------
    cp_rx : coverpoint tr.rx
    {
        bins idle  = {1};
        bins start = {0};
    }

    //-----------------------------------------
    // UART Start Bit
    //-----------------------------------------
    cp_start : coverpoint tr.start_bit
    {
        bins detected     = {1};
        bins not_detected = {0};
    }

    //-----------------------------------------
    // UART Stop Bit
    //-----------------------------------------
    cp_stop : coverpoint tr.stop_bit
    {
        bins detected     = {1};
        bins not_detected = {0};
    }

    //-----------------------------------------
    // Interrupt/Event
    //-----------------------------------------
    cp_event : coverpoint tr.event_o
    {
        bins inactive = {0};
        bins active   = {1};
    }

    //-----------------------------------------
    // Cross Coverage
    //-----------------------------------------
    tx_start_cross  : cross cp_tx, cp_start;
    rx_start_cross  : cross cp_rx, cp_start;
    stop_event_cross: cross cp_stop, cp_event;

endgroup

    function new(string name="uart_coverage",
                 uvm_component parent=null);

        super.new(name,parent);
        uart_cg = new();

    endfunction


    virtual function void write(uart_transaction t);

        tr = t;
        uart_cg.sample();
endfunction

function real get_coverage_percentage();
    return uart_cg.get_coverage();
endfunction


endclass