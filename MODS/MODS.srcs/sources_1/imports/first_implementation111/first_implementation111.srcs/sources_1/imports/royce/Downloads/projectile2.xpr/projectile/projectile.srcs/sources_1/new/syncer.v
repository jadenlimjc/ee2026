`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2024 14:39:31
// Design Name: 
// Module Name: syncer
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


module syncer(input proj_clk, input [31:0] tankptr, input [3:0] dir, output reg [31:0] sync_tankptr,
output reg [3:0] sync_dir);
always @ (posedge proj_clk)
begin
sync_dir <= dir;
sync_tankptr <= tankptr;
end
endmodule
