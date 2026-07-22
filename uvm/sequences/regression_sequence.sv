`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 07:33:30
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

    apb_write_seq          wr_seq;
    apb_read_seq           rd_seq;
    apb_write_read_seq     wr_rd_seq;
    apb_random_seq         rand_seq;
lcr_config_seq lcr_seq;
fifo_control_seq fifo_ctrl_seq;
baud_rate_seq baud_seq;
interrupt_seq int_seq;
uart_tx_stress_seq tx_stress_seq;
lsr_status_seq lsr_seq;
dlab_access_seq dlab_seq;
coverage_closure_seq cov_seq;
uart_rx_stress_seq rx_stress_seq;

    function new(string name = "regression_sequence");
        super.new(name);
    endfunction

    virtual task body();

        //----------------------------------------
        // Directed Write Test
        //----------------------------------------
        wr_seq = apb_write_seq::type_id::create("wr_seq");
        wr_seq.start(m_sequencer);

        //----------------------------------------
        // Directed Read Test
        //----------------------------------------
        rd_seq = apb_read_seq::type_id::create("rd_seq");
        rd_seq.start(m_sequencer);

        //----------------------------------------
        // Write followed by Read Test
        //----------------------------------------
        wr_rd_seq = apb_write_read_seq::type_id::create("wr_rd_seq");
        wr_rd_seq.start(m_sequencer);
//--------------------------------------------------
// LCR Configuration Test
//--------------------------------------------------
lcr_seq = lcr_config_seq::type_id::create("lcr_seq");
lcr_seq.start(m_sequencer);

//fifo
fifo_ctrl_seq = fifo_control_seq::type_id::create("fifo_ctrl_seq");
fifo_ctrl_seq.start(m_sequencer);
//--------------------------------------------------
// Baud Rate Programming
//--------------------------------------------------
baud_seq = baud_rate_seq::type_id::create("baud_seq");
baud_seq.start(m_sequencer);

//dlab

dlab_seq = dlab_access_seq::type_id::create("dlab_seq");
dlab_seq.start(m_sequencer);

//----------------------------------------
    // Interrupt Verification
//----------------------------------------
int_seq = interrupt_seq::type_id::create("int_seq");
int_seq.start(m_sequencer);

//----------------------------------------
// UART TX Stress
//----------------------------------------
tx_stress_seq =
    uart_tx_stress_seq::type_id::create("tx_stress_seq");


tx_stress_seq.start(m_sequencer);
//uart tx stress
rx_stress_seq =
    uart_rx_stress_seq::type_id::create("rx_stress_seq");

rx_stress_seq.start(m_sequencer);

// LSR Status Verification
//----------------------------------------
lsr_seq = lsr_status_seq::type_id::create("lsr_seq");
lsr_seq.start(m_sequencer);
//cov closure
cov_seq = coverage_closure_seq::type_id::create("cov_seq");
cov_seq.start(m_sequencer);
        //----------------------------------------
        // Random Traffic
       for (int i = 0; i < 20; i++) begin
    rand_seq = apb_random_seq::type_id::create($sformatf("rand_seq_%0d", i));
    rand_seq.start(m_sequencer);
end
    endtask

endclass