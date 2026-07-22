`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: apb_scoreboard
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
// Basic APB Scoreboard
//
// Revision:
// Revision 0.01 - File Created

class apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_scoreboard)

    // Analysis port
    uvm_analysis_imp #(apb_transaction, apb_scoreboard) analysis_imp;

    //----------------------------------------------------
    // UART Register Model
    //----------------------------------------------------
    bit [7:0] ier_model;
    bit [7:0] lcr_model;
    bit [7:0] dll_model;
    bit [7:0] dlm_model;

    bit dlab_mode;

    //----------------------------------------------------
    // Constructor
    //----------------------------------------------------
    function new(string name="apb_scoreboard",
                 uvm_component parent=null);
        super.new(name,parent);
    endfunction

    //----------------------------------------------------
    // Build
    //----------------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_imp = new("analysis_imp", this);

        ier_model = 8'h00;
        lcr_model = 8'h00;
        dll_model = 8'h00;
        dlm_model = 8'h00;

        dlab_mode = 1'b0;
    endfunction

    //----------------------------------------------------
    // Receive APB transactions
    //----------------------------------------------------
 virtual function void write(apb_transaction tr);

    //-----------------------------------------
    // WRITE Transactions
    //-----------------------------------------
    if (tr.write) begin

        case (tr.addr)

            // Address 0x0 : THR / DLL
            12'h0: begin
                if (dlab_mode)
                    dll_model = tr.wdata[7:0];
            end

            // Address 0x1 : IER / DLM
            12'h1: begin
                if (dlab_mode)
                    dlm_model = tr.wdata[7:0];
                else
                    ier_model = tr.wdata[7:0];
            end

            // Address 0x3 : LCR
            12'h3: begin
                lcr_model = tr.wdata[7:0];
                dlab_mode = tr.wdata[7];
            end

            default: begin
            end

        endcase

        `uvm_info("SCOREBOARD",
            $sformatf("WRITE : ADDR=0x%0h DATA=0x%02h",
                      tr.addr,
                      tr.wdata[7:0]),
            UVM_MEDIUM);

    end

    //-----------------------------------------
    // READ Transactions
    //-----------------------------------------
    else begin

        case (tr.addr)

            //-------------------------------------------------
            // Address 0x0 : RBR / DLL
            //-------------------------------------------------
            12'h0: begin

                if (dlab_mode) begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("READ DLL : DATA=0x%02h (Not Checked)",
                                  tr.rdata[7:0]),
                        UVM_LOW);

                end
                else begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("READ RBR : DATA=0x%02h (Not Checked)",
                                  tr.rdata[7:0]),
                        UVM_LOW);

                end

            end

            //-------------------------------------------------
            // Address 0x1 : IER / DLM
            //-------------------------------------------------
            12'h1: begin

                if (dlab_mode) begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("READ DLM : DATA=0x%02h (Not Checked)",
                                  tr.rdata[7:0]),
                        UVM_LOW);

                end
                else begin

                    if (ier_model == tr.rdata[7:0]) begin

                        `uvm_info("SCOREBOARD",
                            $sformatf("PASS : IER EXPECTED=0x%02h ACTUAL=0x%02h",
                                      ier_model,
                                      tr.rdata[7:0]),
                            UVM_LOW);

                    end
                    else begin

                        `uvm_error("SCOREBOARD",
                            $sformatf("FAIL : IER EXPECTED=0x%02h ACTUAL=0x%02h",
                                      ier_model,
                                      tr.rdata[7:0]));

                    end

                end

            end

            //-------------------------------------------------
            // Address 0x3 : LCR
            //-------------------------------------------------
            12'h3: begin

                if (lcr_model == tr.rdata[7:0]) begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("PASS : LCR EXPECTED=0x%02h ACTUAL=0x%02h",
                                  lcr_model,
                                  tr.rdata[7:0]),
                        UVM_LOW);

                end
                else begin

                    `uvm_error("SCOREBOARD",
                        $sformatf("FAIL : LCR EXPECTED=0x%02h ACTUAL=0x%02h",
                                  lcr_model,
                                  tr.rdata[7:0]));

                end

            end

            //-------------------------------------------------
            // Other Registers
            //-------------------------------------------------
            default: begin

                `uvm_info("SCOREBOARD",
                    $sformatf("READ : ADDR=0x%0h DATA=0x%02h (Not Checked)",
                              tr.addr,
                              tr.rdata[7:0]),
                    UVM_LOW);

            end

        endcase

    end

endfunction
endclass