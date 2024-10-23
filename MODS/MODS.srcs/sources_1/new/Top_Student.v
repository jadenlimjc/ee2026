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
    input clk, [15:0] sw, 
    input btnC, btnL, btnU, btnD, 
    output [6:0] seg, [3:0] an,
    output [7:0] JB
);


    reg [15:0] pixel_data;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    wire clock_signal;
    wire frame_begin;
    
    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 12;
    
    wire [31:0] clk_param;
    
    wire [15:0] pixel_data_menu;
    
    wire clk_25M, clk_6p25M, clk_frameRate;
    
    reg reset = 0;
    
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    
    wire [15:0] pixel_data_hud;
    
    //state definitions for what to display
    localparam [1:0] INTRO = 2'b00,
                     HUD   = 2'b01;   
    
    reg [1:0] display_settings = 2'b00;
    // state definition for player states
    // [1:0] corresponds to player no.
    // [3:2] corresponds to no. of lives.
    // [5:4] corresponds to powerups equipped
    
    wire [5:0] player_state;
            
    wire clksig6p25m, clksig1, clksig10;
    custom_clock clk6p25m (
        .clk(clk),
        .cycle_delay(7),
        .clock_signal(clksig6p25m)
    );
    
    custom_clock clksig1hz (
        .clk(clk),
        .cycle_delay(50000000),
        .clock_signal(clksig1)
    );
    
    custom_clock clksig10hz (
        .clk(clk),
        .cycle_delay(50000),
        .clock_signal(clksig10)
    );
    
    custom_clock clkframeRate (
        .clk(clk),
        .cycle_delay(clk_param),
        .clock_signal(clk_frameRate)
    );
    
    menu_display menu (
        .clk(clk_frameRate),
         .btnC(btnC),
         .btnU(btnU), 
         .btnL(btnL), 
         .btnD(btnD), 
         .pixel_index(pixel_index), 
         .display_settings(display_settings),
         .oled_data(pixel_data_menu)
     );

        
    hud_display hud (
        .clk(clksig6p25m),
        .player_state(player_state),     
        .display_settings(display_settings),   
        .pixel_index(pixel_index),
        .oled_data(pixel_data_hud)
    );
    
    game_timer timer (
        .clk(clk),
        .clk1hz(clksig1),
        .clk10hz(clksig10),
        .reset(sw[11]),
        .start(sw[13]),
        .pause(sw[12]),
        .seg(seg),
        .an(an)
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


    always @(posedge clk) begin
        if (display_settings == INTRO) begin
            pixel_data <= pixel_data_menu;
        end else if (display_settings == HUD) begin
            pixel_data <= pixel_data_hud;
        end
     end

endmodule