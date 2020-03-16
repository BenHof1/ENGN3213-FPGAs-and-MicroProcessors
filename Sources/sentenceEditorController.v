`timescale 1ns / 1ps

module sentenceEditorController(
    input wire clk,
    input wire enable,
    input wire [7:0] keyboard,
    input wire prevWord,
    input wire nextWord,
    input wire save,
    input wire load,
    input wire [255:0] presetSentence,
    input wire [23:0] presetCursors,
    output wire [31:0] displayOutput,
    output wire [15:0] ledOutput
    );
    
    // Array of words and cursor positions    
    reg [31:0] sentence[0:7];
    reg [2:0] cursorPositions[0:7];
    // The current word and cursor position
    reg [31:0] word;
    reg [2:0] currentCursor;
    // Index of current word
    reg [2:0] wordIndex;
    // Whether to display cursor and whether to toggle (to create blinking effect)
    reg displayCursor;
    wire displayCursorToggle;

    // Set LED output
    // [15:14] - Indicate mode, [13:8] - Blank, [7:0] - Indicate selected word    
    assign ledOutput = {2'b11, 6'h0, 8'b10000000 >> wordIndex};
    // Set display output, adds cursor code at cursor position
    assign displayOutput = (displayCursor) ? word | (32'h5D000000) >> currentCursor * 8 : word;
    
    // Pulse to blink cursor
    Heartbeat_Generator #(.COUNTS(40_000_000)) (.clk(clk), .enable(1'b1), .reset(1'b0), .beat(displayCursorToggle));
    
    integer i;
    
    always @(posedge clk) begin
        if(enable) begin
            
            if(load || keyboard == 8'h72) begin
                // Loads preset sentence and cursor positions
                for(i = 0; i < 8; i=i+1) begin
                    sentence[i] <= presetSentence >> (7 - i) * 32;
                    cursorPositions[i] <= presetCursors >> (7 - i) * 3;
                end
                
                // Sets word to start
                word <= presetSentence >> 7 * 32;
                currentCursor <= presetCursors >> 7 * 3;
                wordIndex <= 3'd0;
            end
            // Move to next word
            if(nextWord || keyboard == 8'h74) begin
                word <= sentence[wordIndex + 3'd1];
                wordIndex <= wordIndex + 3'd1;
                currentCursor <= cursorPositions[wordIndex + 3'd1];
            end
            // Move to previous word
            if(prevWord || keyboard == 8'h6B) begin
                word <= sentence[wordIndex - 3'd1];
                wordIndex <= wordIndex - 3'd1;
                currentCursor <= cursorPositions[wordIndex - 3'd1];
            end
            // Save changes
            if(save || keyboard == 8'h75) begin
                sentence[wordIndex] <= word;
                cursorPositions[wordIndex] <= currentCursor;
            end
            
            // Handles letter keyboard input
            // For adding letters
            if(isRecognisedChar(keyboard) && currentCursor < 3'd4) begin
                currentCursor <= currentCursor + 3'd1;
                word <= setCharacter(word, currentCursor, keyboard);
            end
            // For backspace
            if(keyboard == 8'h66 && currentCursor > 3'd0) begin
                currentCursor <= currentCursor - 3'd1;
                word <= setCharacter(word, currentCursor - 3'd1, 8'h0);
            end
        end
        // Toggle cursor display to create blink effect
        if(displayCursorToggle) displayCursor <= ~displayCursor;
    end
    
    // Sets a specific character in a word
    function [31:0] setCharacter (input [31:0] currWord, input [2:0] charIndex, input [7:0] char);
        begin
            case(charIndex)
                2'd0 : setCharacter = {char, currWord[23:0]};
                2'd1 : setCharacter = {currWord[31:24], char, currWord[15:0]};
                2'd2 : setCharacter = {currWord[31:16], char, currWord[7:0]};
                2'd3 : setCharacter = {currWord[31:8], char};
                default : setCharacter = currWord;
            endcase
        end
    endfunction
    
    // Check if character is recognised
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
