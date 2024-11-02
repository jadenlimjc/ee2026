`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 01:08:38 PM
// Design Name: 
// Module Name: draw_number
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


module draw_number(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    input wire [1:0] player_no,
    output reg [5:0] colour
    );
    
    //define colours
    parameter ORANGE = 6'b111000;
        
    
    localparam [1:0] ONE = 2'b00,
                     TWO = 2'b01,
                     THREE = 2'b10,
                     FOUR = 2'b11;
        
    
    always @ (posedge clk) begin
         case (player_no)
             ONE: begin
                 if (x == ref_x && (y >= ref_y && y <= ref_y + 9))
                     colour <= ORANGE;
                 else if (x == ref_x - 1 && (y >= ref_y + 1 && y <= ref_y + 9))
                     colour <= ORANGE;
                 else if (x == ref_x - 2 && y == ref_y + 2)
                     colour <= ORANGE;
                 else if (y == ref_y + 10 && (x >= ref_x - 3 && x <= ref_x + 2))
                     colour <= ORANGE;
                 else 
                    colour = 6'b000000;
             end
             
             TWO: begin
                 if ((x >= ref_x && x <= ref_x + 3) && y == ref_y)
                     colour = ORANGE;
                 else if (x == ref_x - 1 && y == ref_y + 1)
                     colour = ORANGE;
                 else if (x == ref_x + 4 && (y >= ref_y + 1 && y <= ref_y + 3))
                     colour = ORANGE;
                 else if (x == ref_x + 3 && (y >= ref_y + 2 && y <= ref_y + 5))
                     colour = ORANGE;
                 else if (x == ref_x + 2 && (y >= ref_y + 4 && y <= ref_y + 7))
                     colour = ORANGE;
                 else if (x == ref_x + 1 && (y >= ref_y + 6 && y <= ref_y + 9))
                     colour = ORANGE;
                 else if (x == ref_x && (y >= ref_y + 8 && y <= ref_y + 9))
                     colour = ORANGE;
                 else if (y == ref_y + 10 && (x >= ref_x - 1 && x <= ref_x + 4))
                     colour = ORANGE;
                 else 
                    colour = 6'b000000;
             end
             
             THREE: begin
                 if ((y == ref_y || y == ref_y + 5 || y == ref_y + 10) && (x >= ref_x && x <= ref_x + 3))
                     colour = ORANGE;
                 else if ((y == ref_y + 1 || y == ref_y + 9) && (x >= ref_x - 1 && x <= ref_x + 4))
                     colour = ORANGE;
                 else if (x == ref_x - 1 && (y == ref_y + 2 || y == ref_y + 8))
                     colour = ORANGE;
                 else if (x == ref_x + 4 && ((y >= ref_y + 2 && y <= ref_y + 4) || (y >= ref_y + 6 && y <= ref_y + 8)))
                     colour = ORANGE;
                 else 
                     colour = 6'b000000;
             end
             
             FOUR: begin
                 if ((x == ref_x || x == ref_x + 1) && (y >= ref_y && y <= ref_y + 6))
                     colour = ORANGE;
                 else if ((x == ref_x + 3 || x == ref_x + 4) && (y >= ref_y && y <= ref_y + 10))
                     colour = ORANGE;
                 else if ((y == ref_y + 5 || y == ref_y + 6) && (x >= ref_x && x <= ref_x + 5))
                     colour = ORANGE;
                  else 
                     colour = 6'b000000;
             end
         endcase
     end
            
endmodule