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
    output reg [5:0] colour
    );
    
    //define colours
    parameter DARK_BLUE = 6'b000110;
    parameter BLUE = 6'b001011;
    parameter LIGHT_BLUE = 6'b101011;
    parameter RED = 16'b110000;
    parameter ORANGE = 16'b111000;
        
    
    localparam [1:0] NONE = 2'b00,
                     FIRE = 2'b01,
                     WATER = 2'b10,
                     FIREWATER = 2'b11;
    
    always @ (posedge clk) begin
        case (power_state)
            FIRE: begin
                if (x == ref_x && (y == ref_y + 4 || y == ref_y + 5))
                    colour = RED;
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 7))
                    colour = RED;
                else if (x == ref_x + 2 && ((y >= ref_y && y <= ref_y + 4) || (y >= ref_y + 8 && y <= ref_y + 9)))
                    colour = RED;
                else if (x == ref_x + 3 && (y == ref_y + 1 || y == ref_y + 2 || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 4 && ((y >= ref_y - 1 && y <= ref_y + 2) || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 5 && (( y >= ref_y - 2 && y <= ref_y + 1) || y == ref_y + 3 || y == ref_y + 4 || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 6 && ((y >= ref_y - 3 && y <= ref_y + 4) || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 7 && ((y >= ref_y + 2 && y <= ref_y + 5) || y == ref_y + 8))
                    colour = RED;
                else if (x == ref_x + 8 && (y >= ref_y + 1 && y <= ref_y + 8))
                    colour = RED;
                else if (x == ref_x + 9 && (y >= ref_y + 3 && y <= ref_y + 5))
                    colour = RED;
                else if (x == ref_x + 2 && (y >= ref_y + 5 && y <= ref_y + 7))
                    colour = ORANGE;
                else if ((x >= ref_x + 3 && x <= ref_x + 4) && (y >= ref_y + 3 && y <= ref_y + 8))
                    colour = ORANGE;
                else if (x == ref_x + 5 && (y == ref_y +2 || (y >= ref_y + 5 && y <= ref_y + 8)))
                    colour = ORANGE;
                else if (x == ref_x + 6 && (y >= ref_y + 5 && y <= ref_y + 8))
                    colour = ORANGE;
                else if (x == ref_x + 7 && (y >= ref_y + 6 && y <= ref_y + 7))
                    colour = ORANGE;
                 else 
                    colour = 6'b000000;
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
                    colour = 6'b000000;
            end
            FIREWATER: begin
                if (x == ref_x && (y == ref_y + 4 || y == ref_y + 5))
                    colour = RED;
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 7))
                    colour = RED;
                else if (x == ref_x + 2 && ((y >= ref_y && y <= ref_y + 4) || (y >= ref_y + 8 && y <= ref_y + 9)))
                    colour = RED;
                else if (x == ref_x + 3 && (y == ref_y + 1 || y == ref_y + 2 || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 4 && ((y >= ref_y - 1 && y <= ref_y + 2) || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 5 && (( y >= ref_y - 2 && y <= ref_y + 1) || y == ref_y + 3 || y == ref_y + 4 || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 6 && ((y >= ref_y - 3 && y <= ref_y + 4) || y == ref_y + 9))
                    colour = RED;
                else if (x == ref_x + 7 && ((y >= ref_y + 2 && y <= ref_y + 5) || y == ref_y + 8))
                    colour = RED;
                else if (x == ref_x + 8 && (y >= ref_y + 1 && y <= ref_y + 8))
                    colour = RED;
                else if (x == ref_x + 9 && (y >= ref_y + 3 && y <= ref_y + 5))
                    colour = RED;
                else if (x == ref_x + 2 && (y >= ref_y + 5 && y <= ref_y + 7))
                    colour = ORANGE;
                else if ((x >= ref_x + 3 && x <= ref_x + 4) && (y >= ref_y + 3 && y <= ref_y + 8))
                    colour = ORANGE;
                else if (x == ref_x + 5 && (y == ref_y +2 || (y >= ref_y + 5 && y <= ref_y + 8)))
                    colour = ORANGE;
                else if (x == ref_x + 6 && (y >= ref_y + 5 && y <= ref_y + 8))
                    colour = ORANGE;
                else if (x == ref_x + 7 && (y >= ref_y + 6 && y <= ref_y + 7))
                    colour = ORANGE;
                //leftmost droplet
                else if (x == ref_x + 9 && (y >= ref_y && y <= ref_y + 5))
                    colour = BLUE; 
                else if (x == ref_x + 10 && (y >= ref_y + 1 && y <= ref_y +4))
                    colour = BLUE;
                else if (x == ref_x + 11 && (y == ref_y + 1 || y == ref_y + 2))
                    colour = BLUE;
                else if (x == ref_x + 11 && (y == ref_y + 3 || y == ref_y + 4))
                    colour = LIGHT_BLUE;
                else if (x == ref_x + 12 && (y == ref_y + 3 || y == ref_y + 4))
                    colour = BLUE;
                //upper droplet
                //top row
                else if (y == ref_y - 2 && (x >= ref_x + 14 && x <= ref_x + 18))
                    colour = DARK_BLUE;
                else if ((y == ref_y - 1 && x == ref_x + 14) || (y == ref_y && x == ref_x + 16) || (y == ref_y + 1 && x == ref_x + 17))
                    colour = DARK_BLUE;
                else if (y == ref_y - 1 && (x >= ref_x + 15 && x <= ref_x + 18))
                    colour = BLUE;
                else if (y == ref_y && (x >= ref_x + 17 && x <= ref_x + 19))
                    colour = BLUE;
                else if (y == ref_y + 1 && (x == ref_x + 18 || x == ref_x + 19))
                    colour = BLUE;
                //bottom droplet
                else if (x == ref_x + 14 && (y >= ref_y + 2 && y <= ref_y + 7))
                    colour = BLUE;
                else if (x == ref_x + 15 && (y >= ref_y + 3 && y <= ref_y + 7))
                    colour = BLUE;
                else if ((x == ref_x + 16 || x == ref_x + 8) && y == ref_y + 4)
                    colour = BLUE;
                else if ((x == ref_x + 16 && (y >= ref_y + 6 && y <= ref_y + 7)) || (x == ref_x + 17 && y == ref_y + 7) || ((x >= ref_x + 18 && x <= ref_x + 19) && y == ref_y + 6) || (x == ref_x + 19 && y == ref_y + 5))
                    colour = BLUE;
                else if ((x >= ref_x + 16 && x <= ref_x + 18) && y == ref_y + 5)
                    colour = LIGHT_BLUE;
                else if (x == ref_x + 17 && y == ref_y + 6)
                    colour = LIGHT_BLUE;
                else if (y == ref_y + 7 && (x == ref_x + 18 || x == ref_x + 19))
                    colour = DARK_BLUE;
                else if (y == ref_y + 8 && (x >= ref_x + 15 && x <= ref_x + 18))
                    colour = DARK_BLUE;
                 else 
                    colour = 6'b000000;
            end
        endcase
    end
    
endmodule