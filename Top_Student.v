`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Royce Wong
//  STUDENT B NAME: Nicholas
//  STUDENT C NAME: Jaden Lim
//  STUDENT D NAME: Irwin Teo
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk, [5:0] sw,
    output [7:0] JB
);


    reg [15:0] pixel_data;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    wire clock_signal;
    wire frame_begin;
    
    wire [15:0] pixel_data_hud;
    
    // state definition for player states
    // [1:0] corresponds to player no.
    // [3:2] corresponds to no. of lives.
    // [5:4] corresponds to powerups equipped
    
    wire [5:0] player_state;
    
    localparam [1:0] ONE = 2'b00,
                     TWO = 2'b01,
                     THREE = 2'b10,
                     FOUR = 2'b11;
                     
    localparam [1:0] NONE = 2'b00,
                     FIRE = 2'b01,
                     WATER = 2'b10,
                     FIREWATER = 2'b11;
                     

            
    wire clksig6p25m;
    custom_clock clk6p25m (
        .clk(clk),
        .cycle_delay(7),
        .clock_signal(clksig6p25m)
    );

        
    hud_display hud (
        .clk(clk),
        .player_state(player_state),        
        .pixel_index(pixel_index),
        .oled_data(pixel_data_hud)
    );
    
    Oled_Display oled (
        .clk(clksig6p25m),
        .reset(0),
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index), 
        .pixel_data(pixel_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]),
        .pmoden(JB[7])
    );
    
    assign player_state = sw[5:0];


    always @(pixel_index) begin
        pixel_data <= pixel_data_hud;
     end

endmodule