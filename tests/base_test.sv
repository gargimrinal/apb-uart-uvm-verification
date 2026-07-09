`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:01:32
// Design Name: 
// Module Name: base_test
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

class base_test extends uvm_test;

    `uvm_component_utils(base_test)
apb_env env;
    function new(string name = "base_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

 virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = apb_env::type_id::create("env", this);

endfunction
virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
endfunction
task run_phase(uvm_phase phase);
apb_write_seq wr_seq;
apb_read_seq  rd_seq;

phase.raise_objection(this);

wr_seq = apb_write_seq::type_id::create("wr_seq");
rd_seq = apb_read_seq::type_id::create("rd_seq");

wr_seq.start(env.agent.seqr);

#20ns;

rd_seq.start(env.agent.seqr);

#100ns;

phase.drop_objection(this);
    endtask
endclass
