`timescale 1ns / 1ps

// This module was provided in ENGN3213 2019 for lab exercises
// It was not written by us
// Used with permission

module edgeDetector(
        input clk,
        input signalIn,
        output risingEdge,
        output fallingEdge,
        output reg signalOut
    );

    always @(posedge clk) begin
        signalOut = signalIn;
    end

    assign risingEdge = signalIn & ~signalOut;
    assign fallingEdge = ~signalIn & signalOut;
    
endmodule
