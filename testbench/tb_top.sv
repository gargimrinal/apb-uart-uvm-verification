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
    
    apb_assertions apb_assert_inst (
    .apb_if(apb_vif)
);

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
// Monitor Connections
//----------------------------------------------------
assign uart_vif.baud_div       = {dut.regs_q[dut.DLM+'d8],
                                  dut.regs_q[dut.DLL+'d8]};
assign uart_vif.parity_enable = dut.regs_q[dut.LCR][3];
assign uart_vif.stop_bits      = dut.regs_q[dut.LCR][2];
assign uart_vif.data_bits      = dut.regs_q[dut.LCR][1:0];

assign uart_vif.parity_error   = dut.parity_error;
assign uart_vif.rx_valid       = dut.rx_valid;
assign uart_vif.rx = uart_vif.tx;
   //----------------------------------------------------
// Reset Generation
//----------------------------------------------------
initial begin

    // Hold reset active
    apb_vif.PRESETn = 0;
    uart_vif.rst_n  = 0;

    // APB idle values
    apb_vif.PSEL     = 0;
    apb_vif.PENABLE  = 0;
    apb_vif.PWRITE   = 0;
    apb_vif.PADDR    = '0;
    apb_vif.PWDATA   = '0;

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
