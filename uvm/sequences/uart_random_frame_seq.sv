`timescale 1ns/1ps

class uart_random_frame_seq extends base_sequence;

    `uvm_object_utils(uart_random_frame_seq)

    apb_transaction tr;

    rand bit [7:0] tx_data;
    rand bit [1:0] data_bits;
    rand bit       parity_en;
    rand bit       even_parity;
    rand bit       stop_bits;

    // Coverage-friendly constraints
    constraint cfg_c {
        data_bits inside {[0:3]};
    }

    constraint parity_c {
        parity_en dist {0:=1, 1:=1};
        even_parity dist {0:=1, 1:=1};
    }

    constraint stop_c {
        stop_bits dist {0:=1, 1:=1};
    }

    constraint data_c {

        tx_data dist {

            // Corner values
            8'h00 := 10,
            8'hFF := 10,
            8'h55 := 8,
            8'hAA := 8,

            // Walking ones
            8'h01 := 4,
            8'h02 := 4,
            8'h04 := 4,
            8'h08 := 4,
            8'h10 := 4,
            8'h20 := 4,
            8'h40 := 4,
            8'h80 := 4,

            // Walking zeros
            8'hFE := 4,
            8'hFD := 4,
            8'hFB := 4,
            8'hF7 := 4,
            8'hEF := 4,
            8'hDF := 4,
            8'hBF := 4,
            8'h7F := 4,

            // Everything else
            [8'h03:8'hFC] := 50
        };
    }

    function new(string name="uart_random_frame_seq");
        super.new(name);
    endfunction

    virtual task body();

        repeat (300) begin

            assert(randomize());

            //------------------------------------------------
            // Program LCR
            //------------------------------------------------

            tr = apb_transaction::type_id::create("lcr_cfg");

            start_item(tr);

            tr.write = 1;
            tr.addr  = 12'h3;

            tr.wdata = data_bits;

            if (stop_bits)
                tr.wdata |= 8'h04;

            if (parity_en)
                tr.wdata |= 8'h08;

            if (parity_en && even_parity)
                tr.wdata |= 8'h10;

            finish_item(tr);

            #100;

            //------------------------------------------------
            // Send TX byte
            //------------------------------------------------

            tr = apb_transaction::type_id::create("tx");

            start_item(tr);

            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = tx_data;

            finish_item(tr);

            #5000;

        end

    endtask

endclass