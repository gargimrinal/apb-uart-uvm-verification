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
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Module Name: apb_scoreboard
// Description:

class apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_scoreboard)

    // Analysis implementation port
    uvm_analysis_imp #(apb_transaction, apb_scoreboard) analysis_imp;

    // Reference model (8-bit UART registers)
    bit [7:0] reg_model [0:7];

    // Constructor
    function new(string name = "apb_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_imp = new("analysis_imp", this);

        foreach (reg_model[i])
            reg_model[i] = 8'h00;
    endfunction

    // Receive transactions from monitor
    virtual function void write(apb_transaction tr);

        if (tr.write) begin

            case (tr.addr)

                // Implemented writable registers
                3'h1,   // IER
                3'h3:   // LCR
                begin
                    reg_model[tr.addr] = tr.wdata[7:0];
                end

                default: begin
                    // THR/FCR/FIFO/status registers are not mirrored
                end

            endcase

            `uvm_info("SCOREBOARD",
                $sformatf("WRITE : ADDR = 0x%0h DATA = 0x%02h",
                          tr.addr,
                          tr.wdata[7:0]),
                UVM_MEDIUM)

        end

        else begin

            case (tr.addr)

                // Implemented readable mirrored registers
                3'h1,   // IER
                3'h3:   // LCR
                begin
                    if (reg_model[tr.addr] == tr.rdata[7:0]) begin

                        `uvm_info("SCOREBOARD",
                            $sformatf("PASS : ADDR = 0x%0h EXPECTED = 0x%02h ACTUAL = 0x%02h",
                                      tr.addr,
                                      reg_model[tr.addr],
                                      tr.rdata[7:0]),
                            UVM_LOW)

                    end
                    else begin

                        `uvm_error("SCOREBOARD",
                            $sformatf("FAIL : ADDR = 0x%0h EXPECTED = 0x%02h ACTUAL = 0x%02h",
                                      tr.addr,
                                      reg_model[tr.addr],
                                      tr.rdata[7:0]))

                    end
                end

                default: begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("READ : ADDR = 0x%0h DATA = 0x%02h (Not Checked)",
                                  tr.addr,
                                  tr.rdata[7:0]),
                        UVM_LOW)

                end

            endcase

        end

    endfunction

endclass