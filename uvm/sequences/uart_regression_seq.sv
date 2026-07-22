`timescale 1ns/1ps

class uart_regression_seq extends base_sequence;

    `uvm_object_utils(uart_regression_seq)

    uart_frame_config_seq      frame_seq;
    uart_interrupt_seq         interrupt_seq;
 uart_lcr_exhaustive_seq    lcr_seq;
uart_baud_sweep_seq baud_seq;
uart_fifo_fill_empty_seq fifo_seq;
uart_random_frame_seq      random_seq;
    uart_tx_stress_seq         tx_stress_seq;
    uart_rx_stress_seq         rx_stress_seq;




    function new(string name="uart_regression_seq");
        super.new(name);
    endfunction

    virtual task body();

        //--------------------------------------------------
        // Frame configuration sweep
        //--------------------------------------------------
        frame_seq =
            uart_frame_config_seq::type_id::create("frame_seq");
        frame_seq.start(m_sequencer);


        //--------------------------------------------------
        // Interrupt verification
        //--------------------------------------------------
        interrupt_seq =
            uart_interrupt_seq::type_id::create("interrupt_seq");
        interrupt_seq.start(m_sequencer);
   //--------------------------------------------------
        // Exhaustive LCR sweep
        //--------------------------------------------------
        lcr_seq =
            uart_lcr_exhaustive_seq::type_id::create("lcr_seq");
        lcr_seq.start(m_sequencer);
//baud

baud_seq =
    uart_baud_sweep_seq::type_id::create("baud_seq");
baud_seq.start(m_sequencer);

//fifo
fifo_seq =
    uart_fifo_fill_empty_seq::type_id::create("fifo_seq");

//--------------------------------------------------
        // Random UART frames
        //--------------------------------------------------
        random_seq =
            uart_random_frame_seq::type_id::create("random_seq");
        random_seq.start(m_sequencer);


fifo_seq.start(m_sequencer);

                //--------------------------------------------------
        // Heavy TX traffic
        //--------------------------------------------------
        repeat (5) begin

            tx_stress_seq =
                uart_tx_stress_seq::type_id::create(
                    $sformatf("tx_%0t", $time));

            tx_stress_seq.start(m_sequencer);

        end

        //--------------------------------------------------
        // Heavy RX traffic
        //--------------------------------------------------
        repeat (5) begin

            rx_stress_seq =
                uart_rx_stress_seq::type_id::create(
                    $sformatf("rx_%0t", $time));

            rx_stress_seq.start(m_sequencer);

        end

    endtask

endclass