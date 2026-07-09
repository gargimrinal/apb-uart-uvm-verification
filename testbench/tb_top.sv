`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 13:51:25
// Design Name: 
// Module Name: tb_top
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
`timescale 1ns/1ps

module tb_top;

    import uvm_pkg::*;
    import apb_uart_pkg::*;

    //----------------------------------------------------
    // Clock
    //----------------------------------------------------
    logic clk;

    initial
        clk = 0;

    always #5 clk = ~clk;

    //----------------------------------------------------
    // Interfaces
    //----------------------------------------------------
    apb_if  apb_vif(clk);
    uart_if uart_vif(clk);

    //----------------------------------------------------
    // DUT
    //----------------------------------------------------
    apb_uart_sv dut
    (
        .CLK      (clk),
        .RSTN     (apb_vif.PRESETn),

        .PADDR    (apb_vif.PADDR),
        .PWDATA   (apb_vif.PWDATA),
        .PWRITE   (apb_vif.PWRITE),
        .PSEL     (apb_vif.PSEL),
        .PENABLE  (apb_vif.PENABLE),

        .PRDATA   (apb_vif.PRDATA),
        .PREADY   (apb_vif.PREADY),
        .PSLVERR  (apb_vif.PSLVERR),

        .rx_i      (uart_vif.rx),
        .tx_o      (uart_vif.tx),
        .event_o   (uart_vif.event_o)
    );

    //----------------------------------------------------
    // Reset Generation
    //----------------------------------------------------
    initial begin

        apb_vif.PRESETn = 0;
        uart_vif.rst_n  = 0;

        repeat(5) @(posedge clk);

        apb_vif.PRESETn = 1;
        uart_vif.rst_n  = 1;

    end

    //----------------------------------------------------
    // UVM Configuration
    //----------------------------------------------------
    initial begin

        uvm_config_db#(virtual apb_if)::set(
            null,
            "*",
            "vif",
            apb_vif
        );

        uvm_config_db#(virtual uart_if)::set(
            null,
            "*",
            "uart_vif",
            uart_vif
        );

        run_test("base_test");

    end

endmodule
