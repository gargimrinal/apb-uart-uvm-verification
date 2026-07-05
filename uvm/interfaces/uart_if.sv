`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 09:05:18
// Design Name: 
// Module Name: uart_if
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
interface uart_if(input logic clk);

    logic rst_n;

    // UART serial lines
    logic tx;
    logic rx;

    // Interrupt
    logic event_o;

endinterface
