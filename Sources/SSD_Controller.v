`timescale 1ns / 1ps

module SSD_Controller(
    input wire clk,
    input wire enable,
    input wire [31:0] word,
    output wire [6:0] segments,
    output reg [3:0] anodes
    );
    
    reg [1:0] activeSegment;
    reg [7:0] activeChar;
    wire onekHzBeat;
    
    // Decoder to get which segments should be active for a specific character.
    Seven_Segment_Decoder decoder (
        .charCode(activeChar),
        .segments(segments)
    );
    
    // Generates pulse to interate through SSDs
    Heartbeat_Generator #(.COUNTS(100_000)) onekHzBeatGen (
        .clk(clk),
        .enable(1'b1),
        .reset(1'b0),
        .beat(onekHzBeat)
    );
    
    // Sets the anode and cathode values
    always @(*) begin
        if(enable) begin
            case(activeSegment)
                2'd0 : 
                    begin
                        anodes = 4'b0111;
                        activeChar = word[31:24];
                    end
                2'd1 : 
                    begin
                        anodes = 4'b1011;
                        activeChar = word[23:16];
                    end
                2'd2 : 
                    begin
                        anodes = 4'b1101;
                        activeChar = word[15:8];
                    end
                2'd3 : 
                    begin
                        anodes = 4'b1110;
                        activeChar = word[7:0];
                    end
                default : 
                    begin
                        anodes = 4'd0;
                        activeChar = 8'd0;
                    end
            endcase
        end else begin
            // Don't display anything if disabled
            anodes = 4'b1111;
            activeChar = 8'h0;
        end
    end
    
    always @(posedge clk) begin
        // Update active segment to iterate through SSDs
        if (onekHzBeat) activeSegment <= activeSegment + 1;
    end
    
endmodule
