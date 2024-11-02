`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2024 13:29:56
// Design Name: 
// Module Name: show_display
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


module show_display
#(
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96,
    parameter MAP_ROW_SIZE = 200,
    parameter MAP_HEIGHT_SIZE =200,
    parameter TANK_HITBOX =9,  
//    parameter WHITE = 16'hFFFF,
//    parameter BLACK = 16'h0,
//    parameter COLOUR_RED = 16'hF800,
//    parameter COLOUR_GREEN = 16'h07E0,
//    parameter COLOUR_BLUE = 16'h001F,
//    parameter COLOUR_ORANGE = 16'hFBE0,
//    parameter COLOUR_GREY    = 16'h8410,
//    parameter COLOUR_BEIGE = 16'hF733,
    parameter WHITE = 6'b111111,  // 63
    parameter BLACK = 6'b000000,  // 0
    parameter COLOUR_RED = 6'b111000,    // 28
    parameter COLOUR_GREEN = 6'b000111,  // 7
    parameter COLOUR_BLUE = 6'b000000,   // 0
    parameter COLOUR_ORANGE = 6'b111011, // 59
    parameter COLOUR_GREY = 6'b011011,   // 27
    parameter COLOUR_BEIGE = 6'b111101,  // 61
    parameter MAX_PROJECTILES = 3,
    parameter BORDER = 15,
    parameter BULLET_HITBOX =3
    )
    (
    input clk,
    input [1:0] have,
    input [12:0]pixel_index,
    input [31:0] frame_ptr,
    input [31:0] tank_ptr,
    input [31:0] next_tank_ptr,
    input [15:0] background_img, 
    input [3:0] tank_dir,
    input [23:0] projx_bus,   // Bus for all projectile x positions
    input [23:0] projy_bus,   // Bus for all projectile y positions
    input [23:0] p2_yposbus,   // Bus for all projectile x positions
    input [23:0] p2_xposbus,   // Bus for all projectile y positions
    input [31:0] player2,
    input [2:0] hit_wall,
    input [2:0] hit_tank,            // Array of hit flags for each projectile
    input [2:0] p2hit_wall,
    input [2:0] p2hit_tank,            // Array of hit flags for each projectile
  
    output reg [5:0] pixel_data
    
);
    
    wire [7:0] map_x,map_y,pix_x,pix_y,tank_x,tank_y,next_tank_x,next_tank_y,powx,powy;
    wire [31:0] map_index;
    assign tank_x = tank_ptr%MAP_ROW_SIZE;  //tank_x coordinate in relation to MAP
    assign tank_y = tank_ptr/MAP_ROW_SIZE;  //tank_y coordinate in relation to MAP
    assign next_tank_x = next_tank_ptr%MAP_ROW_SIZE;  //tank_x coordinate in relation to MAP
    assign next_tank_y = next_tank_ptr/MAP_ROW_SIZE;  //tank_y coordinate in relation to MAP
    assign map_x = pixel_index%96 + frame_ptr%MAP_ROW_SIZE;  //x coordinate in relation to MAP
    assign map_y = pixel_index/96 + frame_ptr/MAP_ROW_SIZE;  //y coordinate in relation to MAP
    assign pix_x = pixel_index%96;
     assign pix_y = pixel_index/96;
     wire[7:0] opp_tanky;
     wire[7:0] opp_tankx;
     assign opp_tankx = player2%MAP_ROW_SIZE;
     assign opp_tanky = player2/MAP_ROW_SIZE;
      // Temporary registers for projectile positions
        reg [7:0] projx [0:MAX_PROJECTILES-1];  // Individual projectile x positions
        reg [7:0] projy [0:MAX_PROJECTILES-1];  // Individual projectile y positions
        reg [7:0] p2projx [0:MAX_PROJECTILES-1];  // Individual projectile x positions
        reg [7:0] p2projy [0:MAX_PROJECTILES-1];  // Individual projectile y positions
    
        integer i;
    
    wire [5:0] t1, t2;
    
    wire [15:0] pixel_data_hud;
    wire [5:0] player1_state;
        
   draw_tank tank1 (
        .clk(clk),
        .x(map_x),
        .y(map_y),
        .ref_x(tank_x),
        .ref_y(tank_y),
        .player_no(2'b00),
        .tank_direction(tank_dir),
        .colour(t1)
    );
    
    draw_tank tank2 (
            .clk(clk),
            .x(map_x),
            .y(map_y),
            .ref_x(opp_tankx),
            .ref_y(opp_tanky),
            .player_no(2'b01),
            .tank_direction(tank_dir),
            .colour(t2)
        );


    always @(*) begin
                projx[0] <= projx_bus[7:0];
                projx[1] <= projx_bus[15:8];
                projx[2] <= projx_bus[23:16];
                projy[0] <= projy_bus[7:0];
                projy[1] <= projy_bus[15:8];
                projy[2] <= projy_bus[23:16];
                p2projx[0] <= p2_xposbus[7:0];
                p2projx[1] <= p2_xposbus[15:8];
                p2projx[2] <= p2_xposbus[23:16];
                p2projy[0] <= p2_yposbus[7:0];
                p2projy[1] <= p2_yposbus[15:8];
                p2projy[2] <= p2_yposbus[23:16];
if ( !(hit_wall[0] || hit_tank[0]) && map_x >= projx[0]&& map_x <= projx[0] + BULLET_HITBOX && 
                map_y >= projy[0] && map_y <= projy[0] + BULLET_HITBOX) begin
                pixel_data <= BLACK; // Projectile color
            //    led = 1; // Set LED if projectile is active
            end
            
            else if ( !(hit_wall[1] || hit_tank[1]) && map_x >= projx[1] && map_x <= projx[1] + BULLET_HITBOX && 
                     map_y >= projy[1]&& map_y <= projy[1] + BULLET_HITBOX) begin
                pixel_data <= BLACK; // Projectile color
            //    led = 1; // Set LED if projectile is active
            end
            
            else if ( !(hit_wall[2] || hit_tank[2]) && map_x >= projx[2] && map_x <= projx[2] + BULLET_HITBOX && 
                     map_y >= projy[2] && map_y <= projy[2] + BULLET_HITBOX) begin
                pixel_data <= BLACK; // Projectile color
            //    led = 1; // Set LED if projectile is active
            end
            
            // Check each projectile for player 2
           else if (!(p2hit_wall[0] || p2hit_tank[0])&& ((map_x - p2projx[0]) * (map_x - p2projx[0]) + 
                       (map_y - p2projy[0]) * (map_y - p2projy[0])) <= (BULLET_HITBOX / 2) * (BULLET_HITBOX / 2)) 
            begin
                pixel_data <= COLOUR_BLUE; // Projectile color
                // led = 1; // Set LED if projectile is active
            end
            
            // Projectile 1 with circular hitbox
            else if ( !(p2hit_wall[0] || p2hit_tank[0])&& ((map_x - p2projx[1]) * (map_x - p2projx[1]) + 
                       (map_y - p2projy[1]) * (map_y - p2projy[1])) <= (BULLET_HITBOX / 2) * (BULLET_HITBOX / 2)) 
            begin
                pixel_data <= COLOUR_BLUE; // Projectile color
                // led = 1; // Set LED if projectile is active
            end
            
            // Projectile 2 with circular hitbox
            else if ( !(p2hit_wall[0] || p2hit_tank[0])&& ((map_x - p2projx[2]) * (map_x - p2projx[2]) + 
                       (map_y - p2projy[2]) * (map_y - p2projy[2])) <= (BULLET_HITBOX / 2) * (BULLET_HITBOX / 2)) 
            begin
                pixel_data <= COLOUR_BLUE; // Projectile color
                // led = 1; // Set LED if projectile is active
            end
            
            else if (!have[0] && (map_x >= 20) && (map_x <= 25) && (map_y >= 20) && (map_y <= 25) )
            begin
                pixel_data <= COLOUR_ORANGE; //POWER SAME SIZE AS BULLET
            end
            
            else if (!have[1] && (map_x >= 180) && (map_x <= 185) && (map_y >= 180) && (map_y <= 185))
            begin
                pixel_data <= COLOUR_ORANGE;
            end
                    
                else if ( map_x >= tank_x && map_x <= tank_x + TANK_HITBOX&& map_y >= tank_y && map_y <= tank_y + TANK_HITBOX) pixel_data <= t1;         
//                if ( map_x >= next_tank_x && map_x <= next_tank_x + TANK_HITBOX&& map_y >= next_tank_y && map_y <= next_tank_y + TANK_HITBOX) colour <= COLOUR_GREEN;         
               else if ( map_x >= opp_tankx && map_x <= opp_tankx + TANK_HITBOX&& map_y >= opp_tanky && map_y <= opp_tanky + TANK_HITBOX) pixel_data <= t2;
//                else if (map_x >= 35 && map_x <= 60 && map_y >= 20 && map_y  <= 45) //make square //SIMULATE OBSTACLES
//                begin
//                    pixel_data <= COLOUR_RED ;
                    
//                    end
//                else if (map_x >= MAP_ROW_SIZE-25 && map_x <= MAP_ROW_SIZE && map_y >= MAP_HEIGHT_SIZE-25 && map_y  <= MAP_HEIGHT_SIZE) //make square //SIMULATE OBSTACLES
//                      pixel_data <= COLOUR_GREEN ;
                else if (
    // Top-left obstacle
                (map_x >= 50 && map_x <= 75 && map_y >= 40 && map_y <= 65) ||

    // Top-right obstacle
                (map_x >= 125 && map_x <= 150 && map_y >= 40 && map_y <= 65) ||

    // Center obstacle
                (map_x >= 85 && map_x <= 115 && map_y >= 85 && map_y <= 115) ||

    // Bottom-left obstacle
                (map_x >= 50 && map_x <= 75 && map_y >= 135 && map_y <= 160) ||

    // Bottom-right obstacle
                 (map_x >= 125 && map_x <= 150 && map_y >= 135 && map_y <= 160)
                ) begin
                pixel_data <= COLOUR_GREY; // Set the color for obstacle areas
                    end
                  else if (map_x <= BORDER  ||map_x  >= MAP_ROW_SIZE- BORDER  ||map_y <= BORDER  ||map_y >= MAP_HEIGHT_SIZE- BORDER ) pixel_data <= COLOUR_BLUE ;
                  
   
                else // rest emmpty
                    pixel_data <= COLOUR_BEIGE; // put background image here
                    
                
                            
                end 
    
    

    
endmodule
