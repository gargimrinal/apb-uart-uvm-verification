`timescale 1ns/1ps

class uart_rx_stress_seq extends base_sequence;

    `uvm_object_utils(uart_rx_stress_seq)

    apb_transaction tr;

    byte rx_pattern[32];

    function new(string name="uart_rx_stress_seq");
        super.new(name);
    endfunction

    virtual task body();

        rx_pattern = '{
            8'h00,8'hFF,8'h55,8'hAA,
            8'h0F,8'hF0,8'h33,8'hCC,
            8'h12,8'h34,8'h56,8'h78,
            8'h9A,8'hBC,8'hDE,8'hEF,
            8'h01,8'h02,8'h04,8'h08,
            8'h10,8'h20,8'h40,8'h80,
            8'h11,8'h22,8'h44,8'h88,
            8'h5A,8'hA5,8'h7E,8'h81
        };

        //----------------------------------------------------------
        // Enable FIFO
        //----------------------------------------------------------

        tr = apb_transaction::type_id::create("fifo_enable");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h2;
        tr.wdata = 32'h01;
        finish_item(tr);

        //----------------------------------------------------------
        // Enable Interrupts
        //----------------------------------------------------------

        tr = apb_transaction::type_id::create("ier");
        start_item(tr);
        tr.write = 1;
        tr.addr  = 12'h1;
        tr.wdata = 32'h07;
        finish_item(tr);

        //----------------------------------------------------------
        // Main Stress Loop
        //----------------------------------------------------------

        foreach(rx_pattern[i]) begin

            bit [7:0] lcr_cfg;

            case(i%8)
                0: lcr_cfg = 8'h00;
                1: lcr_cfg = 8'h01;
                2: lcr_cfg = 8'h02;
                3: lcr_cfg = 8'h03;
                4: lcr_cfg = 8'h07;
                5: lcr_cfg = 8'h0B;
                6: lcr_cfg = 8'h1B;
                default: lcr_cfg = 8'h03;
            endcase

            //--------------------------------------------------
            // Every 8 frames exercise DLAB + baud divisor
            //--------------------------------------------------

            if((i%8)==0) begin

                // DLAB ON
                tr = apb_transaction::type_id::create("dlab_on");
                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h3;
                tr.wdata = 32'h83;
                finish_item(tr);

                // DLL
                tr = apb_transaction::type_id::create("dll");
                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h0;
                tr.wdata = 32'h08;
                finish_item(tr);

                // DLM
                tr = apb_transaction::type_id::create("dlm");
                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h1;
                tr.wdata = 32'h00;
                finish_item(tr);

                // DLAB OFF
                tr = apb_transaction::type_id::create("dlab_off");
                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h3;
                tr.wdata = 32'h03;
                finish_item(tr);

            end

            //--------------------------------------------------
            // Program frame format
            //--------------------------------------------------

            tr = apb_transaction::type_id::create($sformatf("lcr_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h3;
            tr.wdata = lcr_cfg;
            finish_item(tr);

            //--------------------------------------------------
            // Occasionally reset FIFOs
            //--------------------------------------------------

            if((i%10)==0) begin

                tr = apb_transaction::type_id::create("fifo_reset");

                start_item(tr);
                tr.write = 1;
                tr.addr  = 12'h2;
                tr.wdata = 32'h07;
                finish_item(tr);

            end

            //--------------------------------------------------
            // Write THR
            //--------------------------------------------------

            tr = apb_transaction::type_id::create($sformatf("tx_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = rx_pattern[i];
            finish_item(tr);

            #5000;

            //--------------------------------------------------
            // Read RBR
            //--------------------------------------------------

            tr = apb_transaction::type_id::create($sformatf("rbr_%0d",i));

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h0;
            finish_item(tr);

            //--------------------------------------------------
            // Read LSR
            //--------------------------------------------------

            tr = apb_transaction::type_id::create($sformatf("lsr_%0d",i));

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h5;
            finish_item(tr);

            //--------------------------------------------------
            // Read IIR
            //--------------------------------------------------

            tr = apb_transaction::type_id::create($sformatf("iir_%0d",i));

            start_item(tr);
            tr.write = 0;
            tr.addr  = 12'h2;
            finish_item(tr);

            #1000;

        end

    endtask

endclass