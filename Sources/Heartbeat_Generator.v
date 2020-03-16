`timescale 1ns / 1ps

// Based heavily on code provided in ENGN3213 2019 for lab exercies

module Heartbeat_Generator # (
    parameter integer COUNTS = 50_000_000
    )(
    input clk,
    input enable,
    input reset,
    output beat
    );
    
    reg [$clog2(COUNTS)-1:0] counter;
    
    assign beat = (counter == COUNTS - 1);
    
    always @(posedge clk) begin
        if (reset || counter == COUNTS - 1) counter <= 0;
        if (enable) counter <= counter + 1;
    end
    
endmodule
