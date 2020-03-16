`timescale 1ns / 1ps

module keyDriver(
    input wire clk,
    input wire PS2Clk,
    input wire PS2Data,
    output reg [7:0] key,
    output reg keyChange
);

    // Most recent scan code recieved
    reg [7:0] data_curr = 8'hF0;
    // 2nd most recent scan code recieve
    reg [7:0] data_pre = 8'hF0;
    // Counter for bit number within packet
    reg [3:0] b = 4'h1;
    // Flag for notifying when packet is finished
    reg flag = 1'b0;
    // Rising edge of flag
    wire flagEdge;

    // Edge detector for flag
    edgeDetector flagEdgeDetector(.clk(clk), .signalIn(flag), .risingEdge(flagEdge), .fallingEdge(), .signalOut());

    // Clock is active only when data is being sent
    // At clock falling edge, move bit into register
    // Pulse flag when finished
    always @(negedge PS2Clk) begin
    
        case(b)
            1:; //first bit
            2:data_curr[0]<=PS2Data;
            3:data_curr[1]<=PS2Data;
            4:data_curr[2]<=PS2Data;
            5:data_curr[3]<=PS2Data;
            6:data_curr[4]<=PS2Data;
            7:data_curr[5]<=PS2Data;
            8:data_curr[6]<=PS2Data;
            9:data_curr[7]<=PS2Data;
            10:flag<=1'b1; //Parity bit
            11:flag<=1'b0; //Ending bit
        endcase
    
        if(b<=10)b<=b+1;
        else if(b==11) b<=1;
    
    end
    
    always @(posedge clk) begin
        // If data is finished being recieved
        if(flagEdge) begin
            data_pre <= data_curr;
        end
        // If previous scan code is 0xF0 then key has been released
        // Notify event has happend
        if(flagEdge && data_pre == 8'hF0) begin
            keyChange <= 1;
            key <= data_curr;
        end
        else keyChange <= 0;
    end 

endmodule