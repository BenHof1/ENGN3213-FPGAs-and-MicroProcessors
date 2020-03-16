`timescale 1ns / 1ps

module singleEntryController(
    input wire clk,
    input wire enable,
    input wire [7:0] key,
    output wire [31:0] displayOutput,
    output wire [15:0] ledOutput
    );
    
    // Most recent key pressed
    reg [7:0] keyPressed;
    
    // Assign SSD and LED display data
    assign displayOutput = {24'h0, keyPressed};
    assign ledOutput = {2'd1, 14'h0};
    
    always @(posedge clk) begin
        // If should accept input and a key has been pressed then update
        if(enable && key != 8'h0) begin
            if(isRecognisedChar(key)) keyPressed <= key;
            else keyPressed <= 8'h0;
        end
    end
    
    // Checks whether a scan code is recognised and outputs 1 otherwise 0
    function isRecognisedChar (input [7:0] code);
        begin
            case (code)
            8'h1C : isRecognisedChar = 1'b1; //A
            8'h24 : isRecognisedChar = 1'b1; //E
            8'h43 : isRecognisedChar = 1'b1; //I
            8'h44 : isRecognisedChar = 1'b1; //O
            8'h3C : isRecognisedChar = 1'b1; //U
            8'h32 : isRecognisedChar = 1'b1; //b
            8'h21 : isRecognisedChar = 1'b1; //C
            8'h23 : isRecognisedChar = 1'b1; //d
            8'h2B : isRecognisedChar = 1'b1; //F
            8'h34 : isRecognisedChar = 1'b1; //G
            8'h33 : isRecognisedChar = 1'b1; //H
            8'h4B : isRecognisedChar = 1'b1; //L
            8'h31 : isRecognisedChar = 1'b1; //n
            8'h4D : isRecognisedChar = 1'b1; //p
            8'h2D : isRecognisedChar = 1'b1; //r
            8'h1B : isRecognisedChar = 1'b1; //S
            8'h2C : isRecognisedChar = 1'b1; //t
            default : isRecognisedChar = 1'b0;
        endcase
        end
    endfunction
        
endmodule
