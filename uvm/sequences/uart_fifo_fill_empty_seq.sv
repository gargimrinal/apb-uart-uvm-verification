`timescale 1ns/1ps

class uart_fifo_fill_empty_seq extends uart_base_sequence;

    `uvm_object_utils(uart_fifo_fill_empty_seq)

    apb_transaction tr;

    int fill_levels[5] = '{1,4,8,15,16};

    function new(string name="uart_fifo_fill_empty_seq");
        super.new(name);
    endfunction

    virtual task body();

        //--------------------------------------------------
        // Enable FIFO
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("fifo_enable");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;          // FCR
        tr.wdata = 32'h01;         // FIFO Enable
        finish_item(tr);

        //--------------------------------------------------
        // Exercise different FIFO fill levels
        //--------------------------------------------------

        foreach(fill_levels[k]) begin

            `uvm_info(get_type_name(),
                $sformatf("Testing FIFO Fill Level = %0d",fill_levels[k]),
                UVM_LOW)

            //-----------------------------
            // Fill FIFO
            //-----------------------------

            for(int i=0;i<fill_levels[k];i++) begin

                tr = apb_transaction::type_id::create(
                        $sformatf("fill_%0d_%0d",fill_levels[k],i));

                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h0;      // THR
                tr.wdata = i;
                finish_item(tr);

            end

            #20000;

            //-----------------------------
            // Read LSR
            //-----------------------------

            tr = apb_transaction::type_id::create(
                    $sformatf("lsr_%0d",fill_levels[k]));

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;
            finish_item(tr);

            //-----------------------------
            // Read IIR
            //-----------------------------

            tr = apb_transaction::type_id::create(
                    $sformatf("iir_%0d",fill_levels[k]));

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h2;
            finish_item(tr);

            //-----------------------------
            // Let UART transmit
            //-----------------------------

            #50000;

        end

        //--------------------------------------------------
        // Try writing after FIFO is full
        //--------------------------------------------------

        `uvm_info(get_type_name(),
            "Attempting FIFO Overflow Writes",
            UVM_LOW)

        repeat(4) begin

            tr = apb_transaction::type_id::create("overflow_write");

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = $urandom_range(0,255);
            finish_item(tr);

        end

        #50000;

        //--------------------------------------------------
        // Check LSR after drain
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("lsr_after_drain");

        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);

        //--------------------------------------------------
        // Check IIR after drain
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("iir_after_drain");

        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        //--------------------------------------------------
        // Reset FIFOs
        //--------------------------------------------------

        `uvm_info(get_type_name(),
            "Resetting FIFOs",
            UVM_LOW)

        tr = apb_transaction::type_id::create("fifo_reset");

        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h07;
        finish_item(tr);

        #10000;

        //--------------------------------------------------
        // Read Empty RX FIFO
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("empty_rx_read");

        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h0;
        finish_item(tr);

        //--------------------------------------------------
        // Read LSR after reset
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("lsr_after_reset");

        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h5;
        finish_item(tr);

        //--------------------------------------------------
        // Read IIR after reset
        //--------------------------------------------------

        tr = apb_transaction::type_id::create("iir_after_reset");

        start_item(tr);
        tr.write = 0;
        tr.addr  = 12'h2;
        finish_item(tr);

        #20000;

        `uvm_info(get_type_name(),
            "FIFO Verification Sequence Completed",
            UVM_LOW)

    endtask

endclass