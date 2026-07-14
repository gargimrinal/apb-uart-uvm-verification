`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 09:37:02
// Design Name: 
// Module Name: uart_env
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

class uart_env extends uvm_env;

    `uvm_component_utils(uart_env)

    uart_monitor    mon;
    uart_scoreboard sb;
    uart_coverage   cov;

    function new(string name="uart_env",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = uart_monitor   ::type_id::create("mon", this);
        sb  = uart_scoreboard::type_id::create("sb", this);
        cov = uart_coverage  ::type_id::create("cov", this);
    endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor to scoreboard
    mon.ap.connect(sb.analysis_imp);

    // Connect monitor to coverage
    mon.ap.connect(cov.analysis_export);

endfunction

endclass
