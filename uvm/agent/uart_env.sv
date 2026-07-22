`timescale 1ns/1ps

class uart_env extends uvm_env;

    `uvm_component_utils(uart_env)

    //--------------------------------------------------
    // Components
    //--------------------------------------------------

    uart_monitor     mon;
    uart_scoreboard  sb;
    uart_coverage    cov;

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name="uart_env",
                 uvm_component parent=null);

        super.new(name,parent);

    endfunction

    //--------------------------------------------------
    // Build
    //--------------------------------------------------

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        mon = uart_monitor    ::type_id::create("mon", this);
        sb  = uart_scoreboard ::type_id::create("sb",  this);
        cov = uart_coverage   ::type_id::create("cov", this);

    endfunction

    //--------------------------------------------------
    // Connect
    //--------------------------------------------------

    virtual function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        // Monitor -> Scoreboard
        mon.ap.connect(sb.analysis_imp);

        // Monitor -> Coverage
        mon.ap.connect(cov.analysis_export);

    endfunction

endclass