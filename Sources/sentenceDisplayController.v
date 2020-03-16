`timescale 1ns / 1ps

module sentenceDisplayController(
    input wire clk,
    input wire [255:0] sentence,
    input wire nextWord,
    input wire prevWord,
    output wire [31:0] currentWord,
    output wire [2:0] wordIndex
    );
    
    // Index of currently displayed word
    // index 7 indicates first word, index 0 indicates last word
    reg [2:0] currentWordIndex = 3'd7;
    
    // Assigns current word in sentence to output
    assign currentWord = sentence >> (currentWordIndex * 32);
    // Changes indexing so index 0 is first word and index 7 is last word
    assign wordIndex = 3'd7 - currentWordIndex;
    
    always @(posedge clk) begin
        // Scroll through words
        if (nextWord) currentWordIndex <= currentWordIndex - 1;
        if (prevWord) currentWordIndex <= currentWordIndex + 1;
    end
    
endmodule
