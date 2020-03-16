`timescale 1ns / 1ps

// This module was provided in ENGN3213 2019 for lab exercises
// It was not written by us
// Used with permission

module debouncer #(
    parameter integer THRESHOLD = 50
)(
    input clk,
    input buttonIn,
    output buttonOut
);
    wire dividedClk, dividedClk_risingEdge;
    reg [7:0] shiftReg;
    
    clockDivider #(
        .THRESHOLD(THRESHOLD)
    ) DEBOUNCE_CLOCK (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(dividedClk)
    );
    
    edgeDetector DEBOUNCE_CLOCK_EDGE (
        .clk(clk),
        .signalIn(dividedClk),
        .risingEdge(dividedClk_risingEdge),
        .fallingEdge(),
        .signalOut()
    );
    
    always @(posedge clk) begin
        shiftReg[0] <= buttonIn;

        if (dividedClk_risingEdge) begin
            shiftReg[7:1] <= shiftReg[6:0];
        end
    end
    
    assign buttonOut = &shiftReg[7:1];

endmodule
