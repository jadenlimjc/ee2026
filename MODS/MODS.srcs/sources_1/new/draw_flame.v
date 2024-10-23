`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 21:53:21
// Design Name: 
// Module Name: draw_flame
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


module draw_flame(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    output reg [15:0] colour

    );
endmodule
