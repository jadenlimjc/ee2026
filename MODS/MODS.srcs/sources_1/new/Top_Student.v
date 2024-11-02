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
    input [4:0] btn,
    input JA1, 
    output JA0,
    output [15:0] led,
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
    wire [23:0]p2_yposbus;
    wire [23:0]p2_xposbus;
    
    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 12;
    
    wire [31:0] clk_param;
    
    wire [5:0] pixel_data_menu, pixel_data_game, pixel_data_end, pixel_data_winner, pixel_data_hud;
    
    wire clk_25M, clk_6p25M, clk_frameRate, clksig1k, clksig20;
    
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    
    //state definitions for what to display
    localparam [1:0] INTRO = 2'b00,
                     GAME   = 2'b01,
                     END   = 2'b10; 
    
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
    custom_clock clksig20hz (
        .clk(clk),
        .cycle_delay(25000),
        .clock_signal(clksig20)
    );
        reg [1:0] display_settings = 2'b00;
        
        wire [15:0] background;
        wire [31:0] map_index;
        wire [31:0] player2;
        wire [31:0] player3;
        wire [31:0] player4;
    //    
        wire [3:0] frame_dir,dir;
        wire [31:0] tank_ptr,next_tank_ptr;
        wire [31:0] frame_ptr; // first pixel of frame
        wire frame_req,frame_done;
        wire collisions;
        bkground dut (clk, frame_ptr, pixel_index, map_index);
        check_collisions(
        .clksig(clksig1k),
        .next_tank_ptr(next_tank_ptr),
        .bullet(0),
        .collisions(collisions)
        );
        move_tank movetank(
        .clksig(clksig20),
        .btn(btn),
        .frame_ptr(frame_ptr),
        .collisions(collisions),
        .dir(dir),
        .frame_dir(frame_dir),
        .tank_ptr(tank_ptr),
        .next_tank_ptr(next_tank_ptr)
    
        );
        
         move_frame movef ( // move frame
               
               .clksig(clksig20),
               .dir(frame_dir),
               .tank_ptr(tank_ptr),
                 .next_tank_ptr(next_tank_ptr),
                 .frame_move_request(frame_req),
                 .frame_moved_done(frame_done),
               .frame_ptr(frame_ptr)
           );
        wire [31:0] sync_tankptr;
        wire [3:0] sync_dir;
        syncer sync (
        .proj_clk(clksig20),
        .tankptr(tank_ptr),
        .dir(dir),
        .sync_tankptr(sync_tankptr),
        .sync_dir(sync_dir)
        );
        
        wire [1:0] have;
        wire power_on,power_on1;
        power_timer powtime (
            .clksig20(clksig20),
            .have(have[0]),
            .on(power_on)
            ); //multiple proj
        
        power_timer powtime1 (
                    .clksig20(clksig20),
                    .have(have[1]),
                    .on(power_on1)
                    ); //through walls
        
        is_power ispow (
        .clksig(clksig1k),
        .on(power_on),
        .on1(power_on1),
        .tank_ptr(tank_ptr),
        .have(have)
        );
        
        
        
        wire [23:0]xpos_bus;
        wire [23:0]ypos_bus;
        wire[2:0] hit_wall,p2hit_wall;
        wire [2:0] hit_tank,p2hit_tank;
        position_counter poscnt(
            .CLOCK(clk), 
            .slow_clk_20hz(clksig20),
            .tank_ptr(sync_tankptr),  // x and y are both 8-bit values tank
            .dir(sync_dir), 
            .switch(power_on),
            .switch1(sw[1]),
            .shoot(btn[0]), 
            .hit_wall(hit_wall),
            .hit_tank(hit_tank),
            .led(),
            .xpos_bus(xpos_bus),  // bus for projectile x positions (8 bits per projectile)
            .ypos_bus(ypos_bus) 
            );  // bus for projectile y positions (8 bits per projectile)
            is_hit ishit(
            .clksig1k(clksig1k),
                .switch(power_on1),
                .xpos_bus(xpos_bus),    // Bus for all projectile x positions
                .ypos_bus(ypos_bus),    // Bus for all projectile y positions
                .player2(player2),                     // Opponent tank  position
                .hit_wall(hit_wall), // Output array for each projectile's wall hit status
                .hit_tank(hit_tank)  // Output array for each projectile's tank hit status
            );
            is_hit ishit2(
                        .clksig1k(clksig1k),
                        .switch(power_on1),
                        .xpos_bus(p2_xposbus),    // Bus for all projectile x positions
                        .ypos_bus(p2_yposbus),    // Bus for all projectile y positions
                        .player2(tank_ptr),                     // Opponent tank  position
                        .hit_wall(p2hit_wall), // Output array for each projectile's wall hit status
                        .hit_tank(p2hit_tank)  // Output array for each projectile's tank hit status
                    );
            show_display show_dis( // calc colour
                .clk(clk),
                .have(have),
                .pixel_index(pixel_index),
                .frame_ptr(frame_ptr),
                .tank_ptr(tank_ptr),
                .next_tank_ptr(next_tank_ptr),
                .background_img(background),
                .tank_dir(dir),
                .projx_bus(xpos_bus),   // Bus for all projectile x positions
                .projy_bus(ypos_bus),   // Bus for all projectile y positions
                .p2_yposbus(p2_yposbus),   // Bus for all projectile x positions
                .p2_xposbus(p2_xposbus),   // Bus for all projectile y positions
                .player2(player2),
                .hit_wall(hit_wall),
                .hit_tank(hit_tank),
                .p2hit_wall(p2hit_wall),
                .p2hit_tank(p2hit_tank), 
                .pixel_data(pixel_data_game)
                
            );
    
        assign led [15:8] = hit_wall;
        localparam WORD_LEN = 80;
            
            wire rx_dv_1;
            wire [WORD_LEN-1:0] rx_byte_1;
            
            uart_rx #(.CLK_PER_BIT(868), .WORD_LEN(WORD_LEN)) rx_1 (
                .i_clock(clk),
                .i_rx_serial(JA1),
                .o_rx_dv(rx_dv_1), // high for 1 clock when done receiving
                .o_rx_byte(rx_byte_1)
            );
            
            reg [WORD_LEN-1:0] tx_byte_1;
            wire tx_active_1;
            reg tx_dv_1 = 0;
            wire tx_done_1;
            wire tx_serial;
            
            uart_tx #(.CLK_PER_BIT(868), .WORD_LEN(WORD_LEN)) tx_1 (
                .i_clock(clk),
                .i_tx_dv(tx_dv_1), // set high to enable sending
                .i_tx_byte(tx_byte_1),
                .o_tx_active(tx_active_1),
                .o_tx_serial(JA0),
                .o_tx_done(tx_done_1) // high for 1 clock when done sending
            );
            
            always @ (posedge clksig20)
            begin
                if (tx_active_1 == 0)
                begin
                    tx_byte_1 <= {xpos_bus, ypos_bus, tank_ptr};
                    tx_dv_1 <= 1;
                end
                else
                    tx_dv_1 <= 0;
            end
            
            assign player2 = rx_byte_1 [0 +: 32];
            assign p2_xposbus = rx_byte_1 [56 +: 24];
            assign p2_yposbus = rx_byte_1 [32 +: 24];

    
