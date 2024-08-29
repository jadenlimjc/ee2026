`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2024 03:33:45 PM
// Design Name: 
// Module Name: gradedlab1_boolean
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gradedlab1_boolean(
    input[9:0]sw,
    output [3:0]an,
    output [7:0]seg,
    output [15:0]led
    
    );
    //initialisation: turn on 7 segment display

    assign an[3:0] = 4'b1001;
    assign seg[7:0] = 8'b10100101;

    
    // subtask A: switch on leds corresponding to switch
    assign led[9:0] = sw[9:0];
    assign led[14:10] = 0;
    
    // subtask B: assign led[15] to passcode
    assign led[15] = (sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
    
    // subtask C: create A when passcode is on
    
    //assign an2 and an0 to off, an1 and an3 to on
//    assign an[2] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign an[0] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign an[1] = (sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign an[3] = (sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
    
//    //assign segment3 to off, others all on
//    assign seg[0] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[1] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[2] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[3] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[4] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[5] = ~(sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[6] = (sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);
//    assign seg[7] = (sw[1] & sw[2] & sw[3] & sw[8] & ~sw[0] & ~sw[4] & ~sw[5] & ~sw[6] & ~sw[7] & ~sw[9]);

    
    
    
    
endmodule
