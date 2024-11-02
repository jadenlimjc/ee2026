`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 22:26:37
// Design Name: 
// Module Name: power_timer
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


module power_timer(input clksig20, have, output reg on = 0);
reg [31:0] count = 0;
//reg have_prev = 0;
//wire have_edge = (have && !have_prev);
always @ (posedge clksig20)
begin
if (have) begin
    count <= count + 1;
    on <= 1;
    if (count >= 600) begin
    on <= 0;
    count <= 0;
    end
end
end
endmodule
