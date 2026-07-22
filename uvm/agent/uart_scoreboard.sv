`timescale 1ns/1ps

class uart_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_scoreboard)

    uvm_analysis_imp #(uart_transaction, uart_scoreboard) analysis_imp;

    //----------------------------------------------------
    // Statistics
    //----------------------------------------------------

    int total_frames;
    int good_frames;

    int framing_errors;
    int parity_errors;

    int rx_valid_count;
    int interrupt_count;

    function new(string name="uart_scoreboard",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_imp = new("analysis_imp", this);
    endfunction

    virtual function void write(uart_transaction tr);

        total_frames++;

        //--------------------------------------------------
        // Start bit check
        //--------------------------------------------------

        if (tr.start_bit != 1'b1) begin
            `uvm_error("UART_SB",
                $sformatf("Missing START bit DATA=%02h", tr.data))
        end

        //--------------------------------------------------
        // Stop bit statistics only
        //--------------------------------------------------
        // DUT does not implement framing-error detection.
        // Therefore STOP_BIT is treated as informational only.
        //--------------------------------------------------

        if (tr.stop_bit != 1'b1) begin

            framing_errors++;

            `uvm_info("UART_SB",
                $sformatf(
"\n---------------- STOP BIT WARNING ----------------\n\
DATA        : %02h\n\
START BIT   : %0b\n\
STOP BIT    : %0b\n\
DATA BITS   : %0d\n\
PARITY EN   : %0b\n\
STOP2       : %0b\n\
PARITY BIT  : %0b\n\
RX_VALID    : %0b\n\
EVENT       : %0b\n\
PARITY_ERR  : %0b\n\
TIME        : %0t\n\
----------------------------------------------------",

                tr.data,
                tr.start_bit,
                tr.stop_bit,
                tr.data_bits,
                tr.parity_enable,
                tr.stop_bits,
                tr.parity,
                tr.rx_valid,
                tr.event_o,
                tr.parity_error,
                tr.timestamp),
                UVM_MEDIUM);

        end

        //--------------------------------------------------
        // DUT status
        //--------------------------------------------------

        if (tr.parity_error)
            parity_errors++;

        if (tr.rx_valid)
            rx_valid_count++;

        if (tr.event_o)
            interrupt_count++;

        //--------------------------------------------------
        // Good frame
        //--------------------------------------------------
        // NOTE:
        // DUT does not implement framing-error detection.
        // Therefore STOP_BIT is NOT used to reject frames.
        //--------------------------------------------------

        if (tr.start_bit &&
            tr.rx_valid &&
            !tr.parity_error)
        begin
            good_frames++;
        end

    endfunction

endclass