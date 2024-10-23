`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 18:06:18
// Design Name: 
// Module Name: draw_P
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


module draw_P(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    output reg [15:0] colour

    );
    
    //define colours
    parameter ORANGE = 16'b1111110100000000;
    parameter YELLOW = 16'b1111111111100000;
    parameter BLACK = 16'b0000000000000000;
    
    always @ (posedge clk) begin
        // two orange columns on left
        if ((x >= ref_x && x <= ref_x + 1) && (y >= ref_y && y <= ref_y + 11))
            colour <= ORANGE;
        //2nd row on top
        else if ((x >= ref_x + 2 && x <= ref_x + 6) && (y == ref_y - 1))
            colour <= ORANGE;
        //topmost row
        else if ((x >= ref_x + 3 && x <= ref_x + 4) && (y == ref_y -2))
            colour <= ORANGE;
        //third row minus one yellow
        else if (((x >= ref_x + 2 && x <= ref_x + 4) || (x >= ref_x + 6 && x <= ref_x + 7)) && (y == ref_y))
            colour <= ORANGE;
        //one yellow
        else if (x == ref_x + 5 && y == ref_y)
            colour <= YELLOW;
        //topmost yellow row
        else if ((x >= ref_x + 2 && x <= ref_x + 7) && y == ref_y + 1)
            colour <= YELLOW;
        //two yellow columns down
        else if ((x >= ref_x + 2 && x <= ref_x + 3) && (y >= ref_y + 2 && y <= ref_y + 11))
            colour <= YELLOW;
        //two short rows below
        else if (x == ref_x + 5 && (y >= ref_y + 4 && y <= ref_y +6))
            colour <= YELLOW;
        else if (x == ref_x + 6 && (y >= ref_y + 4 && y <= ref_y + 5))
            colour <= YELLOW;
        //two rightside yellow columns
        else if ((x == ref_x + 6 || x == ref_x + 7) && (y >= ref_y + 2 && y <= ref_y +4))
            colour <= YELLOW;
        //orange block in the middle
        else if ((x >= ref_x + 2 && x <= ref_x + 4) && (y >= ref_y + 4 && y <= ref_y + 5))
            colour <= ORANGE;
        else
            colour <= BLACK;
    end 
endmodule
