`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2024 03:01:45 PM
// Design Name: 
// Module Name: my_control_module
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


module my_control_module(
    input A,
    input B,
    input C,
    output LED1,
    output LED2,
    output LED3
    
    );
    
    assign LED1 = (((A & ~B) | (A & B)) & C);
    assign LED2 = (((~A & B) | (A & B)) & C);
    assign LED3 = ((A & B) & C);
    
endmodule
