`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2024 18:03:14
// Design Name: 
// Module Name: gradedlab2_adder
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

module full_adder(
    input A, B, CIN, 
    output S, COUT

    );
    
    assign S = A ^ B ^ CIN;
    assign COUT = (A & B) | ((A ^B) & CIN);
endmodule

module two_bit_adder(
    input [1:0] A, input [1:0] B, input C0,
    output [1:0] S, output C2
    );
    wire C1;
    full_adder fa0 (A[0], B[0], C0, S[0], C1);
    full_adder fa1 (A[1], B[1], C1, S[1], C2);
endmodule

module four_bit_adder( 
    input [3:0] A, input [3:0] B, input C0,
    output [3:0] S, output C4
    );
    wire C2;
    two_bit_adder tba0 (A[1:0], B[1:0], C0, S[1:0], C2);
    two_bit_adder tba1 (A[3:2], B[3:2], C2, S[3:2], C4);
    
endmodule

module six_bit_adder(
    input [5:0] A, input [5:0] B, 
    output [5:0] S
    );

    wire [3:0] LSB_S;
    wire [1:0] MSB_S;
    wire C2;
    wire C4;
    
    
    //4 bit adder for lsb with internal carry
    four_bit_adder lsb_adder (A[3:0], B[3:0], 1'b0, LSB_S, C4);
    two_bit_adder msb_adder (A[5:4], B[5:4], C4, MSB_S, C2);
    
    assign S = {MSB_S, LSB_S};

endmodule



module gradedlab2_adder(
    input [5:0] swA, //0-5 A, 
    input [5:0] swB, //8-13 B
    input btnL, //toggle button
    output [5:0] led, //0-5 output S,
    output [1:0] led_toggle, // 14-15 toggle
    output [3:0] an, // only need left two anodes
    output [6:0] seg // only need 0 and 6
    );
    
    wire [5:0] A, B, S;
    wire [5:0] S_inverted;
    wire [1:0] MSB_S;
    wire [1:0] MSB_S_inverted;
    
    assign A = swA;
    assign B = swB;
    
    //instantiate 7 segment display and LED 14 and 15 
    wire [3:0] an_default = 4'b0011;
    wire [6:0] seg_default = 7'b0111110;
    
    assign an = an_default;
    assign seg = seg_default;
    
    //create six bit adder
    six_bit_adder sba0 (A, B, S);
    
    //invert msb if btnL pressed
    assign MSB_S = S[5:4];
    assign MSB_S_inverted = (btnL) ? ~MSB_S : MSB_S;
    assign S_inverted = {MSB_S_inverted, S[3:0]};
    
    //toggle led based on btnL
    assign led = S_inverted;
    assign led_toggle = (btnL) ? 2'b11 : 2'b00;
    
    
         
endmodule
