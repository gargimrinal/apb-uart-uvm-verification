`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 09:34:23
// Design Name: 
// Module Name: uart_monitor
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
class uart_monitor extends uvm_monitor;

    `uvm_component_utils(uart_monitor)

    virtual uart_if vif;

    uvm_analysis_port #(uart_transaction) ap;

    function new(string name="uart_monitor",
                 uvm_component parent=null);
        super.new(name,parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_vif",vif))
            `uvm_fatal("UART_MON","Failed to get uart_vif")
    endfunction
task run_phase(uvm_phase phase);

    uart_transaction tr;

    forever begin

        @(posedge vif.clk);

        // Sample only when UART activity is present
        if (vif.tx != 1'b1 || vif.rx != 1'b1 || vif.event_o) begin

            tr = uart_transaction::type_id::create("tr");

            tr.tx      = vif.tx;
            tr.rx      = vif.rx;
            tr.event_o = vif.event_o;

            // Basic protocol information
            tr.start_bit = (vif.tx == 1'b0);
            tr.stop_bit  = (vif.tx == 1'b1);

            // Placeholders until we implement frame decoding
            tr.data   = 8'h00;
            tr.parity = 1'b0;

            ap.write(tr);

            `uvm_info("UART_MON",
                $sformatf("TX=%0b RX=%0b START=%0b STOP=%0b EVENT=%0b",
                          tr.tx,
                          tr.rx,
                          tr.start_bit,
                          tr.stop_bit,
                          tr.event_o),
                UVM_MEDIUM)

        end

    end

endtask
endclass