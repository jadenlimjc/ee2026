`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 16:42:34
// Design Name: 
// Module Name: hud_display
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


module hud_display(
    input clk,
    input [5:0] player_state,
    input [12:0] pixel_index, output reg [15:0] oled_data

    );
   
   // Screen dimensions
   parameter SCREEN_WIDTH = 96;
   parameter SCREEN_HEIGHT = 64;

   wire [6:0] x; 
   wire [6:0] y;
   assign x = pixel_index % SCREEN_WIDTH;
   assign y = pixel_index / SCREEN_WIDTH;
    
    parameter ORANGE = 16'b1111110001001000;
    parameter YELLOW = 16'b1111010110101011;
    parameter RED = 16'b1111100000000000;
    parameter WHITE = 16'b1111111111111111;
    parameter BLACK = 16'b0000000000000000;
    
    wire [15:0] p1, n1;
    wire [15:0] h1, w1;
    
    draw_P player (
        .clk(clk),
        .x(x),
        .y(y),
        .ref_x(4),
        .ref_y(5),
        .colour(p1)
    );
    
    draw_number number (
        .clk(clk),
        .x (x),
        .y(y),
        .ref_x(15),
        .ref_y(6),
        .player_no(player_state[1:0]),
        .colour(n1)
    );
    draw_heart heart1 (
        .clk(clk),
        .x(x),
        .y(y),
        .ref_x(20),
        .ref_y(2),
        .no_of_lives(player_state[3:2]),
        .colour(h1)
    );
    draw_power power (
        .clk(clk),
        .x(x),
        .y(y),
        .ref_x(60),
        .ref_y(10),
        .power_state(player_state[5:4]),
        .colour(w1)
    );
    
     // state definition for player states
    // [1:0] corresponds to player no.
    // [3:2] corresponds to no. of lives.
    // [5:4] corresponds to powerups equipped   
                     
    always @ (*) begin
        if (p1 != BLACK)
            oled_data <= p1;
        if (n1 != BLACK)
            oled_data <= n1;
        if (w1 != BLACK)
            oled_data <= w1;
        if (h1 != BLACK)
            oled_data <= h1;
        
    end
     
    
        
endmodule
