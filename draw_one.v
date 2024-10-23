`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 12:45:57 PM
// Design Name: 
// Module Name: draw_one
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


module draw_one(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    output reg [15:0] colour

    );
    
    //define colours
    parameter ORANGE = 16'b1111110100000000;
    parameter BLACK = 16'b0000000000000000;
    
    always @ (posedge clk) begin
        if (x == ref_x && (y >= ref_y && y <= ref_y + 10))
            colour = ORANGE;
        if (x == ref_x - 1 && ( y >= ref_y + 1 && y <= ref_y + 10))
            colour = ORANGE;
        if (x == ref_x - 2 && y == ref_y + 2)
            colour = ORANGE;
        if (y == ref_y + 10 && (x >= ref_x - 3 && x <= ref_x + 2))
            colour = ORANGE;
        else
            colour = BLACK;
    end
        
endmodule
