`timescale 1ns / 1ps

module Sentence_ROM(
    input wire [1:0] sentenceAddr,
    output wire [255:0] sentence,
    output wire [23:0] cursorPositions
    );
    
    // Arrays to hold sentences and cursor positions
    wire [255:0] sentences [0:3];
    wire [23:0] cursors [0:3];
    
    // COOL CAtS rULE tHE LOnG rEd rOAd
    assign sentences[2'd0] = 256'h2144444B_211C2C1B_2D3C4B24_2C332400_4B443134_2D242300_2D441C23_00000000;
    // PASS tHE SALt tO tHE IrON CHEF
    assign sentences[2'd1] = 256'h4D1C1B1B_2C332400_1B1C4B2C_2C440000_2C332400_432D4431_2133242B_00000000;
    // tED IS SAd To SEE FrEd In bEd
    assign sentences[2'd2] = 256'h2C242300_431B0000_1B1C2300_2C440000_1B242400_2B2D2423_43310000_32242300;
    // tHIS IS FOr A HUGE nErd
    assign sentences[2'd3] = 256'h2C33431B_431B0000_2B442D00_1C000000_333C3424_31242D23_00000000_00000000;
    
    // Contains cursor positions for when loading into function 3
    assign cursors[2'd0] = 24'b100_100_100_011_100_011_100_000;
    assign cursors[2'd1] = 24'b100_011_100_010_011_100_100_000;
    assign cursors[2'd2] = 24'b011_010_011_010_011_100_010_100;
    assign cursors[2'd3] = 24'b100_010_011_001_100_100_000_000;
    
    assign sentence = sentences[sentenceAddr];
    assign cursorPositions = cursors[sentenceAddr];
    
endmodule
