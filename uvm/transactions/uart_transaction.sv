`timescale 1ns/1ps

class uart_transaction extends uvm_sequence_item;

    `uvm_object_utils(uart_transaction)

    //--------------------------------------------
    // UART Frame
    //--------------------------------------------
    rand bit [7:0] data;

    bit start_bit;
    bit stop_bit;
    bit parity;

    //--------------------------------------------
    // UART Configuration
    //--------------------------------------------
    bit [1:0] data_bits;
    bit parity_enable;
    bit stop_bits;

    bit [15:0] baud_div;

    //--------------------------------------------
    // DUT Status
    //--------------------------------------------
    bit rx_valid;
    bit parity_error;
    bit event_o;

    //--------------------------------------------
    // Statistics
    //--------------------------------------------
    time timestamp;

    function new(string name="uart_transaction");
        super.new(name);
    endfunction

    //------------------------------------------------------------
    // Print
    //------------------------------------------------------------
    function string convert2string();

        return $sformatf(
            "DATA=%02h START=%0b STOP=%0b PARITY=%0b BITS=%0d PAR_EN=%0b STOP2=%0b BAUD=%0d RX_VALID=%0b EVENT=%0b PAR_ERR=%0b",
            data,
            start_bit,
            stop_bit,
            parity,
            data_bits,
            parity_enable,
            stop_bits,
            baud_div,
            rx_valid,
            event_o,
            parity_error
        );

    endfunction

endclass