`timescale 1ns / 1ps

module Predefined_Controller(
    input wire clk,
    input wire enable,
    
    input wire [7:0] keyboard,
    
    input wire nextSentence,
    input wire prevSentence,
    input wire nextWord,
    input wire prevWord,
    
    input wire autoScroll,
    
    input wire [255:0] sentence,
    
    output wire [31:0] displayOutput,
    output reg [1:0] currentSentence,
    output wire [15:0] ledOutput
    );
    
    // pulse to indicate should auto scroll
    wire autoScrollPulse;
    // Index of currently displayed word
    wire [2:0] wordIndex;
    
    // Set LED output 
    // [15:14] - Indicate mode, [13] - Blank, [12:9] - Indicate current sentence, [8] - Blank, [7:0] - Indicate selected word
    assign ledOutput = {2'd2, 1'b0, 4'b1000 >> currentSentence, 1'b0, 8'b10000000 >> wordIndex};
    
    // Controller for displaying a single sentence.
    sentenceDisplayController displayController (
        .clk(clk),
        .sentence(sentence),
        .nextWord((nextWord || keyboard == 8'h74 || autoScrollPulse) && enable),
        .prevWord((prevWord || keyboard == 8'h6B) && enable),
        .currentWord(displayOutput),
        .wordIndex(wordIndex)
    );
    
    // Pulse every ~1s to auto scroll
    Heartbeat_Generator #(.COUNTS(100_000_000)) autoScrollBeat (.clk(clk), .enable(autoScroll), .reset(~autoScroll), .beat(autoScrollPulse));
    
    always @(posedge clk) begin
        // If should accept input, respond to button press or keyboard arrows to select sentence
        if(enable) begin
            if (nextSentence || keyboard == 8'h75) currentSentence <= currentSentence + 1;
            if (prevSentence || keyboard == 8'h72) currentSentence <= currentSentence - 1;
        end
    end
    
endmodule
