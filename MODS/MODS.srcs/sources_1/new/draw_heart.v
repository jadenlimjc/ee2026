`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 21:19:38
// Design Name: 
// Module Name: draw_heart
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


module draw_heart(
    input wire clk,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] ref_x,
    input wire [6:0] ref_y,
    input wire [1:0] no_of_lives,
    output reg [5:0] colour
    );
    
    //define colours
    parameter RED = 6'b110000;
    parameter WHITE = 6'b111111;
        
    
    localparam [1:0] ZERO = 2'b00,
                     ONE = 2'b01,
                     TWO = 2'b10,
                     THREE = 2'b11;
    
    parameter HEART_SPACING = 4;
    
    
    
    always @ (posedge clk) begin
        case (no_of_lives) 
            ONE: begin           
                //left and right column
                if ((x == ref_x || x == ref_x +6) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 1 || x == ref_x + 2) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 1 && y == ref_y) || (x == ref_x + 1 && y == ref_y + 1) || (x == ref_x + 2 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 2 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 3 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 4 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 5 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                else 
                    colour <= 6'b000000;
            end
            
            TWO: begin
                //left and right column
                if ((x == ref_x || x == ref_x + 6) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 1 || x == ref_x + 2) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 1 && y == ref_y) || (x == ref_x + 1 && y == ref_y + 1) || (x == ref_x + 2 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 2 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 3 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 4 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 5 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                // 2nd heart top row
                else if ((x == ref_x + 8 || x == ref_x + 14) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 9 || x == ref_x + 10) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 9 && y == ref_y) || (x == ref_x + 9 && y == ref_y + 1) || (x == ref_x + 10 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 9 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 10 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 11 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 12 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 13 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                else 
                    colour <= 6'b000000;
            end
            
            THREE: begin
                //left and right column
                if ((x == ref_x || x == ref_x +6) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 1 || x == ref_x + 2) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 1 && y == ref_y) || (x == ref_x + 1 && y == ref_y + 1) || (x == ref_x + 2 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 1 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 2 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 3 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 4 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 5 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                // 2nd heart top row
                else if ((x == ref_x + 8 || x == ref_x + 14) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 9 || x == ref_x + 10) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 9 && y == ref_y) || (x == ref_x + 9 && y == ref_y + 1) || (x == ref_x + 10 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 9 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 10 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 11 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 12 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 13 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                    
                //3rd heart
                else if ((x == ref_x + 16 || x == ref_x + 22) && (y >= ref_y && y <= ref_y + 2)) 
                    colour <= RED;
                //top row
                else if ((x == ref_x + 17 || x == ref_x + 18) && y == ref_y - 1)
                    colour <= RED;
                // white
                else if ((x == ref_x + 17 && y == ref_y) || (x == ref_x + 17 && y == ref_y + 1) || (x == ref_x + 18 && y == ref_y))
                    colour <= WHITE;
                //area below white
                else if (x == ref_x + 17 && (y >= ref_y + 2 && y <= ref_y + 3))
                    colour <= RED;
                else if (x == ref_x + 18 && (y >= ref_y + 1 && y <= ref_y + 4))
                    colour <= RED;
                //middle row
                else if (x == ref_x + 19 && (y >= ref_y && y <= ref_y +6))
                    colour <= RED;
                //middle + 1
                else if (x == ref_x + 20 && (y >= ref_y - 1 && y <= ref_y + 5))
                    colour <= RED;
                //middle + 2
                else if (x == ref_x + 21 && (y >= ref_y - 1 && y <= ref_y + 4))
                    colour <= RED;
                else 
                    colour <= 6'b000000;
            end
        endcase
    end
endmodule