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
    wire reset_game;
    wire pause_game;
    
    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 12;
    
    wire [31:0] clk_param;
    
    wire [15:0] pixel_data_menu, pixel_data_hud, pixel_data_end, pixel_data_winner;
    
    wire clk_25M, clk_6p25M, clk_frameRate;
    
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    
    //state definitions for what to display
    localparam [1:0] INTRO = 2'b00,
                     HUD   = 2'b01,
                     END   = 2'b10; 
    
    reg [1:0] display_settings = 2'b00;
    wire [1:0] winner;
    
    // state definition for player states
    // [1:0] corresponds to player no.
    // [3:2] corresponds to no. of lives.
    // [5:4] corresponds to powerups equipped
    
    wire [5:0] player1_state, player2_state, player3_state, player4_state;
    wire game_start, game_end, game_running, early_end;
    
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
    
//    menu_display menu (
//         .frame_rate(clk_frameRate),
//         .btnC(btnC),
//         .btnU(btnU), 
//         .btnL(btnL), 
//         .btnD(btnD), 
//         .pixel_index(pixel_index), 
//         .display_settings(display_settings),
//         .oled_data(pixel_data_menu),
//         .game_start(game_start)
//     );

        
    hud_display hud (
        .clk(clksig6p25m),
        .player_state(player1_state),     
        .display_settings(display_settings),   
        .pixel_index(pixel_index),
        .oled_data(pixel_data_hud)
    );
    
    game_timer timer (
        .clk(clk),
        .clk1hz(clksig1),
        .clk10hz(clksig10),
        .reset(reset_game),
        .early_end(early_end),
        .start(sw[8]),
        .pause(pause_game),
        .seg(seg),
        .an(an),
        .game_end(game_end)
    );
    
    end_menu_display end_menu (
        .clk(clk),
        .pixel_index(pixel_index),
        .oled_data(pixel_data_end)
    );
    
    get_winner winner_number(
        .clk(clk),
        .player1_state(player1_state),
        .player2_state(player2_state),
        .player3_state(player3_state),
        .player4_state(player4_state),
        .game_end(game_end),
        .winner(winner),
        .early_end(early_end)
    );
    
    draw_winner player_no (
        .clk(clk),
        .winner(winner),
        .pixel_index(pixel_index),
        .colour(pixel_data_winner)
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
    
    
    
    assign player1_state = sw[5:0];
    assign player2_state = 6'b000101;
    assign player3_state = 6'b001010;
    assign player4_state = 6'b001111;
    assign reset_game = sw[13];
    assign pause_game = sw[12];
    
    //game state manager
    always @(posedge clk) begin
        //detect button press and intro completion
        //change to btnC instead of game_start temporarily 
        if (display_settings == INTRO && btnC) begin       
            display_settings <= HUD;
        end else if (display_settings == HUD && game_end) begin
            display_settings <= END;
        end else if (display_settings == END && btnC) begin
            display_settings <= INTRO;
        end
    end

    //oled display manager based on game_state
    always @(posedge clk) begin
        if (display_settings == INTRO) begin
        //change to 0 instead of pixel_data_menu
            pixel_data <= 16'h0000;
        end else if (display_settings == HUD) begin
            pixel_data <= pixel_data_hud;
        end else if (display_settings == END) begin
            pixel_data <= pixel_data_end | pixel_data_winner;
        end
     end

endmodule