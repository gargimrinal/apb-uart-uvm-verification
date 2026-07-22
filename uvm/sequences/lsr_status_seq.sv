`timescale 1ns / 1ps

class lsr_status_seq extends base_sequence;

    `uvm_object_utils(lsr_status_seq)

    apb_transaction tr;

    function new(string name="lsr_status_seq");
        super.new(name);
    endfunction

    virtual task body();

        //-------------------------------------------------
        // Read LSR immediately after reset
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("lsr_read_reset");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);

        //-------------------------------------------------
        // Write one byte to THR
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("tx_write");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h0;      // THR
        tr.wdata = 32'hA5;
        finish_item(tr);

        //-------------------------------------------------
        // Read LSR after transmit write
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("lsr_read_tx");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);

        //-------------------------------------------------
        // Read LSR again
        //-------------------------------------------------
        tr = apb_transaction::type_id::create("lsr_read_final");
        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);

    endtask

endclass