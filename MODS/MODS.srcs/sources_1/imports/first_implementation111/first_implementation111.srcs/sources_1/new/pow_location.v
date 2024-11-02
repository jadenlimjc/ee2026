`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 10:21:58
// Design Name: 
// Module Name: pow_location
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


module pow_location#(
 parameter MAP_ROW_SIZE = 200
)(input clksig, col_pow,have, output reg [31:0] powptr = 0);
reg [7:0] lfsr_x = 8'b10101010;  // Initial value for x LFSR
    reg [7:0] lfsr_y = 8'b11010101;  // Initial value for y LFSR
    reg [7:0] x = 0;
    reg [7:0] y = 0;
    wire feedback_x, feedback_y;

    assign feedback_x = lfsr_x[7] ^ lfsr_x[5] ^ lfsr_x[4] ^ lfsr_x[3];  // Feedback for x
    assign feedback_y = lfsr_y[7] ^ lfsr_y[6] ^ lfsr_y[5] ^ lfsr_y[4];  // Feedback for y
    always @ (posedge clksig)
    begin
    if (!have) begin
    if (col_pow) begin
        lfsr_x <= {lfsr_x[6:0], feedback_x};
        lfsr_y <= {lfsr_y[6:0], feedback_y};
        
        // Scale the values to approximately fit within 0-200 range
        x <= (lfsr_x * 201) >> 8;  // Scale lfsr_x to 0-200 range
        y <= (lfsr_y * 201) >> 8;  // Scale lfsr_y to 0-200 range
        powptr <= y*MAP_ROW_SIZE+x;
        end
    else begin
        x <= x;
        y <= y;
        powptr <= y*MAP_ROW_SIZE + x;
        end
    end
    else begin
        x <= x;
        y <= y;
        powptr <= powptr;
    end
    end
endmodule

