`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 16:18:34
// Design Name: 
// Module Name: draw_tank
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


module draw_tank(
    input wire clk,
    input wire [7:0] x,
    input wire [7:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    input wire [1:0] player_no,
    input wire [1:0] tank_direction,
    output reg [5:0] colour

    );
    
    //define colours
    parameter GREEN = 6'b001100;
    parameter RED = 6'b110000;
    parameter GRAY = 6'b000101;
    parameter YELLOW = 6'b111100;
    parameter BLUE = 6'b000111;
    parameter BLACK  = 0;
    parameter BEIGE = 6'b111110;
    
    localparam [1:0] ONE = 2'b00,
                 TWO = 2'b01,
                 THREE = 2'b10,
                 FOUR = 2'b11;
    
    localparam [1:0] UP = 2'b00,
                     LEFT = 2'b01,
                     RIGHT = 2'b10,
                     DOWN = 2'b11;
    
     
    reg [5:0] tank_colour;
    always @ (posedge clk) begin
        case (player_no)
            ONE: begin
                tank_colour <= GREEN;
            end
            TWO: begin
                tank_colour <= RED;
            end
            THREE: begin
                tank_colour <= YELLOW;
            end
            FOUR: begin
            tank_colour <= BLUE;
            end
        endcase
        case (tank_direction)
            UP: begin
                if ((x >= ref_x + 2 && x <= ref_x +6) && y == ref_y)
                    colour <= tank_colour;
                else if ((x >=ref_x + 3 && x <= ref_x + 5) && (y >= ref_y + 1 && y <= ref_y + 8))
                    colour <= tank_colour;
                else if ((x == ref_x + 2 || x == ref_x + 6) && (y >= ref_y + 3 && y <= ref_y +8))
                    colour <= tank_colour;
                else if ((x == ref_x || x == ref_x + 1 || x == ref_x + 7 || x == ref_x + 8) && (y == ref_y + 2 || y == ref_y + 4 || y == ref_y + 6 || y == ref_y +8))
                    colour <= GRAY;
                else if ((x == ref_x || x == ref_x + 1 || x == ref_x + 7 || x == ref_x + 8) && (y == ref_y + 3 || y == ref_y + 5 || y == ref_y + 7))
                    colour <= BLACK;
            end
            LEFT: begin
                if (x == ref_x && ( y >= ref_y + 2 && y <=ref_y + 6))
                    colour <= tank_colour;
                else if ((y >= ref_y + 3 && y <= ref_y + 5) && (x >= ref_x + 1 && x <= ref_x + 8))
                    colour <= tank_colour;
                else if ((y == ref_y + 2 || y == ref_y + 6) && (x >= ref_x + 3 && x <= ref_x + 8))
                    colour <= tank_colour;
                else if ((y == ref_y || y == ref_y + 1 || y == ref_y + 7 || y == ref_y + 8) && (x == ref_x + 2 || x == ref_x + 4 || x == ref_x + 6 || x == ref_x + 8))
                    colour <= GRAY;
                else if ((y == ref_y || y == ref_y + 1 || y == ref_y + 7 || y == ref_y + 8) && (x == ref_x + 3 || x == ref_x + 5 || x == ref_x + 7))
                    colour <= BLACK;
            end
            RIGHT: begin
            if (x == ref_x + 8 && ( y >= ref_y + 2 && y <=ref_y + 6))
                colour <= tank_colour;
            else if ((y >= ref_y + 3 && y <= ref_y + 5) && (x >= ref_x && x <= ref_x + 7))
                colour <= tank_colour;
            else if ((y == ref_y + 2 || y == ref_y + 6) && (x >= ref_x && x <= ref_x + 5))
                colour <= tank_colour;
            else if ((y == ref_y || y == ref_y + 1 || y == ref_y + 7 || y == ref_y + 8) && (x == ref_x + 1 || x == ref_x + 3 || x == ref_x + 5 || x == ref_x + 7))
                colour <= GRAY;
            else if ((y == ref_y || y == ref_y + 1 || y == ref_y + 7 || y == ref_y + 8) && (x == ref_x + 1 || x == ref_x + 3 || x == ref_x + 5))
                colour <= BLACK;
               
            end
            DOWN: begin
            if ((x >= ref_x + 2 && x <= ref_x +6) && y == ref_y + 8)
                colour <= tank_colour;
            else if ((x >= ref_x + 3 && x <= ref_x + 5) && (y >= ref_y && y <= ref_y + 7))
                colour <= tank_colour;
            else if ((x == ref_x + 2 || x == ref_x + 6) && (y >= ref_y && y <= ref_y + 5))
                colour <= tank_colour;
            else if ((x == ref_x || x == ref_x + 1 || x == ref_x + 7 || x == ref_x + 8) && (y == ref_y || y == ref_y + 2 || y == ref_y + 4 || y == ref_y + 6))
                colour <= GRAY;
            else if ((x == ref_x || x == ref_x + 1 || x == ref_x + 7 || x == ref_x + 8) && (y == ref_y + 1 || y == ref_y + 3 || y == ref_y + 5))
                colour <= BLACK;
            end
        endcase
    end
endmodule
