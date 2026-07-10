`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:15:06
// Design Name: 
// Module Name: apb_env
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

class apb_env extends uvm_env;

    `uvm_component_utils(apb_env)

    apb_agent agent;
    apb_scoreboard sb;

    function new(string name="apb_env",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = apb_agent::type_id::create("agent", this);
        sb    = apb_scoreboard::type_id::create("sb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.mon.ap.connect(sb.analysis_imp);
    endfunction

endclass