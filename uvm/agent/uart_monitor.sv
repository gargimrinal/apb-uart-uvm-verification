`timescale 1ns/1ps

class uart_monitor extends uvm_monitor;

    `uvm_component_utils(uart_monitor)

    virtual uart_if vif;

    uvm_analysis_port #(uart_transaction) ap;

    function new(string name="uart_monitor",
                 uvm_component parent=null);
        super.new(name,parent);
        ap = new("ap",this);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_vif",vif))
            `uvm_fatal("UART_MON","Cannot get uart_if")
    endfunction

task run_phase(uvm_phase phase);

    uart_transaction tr;

    int baud_cycles;
    int nbits;

    forever begin

        //--------------------------------------------
        // Wait for start bit
        //--------------------------------------------
        @(negedge vif.tx);

        tr = uart_transaction::type_id::create("tr");

        tr.timestamp     = $time;
        tr.start_bit     = 1'b1;

        tr.parity_enable = vif.parity_enable;
        tr.data_bits     = vif.data_bits;
        tr.stop_bits     = vif.stop_bits;

        baud_cycles = (vif.baud_div == 0) ? 1 : vif.baud_div;

        case(tr.data_bits)
            2'b00 : nbits = 5;
            2'b01 : nbits = 6;
            2'b10 : nbits = 7;
            default: nbits = 8;
        endcase

        tr.data = '0;

        //--------------------------------------------
        // Move to center of first data bit
        //--------------------------------------------
        repeat((baud_cycles*3)/2)
            @(posedge vif.clk);

        //--------------------------------------------
        // Sample data bits
        //--------------------------------------------
        for(int i=0;i<nbits;i++) begin

            tr.data[i] = vif.tx;

            if(i != nbits-1)
                repeat(baud_cycles)
                    @(posedge vif.clk);

        end

        //--------------------------------------------
        // Move to parity/stop
        //--------------------------------------------
        repeat(baud_cycles)
            @(posedge vif.clk);

        //--------------------------------------------
        // Sample parity
        //--------------------------------------------
        if(tr.parity_enable) begin

            tr.parity = vif.tx;

            repeat(baud_cycles)
                @(posedge vif.clk);

        end
        else
            tr.parity = 1'b0;

        //--------------------------------------------
        // Sample stop bit immediately
        //--------------------------------------------
        tr.stop_bit = vif.tx;

        if(tr.stop_bits)
            repeat(baud_cycles)
                @(posedge vif.clk);

        //--------------------------------------------
        // Latch status pulses
        //--------------------------------------------
        tr.rx_valid     = 0;
        tr.parity_error = 0;
        tr.event_o      = 0;

        repeat(5) begin
            @(posedge vif.clk);

            if(vif.rx_valid)
                tr.rx_valid = 1;

            if(vif.parity_error)
                tr.parity_error = 1;

            if(vif.event_o)
                tr.event_o = 1;
        end

        //--------------------------------------------
        // Publish transaction
        //--------------------------------------------
        ap.write(tr);

        `uvm_info("UART_MON",
            $sformatf(
            "DATA=%02h START=%0b STOP=%0b PARITY=%0b RX_VALID=%0b EVENT=%0b PARITY_ERR=%0b",
            tr.data,
            tr.start_bit,
            tr.stop_bit,
            tr.parity,
            tr.rx_valid,
            tr.event_o,
            tr.parity_error),
            UVM_MEDIUM)

    end

endtask
endclass