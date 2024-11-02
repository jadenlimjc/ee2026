`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 22:28:25
// Design Name: 
// Module Name: check_collisions
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


module check_collisions
#(
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96,
    parameter MAP_ROW_SIZE = 200,
    parameter MAP_HEIGHT_SIZE =200,
    parameter BORDER = 15,
    parameter TANK_HITBOX =9,  
    parameter BULLET_HITBOX =3,
    parameter WHITE = 16'hFFFF,
    parameter BLACK = 16'h0,
    parameter COLOUR_RED = 16'hF800,
    parameter COLOUR_GREEN = 16'h07E0,
    parameter COLOUR_BLUE = 16'h001F,
    parameter COLOUR_ORANGE = 16'hFBE0
    )
    (
    input clksig,
    input [31:0] next_tank_ptr,
    input bullet, pass,
    output reg collisions

    );
    
    wire [7:0] next_tank_x,next_tank_y;
    assign next_tank_x = next_tank_ptr%MAP_ROW_SIZE;  //tank_x coordinate in relation to MAP
    assign next_tank_y = next_tank_ptr/MAP_ROW_SIZE;  //tank_y coordinate in relation to MAP

    reg [2:0] count = BORDER;
    wire [3:0]HITBOX;
    assign HITBOX = bullet ? BULLET_HITBOX : TANK_HITBOX; // 0 for tank 1 for bullet 

    
    // Check for collision between tank and the red square
    always @ (posedge clksig) begin
       if (
           // Update obstacle positions based on the map layout
           ((next_tank_x + HITBOX >= 50) && (next_tank_x <= 75) && 
            (next_tank_y + HITBOX >= 40) && (next_tank_y <= 65)) || // Top-left obstacle
           
           ((next_tank_x + HITBOX >= 125) && (next_tank_x <= 150) && 
            (next_tank_y + HITBOX >= 40) && (next_tank_y <= 65)) || // Top-right obstacle
           
           ((next_tank_x + HITBOX >= 85) && (next_tank_x <= 115) && 
            (next_tank_y + HITBOX >= 85) && (next_tank_y <= 115)) || // Center obstacle
   
           ((next_tank_x + HITBOX >= 50) && (next_tank_x <= 75) && 
            (next_tank_y + HITBOX >= 135) && (next_tank_y <= 160)) || // Bottom-left obstacle
           
           ((next_tank_x + HITBOX >= 125) && (next_tank_x <= 150) && 
            (next_tank_y + HITBOX >= 135) && (next_tank_y <= 160))    // Bottom-right obstacle
       ) begin
            if (!pass) begin
           collisions <= 1; // Collision detected
           end
           else begin
           collisions <= 0;
           end
        end
        else if (next_tank_x <= BORDER  ||next_tank_x + HITBOX >= MAP_ROW_SIZE- BORDER  ||next_tank_y <= BORDER  ||next_tank_y  + HITBOX >= MAP_HEIGHT_SIZE- BORDER ) collisions <=1;
        
        else begin
            collisions <= 0; // No collision
        end
    end
    
endmodule
