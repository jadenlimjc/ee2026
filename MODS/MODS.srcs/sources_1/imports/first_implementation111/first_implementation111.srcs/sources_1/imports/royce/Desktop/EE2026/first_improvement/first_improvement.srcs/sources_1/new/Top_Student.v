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
   input clk,
    input [4:0] btn,
    input [15:0] sw,
    output [7:0] JC,
    [15:0]led,
    input JA1,
    output JA0
);


    reg [15:0] pixel_data;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    wire clock_signal;
    wire frame_begin;
    wire [23:0]p2_yposbus;
    wire [23:0]p2_xposbus;
            
    wire clksig6p25m,clk_frameRate;
    wire clksig20,clksig40;


    custom_clock clk6p25m (
        .clk(clk),
        .cycle_delay(7),
        .clock_signal(clksig6p25m)
    );
    custom_clock clk20 (
        .clk(clk),
        .cycle_delay(2_499_999),
        .clock_signal(clksig20)
    );
    custom_clock clk1khz (
            .clk(clk),
            .cycle_delay(49999),
            .clock_signal(clksig1k)
        );
        


    
   
    Oled_Display oled (
        .clk(clksig6p25m),
        .reset(0),
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index), 
        .pixel_data(pixel_data), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );

    wire [15:0] display;
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
            .projx_bus(xpos_bus),   // Bus for all projectile x positions
            .projy_bus(ypos_bus),   // Bus for all projectile y positions
            .p2_yposbus(p2_yposbus),   // Bus for all projectile x positions
            .p2_xposbus(p2_xposbus),   // Bus for all projectile y positions
            .player2(player2),
            .hit_wall(hit_wall),
            .hit_tank(hit_tank),
            .p2hit_wall(p2hit_wall),
            .p2hit_tank(p2hit_tank), 
            .pixel_data(display)
            
        );

    assign led [15:8] =hit_wall;
    
    always @ (pixel_index) begin
    pixel_data <= display;
    
    end
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


endmodule