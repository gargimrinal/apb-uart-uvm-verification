`timescale 1ns / 1ps

class apb_driver extends uvm_driver #(apb_transaction);

    `uvm_component_utils(apb_driver)

    // Virtual Interface
    virtual apb_if vif;

    // Transaction Handle
    apb_transaction req;

    // Constructor
    function new(string name = "apb_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build Phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Failed to get APB virtual interface")
    endfunction

    // Run Phase
  virtual task run_phase(uvm_phase phase);

    // Drive idle values immediately
    vif.PSEL    <= 0;
    vif.PENABLE <= 0;
    vif.PWRITE  <= 0;
    vif.PADDR   <= '0;
    vif.PWDATA  <= '0;

    // Wait until reset is released
    @(posedge vif.PRESETn);

    forever begin

        seq_item_port.get_next_item(req);

        if(req.write)
            apb_write(req);
        else
            apb_read(req);

        seq_item_port.item_done();

    end

endtask
    //--------------------------------------------------------
    // APB WRITE
    //--------------------------------------------------------
    task apb_write(apb_transaction tr);

        // ---------------- Setup Phase ----------------
        @(posedge vif.PCLK);

        vif.PSEL    <= 1'b1;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= 1'b1;

        vif.PADDR   <= tr.addr;
        vif.PWDATA  <= tr.wdata;

        // ---------------- Access Phase ----------------
        @(posedge vif.PCLK);

        vif.PENABLE <= 1'b1;

        // DUT is always ready
        @(posedge vif.PCLK);

        // ---------------- Idle ----------------
        vif.PSEL    <= 1'b0;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= 1'b0;
        vif.PADDR   <= '0;
        vif.PWDATA  <= '0;

        `uvm_info(get_type_name(),
                  $sformatf("APB WRITE : ADDR = 0x%0h DATA = 0x%0h",
                            tr.addr,
                            tr.wdata),
                  UVM_MEDIUM)

    endtask


    //--------------------------------------------------------
    // APB READ
    //--------------------------------------------------------
    task apb_read(apb_transaction tr);

        // ---------------- Setup Phase ----------------
        @(posedge vif.PCLK);

        vif.PSEL    <= 1'b1;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= 1'b0;

        vif.PADDR   <= tr.addr;

        // ---------------- Access Phase ----------------
        @(posedge vif.PCLK);

        vif.PENABLE <= 1'b1;

        // DUT is always ready
        @(posedge vif.PCLK);

        tr.rdata = vif.PRDATA;

        // ---------------- Idle ----------------
        vif.PSEL    <= 1'b0;
        vif.PENABLE <= 1'b0;
        vif.PADDR   <= '0;

        `uvm_info(get_type_name(),
                  $sformatf("APB READ  : ADDR = 0x%0h DATA = 0x%0h",
                            tr.addr,
                            tr.rdata),
                  UVM_MEDIUM)

    endtask

endclass