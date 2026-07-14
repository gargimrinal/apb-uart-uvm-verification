`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 19:22:41
// Design Name: 
// Module Name: regression_sequence
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

class regression_sequence extends base_sequence;

    `uvm_object_utils(regression_sequence)

    apb_write_seq    wr_seq;
    apb_read_seq     rd_seq;
    apb_random_seq   rand_seq;
    apb_write_read_seq wr_rd_seq;

    function new(string name="regression_sequence");
        super.new(name);
    endfunction

    virtual task body();

        // Directed write tests
        repeat (20) begin
            wr_seq = apb_write_seq::type_id::create("wr_seq");
            wr_seq.start(m_sequencer);
        end

        // Directed read tests
        repeat (20) begin
            rd_seq = apb_read_seq::type_id::create("rd_seq");
            rd_seq.start(m_sequencer);
        end

        // Write followed by read
        repeat (20) begin
            wr_rd_seq = apb_write_read_seq::type_id::create("wr_rd_seq");
            wr_rd_seq.start(m_sequencer);
        end

        // Random traffic
        repeat (20) begin
            rand_seq = apb_random_seq::type_id::create("rand_seq");
            rand_seq.start(m_sequencer);
        end

    endtask

endclass