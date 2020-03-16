`timescale 1ns / 1ps

module Seven_Segment_Decoder(
    input wire [7:0] charCode,
    output reg [6:0] segments
    );
    
    // Combinational module to convert from char code to SSD active segments.
    always @(*) begin
        case (charCode)
            8'h1C : segments = ~7'b1110111; //A
            8'h24 : segments = ~7'b1001111; //E
            8'h43 : segments = ~7'b0110000; //I
            8'h44 : segments = ~7'b1111110; //O
            8'h3C : segments = ~7'b0111110; //U
            8'h32 : segments = ~7'b0011111; //b
            8'h21 : segments = ~7'b1001110; //C
            8'h23 : segments = ~7'b0111101; //d
            8'h2B : segments = ~7'b1000111; //F
            8'h34 : segments = ~7'b1011111; //G
            8'h33 : segments = ~7'b0110111; //H
            8'h4B : segments = ~7'b0001110; //L
            8'h31 : segments = ~7'b0010101; //n
            8'h4D : segments = ~7'b1100111; //p
            8'h2D : segments = ~7'b0000101; //r
            8'h1B : segments = ~7'b1011011; //S
            8'h2C : segments = ~7'b0001111; //t
            8'h5D : segments = ~7'b0000110; //| to display cursor position
            default : segments = ~7'b0000000;
        endcase
    end
    
endmodule
