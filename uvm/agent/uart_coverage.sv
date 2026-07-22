`timescale 1ns/1ps

class uart_coverage extends uvm_subscriber #(uart_transaction);

    `uvm_component_utils(uart_coverage)

    uart_transaction tr;

    covergroup uart_cg;

        option.per_instance = 1;

        //----------------------------------------
        // Frame configuration
        //----------------------------------------

        cp_data_bits : coverpoint tr.data_bits
        {
            bins bits5 = {2'b00};
            bins bits6 = {2'b01};
            bins bits7 = {2'b10};
            bins bits8 = {2'b11};
        }

        cp_parity_enable : coverpoint tr.parity_enable
        {
            bins off = {0};
            bins on  = {1};
        }

        cp_stop_bits : coverpoint tr.stop_bits
        {
            bins one = {0};
            bins two = {1};
        }

        //----------------------------------------
        // Data
        //----------------------------------------

        cp_data : coverpoint tr.data
        {
            bins zero = {8'h00};
            bins ff   = {8'hFF};

            bins aa         = {8'hAA};
            bins fiftyfive  = {8'h55};

            bins walking1[] = {
                8'h01,8'h02,8'h04,8'h08,
                8'h10,8'h20,8'h40,8'h80
            };

            bins walking0[] = {
                8'hFE,8'hFD,8'hFB,8'hF7,
                8'hEF,8'hDF,8'hBF,8'h7F
            };

            bins others = default;
        }

        //----------------------------------------
        // Receiver status
        //----------------------------------------

        cp_rx_valid : coverpoint tr.rx_valid
        {
            bins invalid = {0};
            bins valid   = {1};
        }

        cp_parity_error : coverpoint tr.parity_error
        {
            bins no_error = {0};
            bins error    = {1};
        }

        //----------------------------------------
        // Interrupt
        //----------------------------------------

        cp_event : coverpoint tr.event_o
        {
            bins inactive = {0};
            bins active   = {1};
        }

        //----------------------------------------
        // Frame
        //----------------------------------------

        cp_start : coverpoint tr.start_bit
        {
            bins start = {1};
        }

        cp_stop : coverpoint tr.stop_bit
        {
            bins stop = {1};
        }

        //----------------------------------------
        // Crosses
        //----------------------------------------

        // Configuration combinations
        cfg_cross :
        cross cp_data_bits,
              cp_parity_enable,
              cp_stop_bits;

        // Data vs parity
        data_cfg_cross :
        cross cp_data,
              cp_parity_enable;

    endgroup


    function new(string name="uart_coverage",
                 uvm_component parent=null);
        super.new(name,parent);
        uart_cg = new();
    endfunction


    virtual function void write(uart_transaction t);

        tr = t;
        uart_cg.sample();

    endfunction


    function real get_coverage_percentage();

        return uart_cg.get_coverage();

    endfunction

endclass