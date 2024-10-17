`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 21:51:40
// Design Name: 
// Module Name: draw_water
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


module draw_power(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    input wire [1:0] power_state,
    output reg [15:0] colour
    );
    
    //define colours
    parameter DARK_BLUE = 16'b000001000111010;
    parameter BLUE = 16'b0100111010111111;
    parameter LIGHT_BLUE = 16'b1011011101111111;
    parameter BLACK = 16'b0000000000000000;
    
    localparam [1:0] NONE = 2'b00,
                     FIRE = 2'b01,
                     WATER = 2'b10,
                     FIREWATER = 2'b11;
    
    always @ (posedge clk) begin
        case (power_state)
            NONE: begin
                colour = BLACK;
            end
            FIRE: begin
            end
            WATER: begin
                //leftmost droplet
                if (x == ref_x && (y >= ref_y && y <= ref_y + 5))
                    colour = BLUE; 
                else if (x == ref_x + 1 && (y >= ref_y + 1 && y <= ref_y +4))
                    colour = BLUE;
                else if (x == ref_x + 2 && (y == ref_y + 1 || y == ref_y + 2))
                    colour = BLUE;
                else if (x == ref_x + 2 && (y == ref_y + 3 || y == ref_y + 4))
                    colour = LIGHT_BLUE;
                else if (x == ref_x + 3 && (y == ref_y + 3 || y == ref_y + 4))
                    colour = BLUE;
                //upper droplet
                //top row
                else if (y == ref_y - 2 && (x >= ref_x + 5 && x <= ref_x + 9))
                    colour = DARK_BLUE;
                else if ((y == ref_y - 1 && x == ref_x + 5) || (y == ref_y && x == ref_x + 7) || (y == ref_y + 1 && x == ref_x + 8))
                    colour = DARK_BLUE;
                else if (y == ref_y - 1 && (x >= ref_x + 6 && x <= ref_x + 9))
                    colour = BLUE;
                else if (y == ref_y && (x >= ref_x + 8 && x <= ref_x + 10))
                    colour = BLUE;
                else if (y == ref_y + 1 && (x == ref_x + 9 || x == ref_x + 10))
                    colour = BLUE;
                //bottom droplet
                else if (x == ref_x + 5 && (y >= ref_y + 2 && y <= ref_y + 7))
                    colour = BLUE;
                else if (x == ref_x + 6 && (y >= ref_y + 3 && y <= ref_y + 7))
                    colour = BLUE;
                else if ((x == ref_x + 7 || x == ref_x + 8) && y == ref_y + 4)
                    colour = BLUE;
                else if ((x == ref_x + 7 && (y >= ref_y + 6 && y <= ref_y + 7)) || (x == ref_x + 8 && y == ref_y + 7) || ((x >= ref_x + 9 && x <= ref_x + 10) && y == ref_y + 6) || (x == ref_x + 10 && y == ref_y + 5))
                    colour = BLUE;
                else if ((x >= ref_x + 7 && x <= ref_x + 9) && y == ref_y + 5)
                    colour = LIGHT_BLUE;
                else if (x == ref_x + 8 && y == ref_y + 6)
                    colour = LIGHT_BLUE;
                else if (y == ref_y + 7 && (x == ref_x + 9 || x == ref_x + 10))
                    colour = DARK_BLUE;
                else if (y == ref_y + 8 && (x >= ref_x + 6 && x <= ref_x + 9))
                    colour = DARK_BLUE;
                else
                    colour = BLACK;
            end
        endcase
    end
    
endmodule
