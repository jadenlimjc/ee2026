`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2024 17:42:49
// Design Name: 
// Module Name: projectile_display
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


module projectile_display(
    input [23:0] projx_bus,   // Bus for all projectile x positions
    input [23:0] projy_bus,   // Bus for all projectile y positions
    input [12:0] pixel_index, 
    input [7:0] opp_tankx,
    input [7:0] opp_tanky,
    input [2:0] hit_wall,
    input [2:0] hit_tank,            // Array of hit flags for each projectile
    output reg [15:0] pixel_data,
    output reg led
);
    parameter MAX_PROJECTILES = 3;
    wire [7:0] curr_x;
    wire [7:0] curr_y;
    assign curr_x = pixel_index % 96;
    assign curr_y = pixel_index / 96;

    parameter green = 16'h07E0;
    parameter black = 16'h0000;
    parameter blue = 16'h4A18;
    parameter TANK_WIDTH = 3;
    parameter TANK_HEIGHT = 3;

    // Temporary registers for projectile positions
    reg [7:0] projx [0:MAX_PROJECTILES-1];  // Individual projectile x positions
    reg [7:0] projy [0:MAX_PROJECTILES-1];  // Individual projectile y positions

    integer i;

    always @(*) begin
        // Extract positions from buses
        projx[0] = projx_bus[7:0];
        projx[1] = projx_bus[15:8];
        projx[2] = projx_bus[23:16];
        projy[0] = projy_bus[7:0];
        projy[1] = projy_bus[15:8];
        projy[2] = projy_bus[23:16];
        // Default values
        pixel_data = black;
        led = 0;

        // Check for tank collision
        if (curr_x >= opp_tankx && curr_x < opp_tankx + TANK_WIDTH &&
            curr_y >= opp_tanky && curr_y < opp_tanky + TANK_HEIGHT) begin
            pixel_data = blue; // Tank color
        end

        // Check each projectile
            if ( !(hit_wall[0] || hit_tank[0]) && curr_x >= projx[0] - 1 && curr_x <= projx[0] + 1 && curr_y == projy[0] - 1) begin
                pixel_data = green; // Projectile color
                led = 1; // Set LED if projectile is active
            end
            
            if ( !(hit_wall[1] || hit_tank[1]) && curr_x >= projx[1] - 1 && curr_x <= projx[1] + 1 && curr_y == projy[1] - 1) begin
                pixel_data = green; // Projectile color
                led = 1; // Set LED if projectile is active
            end
            
            if ( !(hit_wall[2] || hit_tank[2]) && curr_x >= projx[2] - 1 && curr_x <= projx[2] + 1 && curr_y == projy[2] - 1) begin
                pixel_data = green; // Projectile color
                led = 1; // Set LED if projectile is active
            end
    end
endmodule
