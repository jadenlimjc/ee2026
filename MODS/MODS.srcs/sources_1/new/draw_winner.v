`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 18:49:49
// Design Name: 
// Module Name: draw_winner
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


module draw_winner(
    input clk,
    input [1:0] winner,
    input [12:0] pixel_index, 
    output reg [15:0] colour
    );
    
        // Screen dimensions
    parameter SCREEN_WIDTH = 96;
    
    wire [6:0] x; 
    wire [6:0] y;
    assign x = pixel_index % SCREEN_WIDTH;
    assign y = pixel_index / SCREEN_WIDTH;
    wire [6:0] ref_x = 31;
    wire [6:0] ref_y = 34;
    
       
    localparam [1:0] ONE = 2'b00,
                    TWO = 2'b01,
                    THREE = 2'b10,
                    FOUR = 2'b11;
                    
    parameter ORANGE = 6'b111000;
    parameter YELLOW = 6'b111100;
    parameter BLACK = 0;
                    
    //number goes to coords x = 31, y = 34
    
    always @ (*) begin
        case (winner)
            ONE: begin
                if (x == ref_x && (y>= ref_y && y <= ref_y + 20))
                    colour <= ORANGE;
                else if (x == ref_x -1 && (y >= ref_y + 1 && y <= ref_y + 20))
                    colour <= ORANGE;
                else if ((x == ref_x - 2 && y == ref_y + 2) || (x == ref_x +1 && (y >=ref_y -1 && y <= ref_y + 1)) || ((x >= ref_x - 4 && x <= ref_x -2) && y == ref_y + 20))
                    colour <= ORANGE;
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 20))
                    colour <= YELLOW;
                else if ((x == ref_x + 2 || x == ref_x + 3) && y == ref_y + 20)
                    colour <= YELLOW;
                else
                    colour <= BLACK;
            end
            TWO: begin
                if ((y == ref_y || y == ref_y + 15 || y == ref_y + 16) && (x >= ref_x && x <= ref_x + 8))
                    colour <= ORANGE;
                else if (y == ref_y - 1 && (x >= ref_x + 1 && x <= ref_x + 7))
                    colour <= ORANGE;
                else if (y == ref_y + 2 && (x == ref_x || x == ref_x + 7 ))
                    colour <= ORANGE;
                else if (x == ref_x && (y >= ref_y + 11 && y <= ref_y + 13))
                    colour <= ORANGE;
                else if (x == ref_x + 1 && (y >= ref_y + 10 && y <= ref_y + 13))
                    colour <= ORANGE;
                else if (x == ref_x + 8 && ((y >= ref_y + 1 && y <= ref_y + 7) || y == ref_y + 15))
                    colour <= ORANGE;
                else if (x == ref_x + 2 && (y >= ref_y + 10 && y <= ref_y + 12))
                    colour <= YELLOW;
                else if (x == ref_x + 3 && (y >= ref_y + 9 && y <= ref_y + 12))
                    colour <= YELLOW;
                else if (x == ref_x + 4 && (y >= ref_y + 8 && y <= ref_y + 10))
                    colour <= YELLOW;
                else if (x == ref_x + 5 && (y >= ref_y + 7 && y <= ref_y + 9))
                    colour <= YELLOW;
                else if (x == ref_x + 6 && (y >= ref_y + 6 && y <= ref_y + 8))
                    colour <= YELLOW;
                else if (x == ref_x + 7 && (y >= ref_y + 2 && y <= ref_y + 7))
                    colour <= YELLOW;
                else if ((y == ref_y + 13 || y == ref_y + 14) && (x >= ref_x + 2 && x <= ref_x + 7))
                    colour <= YELLOW;
                else
                    colour <= BLACK;
                
            end
            THREE: begin
                if ((y == ref_y || y == ref_y + 1 || y == ref_y + 13 || y == ref_y + 14) && (x >= ref_x && x <= ref_x + 6))
                    colour <= ORANGE;
                if ((x == ref_x + 5 || x == ref_x + 6) && (y >= ref_y && y <= ref_y + 15))
                    colour <=  ORANGE;
                if (x == ref_x && (y == ref_y + 2 || y == ref_y + 13))
                    colour <= ORANGE;
                if (y == ref_y + 8 && (x >= ref_x + 1 && x <= ref_x + 4))
                    colour <= ORANGE;
                if ((y == ref_y -1 || y == ref_y + 16) && (x >= ref_x +1 && x <= ref_x + 6))
                    colour <= YELLOW;
                if (x == ref_x + 7 && ((y >= ref_y && y <= ref_y + 7) || (y >= ref_y +9 && y <= ref_y + 15)))
                    colour <= YELLOW;
                else
                    colour <= BLACK;
            end
            FOUR: begin
                if ((x == ref_x || x == ref_x + 1) && (y >= ref_y && y <= ref_y + 12))
                    colour <= ORANGE;
                else if ((x == ref_x + 7 || x == ref_x + 8) && (y >= ref_y  && y <= ref_y + 19))
                    colour <= ORANGE;
                else if ((y == ref_y + 11 || y == ref_y + 12) && (x >= ref_x && x <= ref_x + 10))
                    colour <= ORANGE;
                else if ((x == ref_x + 2 || x == ref_x + 9) && (y >= ref_y && y <= ref_y + 10))
                    colour <= YELLOW;
                else if ((y == ref_y + 10) && ((x >= ref_x + 2 && x <= ref_x + 6) || x == ref_x + 9 || x == ref_x + 10))
                    colour <= YELLOW;
                else if (x == ref_x + 9 && (y >= ref_y + 12 && y <= ref_y + 19))
                    colour <= YELLOW;
                else
                    colour <= BLACK;
                
            end
        endcase
    end
endmodule
