`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 21:57:30
// Design Name: 
// Module Name: is_power
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


module is_power#(
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96,
    parameter MAP_ROW_SIZE = 200,
    parameter MAP_HEIGHT_SIZE =200,
    parameter TANK_HITBOX =9
    )
(input clksig, on, on1,
input [31:0] tank_ptr,
output reg [1:0] have = 0
);
wire [7:0]x;
wire [7:0]y;
assign x = tank_ptr%MAP_ROW_SIZE;  //tank_x coordinate in relation to MAP
assign y = tank_ptr/MAP_ROW_SIZE;  //tank_y coordinate in relation to MAP
always @ (posedge clksig)
begin
if ((x + TANK_HITBOX >= 20) && (x <= 25) && (y + TANK_HITBOX >= 20) && (y <= 25))
begin
have[0] <= 1;
end

else if (on == 0)
begin
have[0] <= 0;
end

if ((x + TANK_HITBOX >= 180) && (x <= 185) && (y + TANK_HITBOX >= 180) && (y <= 185))
begin
have[1] <= 1;
end

else if (on1 == 0)
begin
have[1] <= 0;
end

end
endmodule
