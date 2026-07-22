`timescale 1ns/1ps

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    //------------------------------------------------------
    // Environments
    //------------------------------------------------------
    apb_env   env;
    uart_env  uart_env_h;

    //------------------------------------------------------
    // Regression Sequences
    //------------------------------------------------------
    regression_sequence reg_seq;
    uart_regression_seq uart_reg_seq;

    function new(string name="base_test",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    //------------------------------------------------------
    // Build Phase
    //------------------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env        = apb_env::type_id::create("env", this);
        uart_env_h = uart_env::type_id::create("uart_env_h", this);

    endfunction

    //------------------------------------------------------
    // Run Phase
    //------------------------------------------------------
    virtual task run_phase(uvm_phase phase);

        real apb_cov;
        real uart_cov;
        real total_cov;

        phase.raise_objection(this);

        `uvm_info(get_type_name(),
                  "Starting APB-UART Verification",
                  UVM_LOW)

        //--------------------------------------------------
        // APB Regression
        //--------------------------------------------------
        reg_seq = regression_sequence::type_id::create("reg_seq");

        //--------------------------------------------------
        // UART Regression
        //--------------------------------------------------
        uart_reg_seq =
            uart_regression_seq::type_id::create("uart_reg_seq");

        //--------------------------------------------------
        // Run both regressions in parallel
        //--------------------------------------------------
        fork
            reg_seq.start(env.agent.seqr);
            uart_reg_seq.start(env.agent.seqr);
        join

        #10000;

       //--------------------------------------------------
// Coverage
//--------------------------------------------------
apb_cov   = env.cov.get_coverage_percentage();
uart_cov  = uart_env_h.cov.get_coverage_percentage();
total_cov = (apb_cov + uart_cov)/2.0;

`uvm_info("PROJECT_COVERAGE",
    $sformatf(
"\n============================================================\n\
      APB-UART UVM VERIFICATION COVERAGE REPORT\n\
============================================================\n\
APB Functional Coverage   : %0.2f%%\n\
UART Functional Coverage  : %0.2f%%\n\
------------------------------------------------------------\n\
Overall Functional Coverage : %0.2f%%\n\
============================================================",
        apb_cov,
        uart_cov,
        total_cov),
        UVM_NONE);

        `uvm_info("TEST_DONE",
                  "Simulation Completed Successfully",
                  UVM_LOW)

        phase.drop_objection(this);

    endtask

endclass