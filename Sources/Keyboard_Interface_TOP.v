`timescale 1ns / 1ps

module Keyboard_Interface_TOP(
    input wire clk,
        
    input wire PS2Data,
    input wire PS2Clk,
    
    input wire enableSSDSwitch,
    input wire autoScrollSwitch,
    
    input wire btnC,
    input wire btnU,
    input wire btnL,
    input wire btnR,
    input wire btnD,
    
    output wire [6:0] ssdSegments,
    output wire ssdDP,
    output wire [3:0] ssdAnodes,
    
    output wire [15:0] led
    );
    
    // Buses for the outputs for each function and the input for the SSD.
    wire [31:0] wordBus;
    wire [31:0] functionDisplays[0:2];
    wire [15:0] functionLEDs[0:2];
    
    // Debounced buttons and button edges
    wire btnCDeb, btnUDeb, btnLDeb, btnRDeb, btnDDeb;
    wire cEdge, uEdge, lEdge, rEdge, dEdge;
    
    // Buses between sentence ROM and relevant functiosn
    wire [1:0] selectedSentence;
    wire [255:0] sentence;
    wire [23:0] cursors;
    
    // Buses for keyboard input
    wire [7:0] key;
    wire [7:0] keyPulse;
    wire keyChange;
    
    // Selected function
    reg [1:0] mode;
    
    assign ssdDP = 1'b1;
    assign wordBus = functionDisplays[mode];
    assign led = functionLEDs[mode];
    
    // Sets keyPulse to the key pressed for one clock cycle
    assign keyPulse = key & {keyChange, keyChange, keyChange, keyChange, keyChange, keyChange, keyChange, keyChange};
    
    // Keyboard driver module
    keyDriver driver (
        .clk(clk),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data),
        .key(key),
        .keyChange(keyChange)
    );
    
    // Function 1 Controller
    singleEntryController function1Controller (
        .clk(clk),
        .enable((mode == 2'd0 && autoScrollSwitch) ? 1'b1 : 1'b0),
        .key(keyPulse),
        .displayOutput(functionDisplays[0]),
        .ledOutput(functionLEDs[0])
    );
    
    // Function 2 Controller
    Predefined_Controller function2Controller (
        .clk(clk),
        .enable((mode == 2'd1) ? 1'b1 : 1'b0),
        .keyboard(keyPulse),
        .nextSentence(uEdge),
        .prevSentence(dEdge),
        .nextWord(rEdge),
        .prevWord(lEdge),
        .autoScroll(autoScrollSwitch),
        .sentence(sentence),
        .displayOutput(functionDisplays[1]),
        .currentSentence(selectedSentence),
        .ledOutput(functionLEDs[1])
    );
    
    // Function 3 Controller
    sentenceEditorController function3Controller (
        .clk(clk),
        .enable((mode == 2'd2) ? 1'b1 : 1'b0),
        .keyboard(keyPulse),
        .prevWord(lEdge),
        .nextWord(rEdge),
        .save(uEdge),
        .load(dEdge),
        .presetSentence(sentence),
        .presetCursors(cursors),
        .displayOutput(functionDisplays[2]),
        .ledOutput(functionLEDs[2])
    );
    
    // SSD Controller
    SSD_Controller ssdController (
        .clk(clk),
        .enable(enableSSDSwitch),
        .word(wordBus),
        .segments(ssdSegments),
        .anodes(ssdAnodes)
    );   
    
    // Sentence ROM for functions 2 and 3
    Sentence_ROM sentences (.sentenceAddr(selectedSentence), .sentence(sentence), .cursorPositions(cursors));
    
    // Button debouncers and edge detectors
    debouncer center (.clk(clk), .buttonIn(btnC), .buttonOut(btnCDeb));
    debouncer up (.clk(clk), .buttonIn(btnU), .buttonOut(btnUDeb));
    debouncer left (.clk(clk), .buttonIn(btnL), .buttonOut(btnLDeb));
    debouncer right (.clk(clk), .buttonIn(btnR), .buttonOut(btnRDeb));
    debouncer down (.clk(clk), .buttonIn(btnD), .buttonOut(btnDDeb));
    
    edgeDetector centerEdge(.clk(clk), .signalIn(btnCDeb), .risingEdge(cEdge), .fallingEdge(), .signalOut());
    edgeDetector upEdge(.clk(clk), .signalIn(btnUDeb), .risingEdge(uEdge), .fallingEdge(), .signalOut());
    edgeDetector leftEdge(.clk(clk), .signalIn(btnLDeb), .risingEdge(lEdge), .fallingEdge(), .signalOut());
    edgeDetector rightEdge(.clk(clk), .signalIn(btnRDeb), .risingEdge(rEdge), .fallingEdge(), .signalOut());
    edgeDetector downEdge(.clk(clk), .signalIn(btnDDeb), .risingEdge(dEdge), .fallingEdge(), .signalOut());
    
    always @(posedge clk) begin
        // On rising edge of center button, update function state machine
        // Transition to next function.
        if(cEdge) begin 
            if(mode == 2'd2) mode <= 2'd0;
            else mode <= mode + 1;
        end
    end
    
endmodule
