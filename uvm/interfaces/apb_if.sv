interface apb_if(input logic PCLK);

    // Reset
    logic PRESETn;

    // APB signals
    logic [11:0] PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;

    logic PWRITE;
    logic PSEL;
    logic PENABLE;
    logic PREADY;
    logic PSLVERR;

endinterface