//    menu_display menu (
//         .frame_rate(clk_frameRate),
//         .btn(btn),
//         .pixel_index(pixel_index), 
//         .display_settings(display_settings),
//         .oled_data(pixel_data_menu),
//         .game_start(game_start)
//     );

        
    assign player1_state = {have, 2'b11, 2'b00};
            
    hud_display hud (
        .clk(clk),
        .player_state(player1_state),    
        .game_background(pixel_data_game), 
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
    
    
    
    assign player2_state = 6'b000101;
    assign player3_state = 6'b001010;
    assign player4_state = 6'b001111;
    assign reset_game = sw[13];
    assign pause_game = sw[12];
    
    //game state manager
    always @(posedge clk) begin
        //detect button press and intro completion
        //change to btnC instead of game_start temporarily 
        if (display_settings == INTRO && btn[0]) begin       
            display_settings <= GAME;
        end else if (display_settings == GAME && game_end) begin
            display_settings <= END;
        end else if (display_settings == END && btn[0]) begin
            display_settings <= INTRO;
        end
    end
    
    reg [4:0] red; 
    reg [5:0] green;
    reg [4:0] blue;
    reg [5:0] data;

    //oled display manager based on game_state
    always @(posedge clk) begin
        if (display_settings == INTRO) begin
        //change to 0 instead of pixel_data_menu
//            data <= pixel_data_menu;
//            red[4:3] <= data[4 +: 2];
//            green[5:4] <= data[2 +: 2];
//            blue[4:3] <= data[0 +: 2];
            
//            pixel_data <= {red, green, blue};
            pixel_data <= 0;
        end else if (display_settings == GAME) begin
            data <= pixel_data_hud;
            red[4:3] <= data[4 +: 2];
            green[5:4] <= data[2 +: 2];
            blue[4:3] <= data[0 +: 2];
            
            pixel_data <= {red, green, blue};
        end else if (display_settings == END) begin
            data <= pixel_data_end | pixel_data_winner;
            red[4:3] <= data[4 +: 2];
            green[5:4] <= data[2 +: 2];
            blue[4:3] <= data[0 +: 2];
            
            pixel_data <= {red, green, blue};
        end
     end

endmodule