`timescale 1ns / 1ps

class coverage_closure_seq extends base_sequence;

    `uvm_object_utils(coverage_closure_seq)

    apb_transaction tr;

    function new(string name="coverage_closure_seq");
        super.new(name);
    endfunction

    virtual task body();

        //==================================================
        // Variable Declarations (must come first)
        //==================================================

        byte lcr_vals[];
        byte div_vals[];
        byte data_vals[];
        int  regs[];

        int i;

        //==================================================
        // Initialize Arrays
        //==================================================

        lcr_vals = '{
            8'h00,   // 5-bit
            8'h01,   // 6-bit
            8'h02,   // 7-bit
            8'h03,   // 8-bit
            8'h07,   // 2 stop bits
            8'h0B,   // parity enable
            8'h1B,   // even parity
            8'h3B,   // stick parity
            8'h43,   // break control
            8'h80    // DLAB
        };

        div_vals = '{
            8'h00,
            8'h01,
            8'h02,
            8'h55,
            8'h80,
            8'hC8,
            8'hFF
        };

        data_vals = '{
            8'h00,
            8'h01,
            8'h3F,
            8'h40,
            8'h7F,
            8'h80,
            8'hBF,
            8'hC0,
            8'hFE,
            8'hFF
        };

        regs = '{0,1,2,3,5};

        //==================================================
        // LCR Coverage
        //==================================================

        foreach (lcr_vals[i]) begin

            tr = apb_transaction::type_id::create($sformatf("lcr_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h3;
            tr.wdata = lcr_vals[i];
            finish_item(tr);

        end

        //==================================================
        // IER Coverage
        //==================================================

        for(i=0;i<8;i++) begin

            tr = apb_transaction::type_id::create($sformatf("ier_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h1;
            tr.wdata = i;
            finish_item(tr);

        end

        //==================================================
        // Divisor Coverage
        //==================================================

        foreach(div_vals[i]) begin

            // DLL
            tr = apb_transaction::type_id::create($sformatf("dll_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = div_vals[i];
            finish_item(tr);

            // DLM
            tr = apb_transaction::type_id::create($sformatf("dlm_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h1;
            tr.wdata = div_vals[i];
            finish_item(tr);

        end

        //==================================================
        // Write Data Coverage
        //==================================================

        foreach(data_vals[i]) begin

            tr = apb_transaction::type_id::create($sformatf("data_%0d",i));

            start_item(tr);
            tr.write = 1;
            tr.addr  = 12'h0;
            tr.wdata = data_vals[i];
            finish_item(tr);

        end

        //==================================================
        // Register Reads
        //==================================================

        foreach(regs[i]) begin

            tr = apb_transaction::type_id::create($sformatf("read_%0d",regs[i]));

            start_item(tr);
            tr.write = 0;
            tr.addr  = regs[i];
            finish_item(tr);

        end

    endtask

endclass