`timescale 1ns/1ps

class uart_frame_config_seq extends base_sequence;

    `uvm_object_utils(uart_frame_config_seq)

    apb_transaction tr;

    function new(string name="uart_frame_config_seq");
        super.new(name);
    endfunction


    virtual task body();

        byte data_list[4] = '{8'h1F,8'h3F,8'h7F,8'hFF};

        bit [7:0] lcr;

        for(int bits=0; bits<4; bits++) begin

            // 1 Stop / No Parity
            lcr = bits;
            program_uart(lcr);
            send_byte(data_list[bits]);

            // 2 Stop / No Parity
            lcr = bits | 8'h04;
            program_uart(lcr);
            send_byte(data_list[bits]);

            // 1 Stop / Odd Parity
            lcr = bits | 8'h08;
            program_uart(lcr);
            send_byte(data_list[bits]);

            // 2 Stop / Odd Parity
            lcr = bits | 8'h0C;
            program_uart(lcr);
            send_byte(data_list[bits]);

            // 1 Stop / Even Parity
            lcr = bits | 8'h18;
            program_uart(lcr);
            send_byte(data_list[bits]);

            // 2 Stop / Even Parity
            lcr = bits | 8'h1C;
            program_uart(lcr);
            send_byte(data_list[bits]);

        end

    endtask


    //--------------------------------------------------
    // Write LCR
    //--------------------------------------------------
    task program_uart(bit [7:0] lcr);

        tr = apb_transaction::type_id::create("lcr_cfg");

        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h3;
        tr.wdata = lcr;

        finish_item(tr);

        #100;

    endtask


    //--------------------------------------------------
    // Write THR
    //--------------------------------------------------
    task send_byte(bit [7:0] data);

        tr = apb_transaction::type_id::create("tx_data");

        start_item(tr);

        tr.write = 1;
        tr.addr  = 12'h0;
        tr.wdata = data;

        finish_item(tr);

        #5000;

    endtask

endclass