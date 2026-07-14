`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 08:43:10
// Design Name: 
// Module Name: apb_assertions
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

module apb_assertions(apb_if apb_if);

    //  PENABLE must follow PSEL
  
    property p_enable_after_psel;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        (apb_if.PSEL && !apb_if.PENABLE)
        |=> (apb_if.PSEL && apb_if.PENABLE);
    endproperty

    apb_enable_after_psel :
    assert property(p_enable_after_psel)
    else
        $error("[APB_ASSERT] PENABLE did not follow PSEL");

    // PENABLE requires PSEL
    property p_enable_requires_psel;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        apb_if.PENABLE |-> apb_if.PSEL;
    endproperty

    apb_enable_requires_psel :
    assert property(p_enable_requires_psel)
    else
        $error("[APB_ASSERT] PENABLE asserted without PSEL");


    //  Address must remain stable during ACCESS phase
    property p_addr_stable;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        (apb_if.PSEL && apb_if.PENABLE)
        |-> $stable(apb_if.PADDR);
    endproperty

    apb_addr_stable :
    assert property(p_addr_stable)
    else
        $error("[APB_ASSERT] PADDR changed during ACCESS phase");

    // PWRITE must remain stable during ACCESS phase
    property p_write_stable;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        (apb_if.PSEL && apb_if.PENABLE)
        |-> $stable(apb_if.PWRITE);
    endproperty

    apb_write_stable :
    assert property(p_write_stable)
    else
        $error("[APB_ASSERT] PWRITE changed during ACCESS phase");

    // PWDATA must remain stable during WRITE ACCESS
 
    property p_wdata_stable;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        (apb_if.PSEL &&
         apb_if.PENABLE &&
         apb_if.PWRITE)
        |-> $stable(apb_if.PWDATA);
    endproperty

    apb_wdata_stable :
    assert property(p_wdata_stable)
    else
        $error("[APB_ASSERT] PWDATA changed during WRITE ACCESS");

    //  PSEL must remain asserted during ACCESS phase
  
    property p_psel_stable;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        (apb_if.PSEL && apb_if.PENABLE)
        |-> apb_if.PSEL;
    endproperty

    apb_psel_stable :
    assert property(p_psel_stable)
    else
        $error("[APB_ASSERT] PSEL deasserted during ACCESS");

    // No unknown address
    property p_addr_not_unknown;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        !$isunknown(apb_if.PADDR);
    endproperty

    apb_addr_not_unknown :
    assert property(p_addr_not_unknown)
    else
        $error("[APB_ASSERT] PADDR contains X/Z");


    //  No unknown write control
    property p_write_not_unknown;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        !$isunknown(apb_if.PWRITE);
    endproperty

    apb_write_not_unknown :
    assert property(p_write_not_unknown)
    else
        $error("[APB_ASSERT] PWRITE contains X/Z");

    // No unknown write data
    
    property p_wdata_not_unknown;
        @(posedge apb_if.PCLK)
        disable iff(!apb_if.PRESETn)

        !$isunknown(apb_if.PWDATA);
    endproperty

    apb_wdata_not_unknown :
    assert property(p_wdata_not_unknown)
    else
        $error("[APB_ASSERT] PWDATA contains X/Z");


    //  Reset check
    
  property p_reset_idle;
    @(posedge apb_if.PCLK)
    !apb_if.PRESETn |-> (
        apb_if.PSEL    == 1'b0 &&
        apb_if.PENABLE == 1'b0
    );
endproperty

    apb_reset_idle :
    assert property(p_reset_idle)
    else
        $error("[APB_ASSERT] APB not idle during reset");

endmodule