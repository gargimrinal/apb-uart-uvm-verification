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
// Simple APB UART Scoreboard with Register Mirror
//////////////////////////////////////////////////////////////////////////////////

class apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_scoreboard)



    uvm_analysis_imp #(apb_transaction, apb_scoreboard) analysis_imp;

    

    bit [31:0] reg_model [0:7];

   

    function new(string name = "apb_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

   

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_imp = new("analysis_imp", this);

        foreach (reg_model[i])
            reg_model[i] = 32'h0;
    endfunction

    

    virtual function void write(apb_transaction tr);

        

        if (tr.write) begin

            case (tr.addr)

                // Software writable registers
                3'h1,
                3'h3,
                3'h4,
                3'h7:
                begin
                    reg_model[tr.addr] = tr.wdata;
                end

                default:
                begin
                    // THR/RBR/DLL etc.
                end

            endcase

            `uvm_info("SCOREBOARD",
                $sformatf("WRITE : ADDR = 0x%0h DATA = 0x%0h",
                          tr.addr,
                          tr.wdata),
                UVM_MEDIUM)

        end

        else begin

            case (tr.addr)
                3'h1,
                3'h3,
                3'h4,
                3'h7:
                begin

                    if (reg_model[tr.addr] == tr.rdata) begin

                        `uvm_info("SCOREBOARD",
                            $sformatf("PASS : ADDR = 0x%0h EXPECTED = 0x%0h ACTUAL = 0x%0h",
                                      tr.addr,
                                      reg_model[tr.addr],
                                      tr.rdata),
                            UVM_LOW)

                    end
                    else begin

                        `uvm_error("SCOREBOARD",
                            $sformatf("FAIL : ADDR = 0x%0h EXPECTED = 0x%0h ACTUAL = 0x%0h",
                                      tr.addr,
                                      reg_model[tr.addr],
                                      tr.rdata))

                    end

                end

                default:
                begin

                    `uvm_info("SCOREBOARD",
                        $sformatf("READ : ADDR = 0x%0h DATA = 0x%0h (Not Checked)",
                                  tr.addr,
                                  tr.rdata),
                        UVM_LOW)

                end

            endcase

        end

    endfunction

endclass