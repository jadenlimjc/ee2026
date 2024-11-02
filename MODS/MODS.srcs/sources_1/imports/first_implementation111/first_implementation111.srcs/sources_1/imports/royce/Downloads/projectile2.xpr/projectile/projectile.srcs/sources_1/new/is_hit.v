`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2024 08:52:22
// Design Name: 
// Module Name: is_hit
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


    module is_hit (
        input clksig1k,
        input switch,
        input [23:0] xpos_bus,    // Bus for all projectile x positions
        input [23:0] ypos_bus,    // Bus for all projectile y positions
        input [31:0] player2,                     // Opponent tank
        output reg [2:0] hit_wall = 0, // Output array for each projectile's wall hit status
        output reg [2:0] hit_tank = 0  // Output array for each projectile's tank hit status
    );
    
parameter MAX_PROJECTILES = 3;
parameter xmin = 0;
parameter xmax = 200;
parameter ymin = 0;
parameter ymax = 200;
    parameter TANK_HITBOX =9;  
parameter BULLET_HITBOX =3;
parameter MAP_ROW_SIZE = 200;
wire[7:0] opp_tanky;
wire[7:0] opp_tankx;
assign opp_tankx = player2%MAP_ROW_SIZE;
assign opp_tanky = player2/MAP_ROW_SIZE;
wire collision;



// Calculating positions in memory for each projectile based on MAP_ROW_SIZE
wire [31:0] pro0;
assign pro0 =  xpos_bus[7:0] + ypos_bus[7:0] * MAP_ROW_SIZE;
wire [31:0] pro1;
assign pro1 = xpos_bus[15:8] + ypos_bus[15:8] * MAP_ROW_SIZE;
wire [31:0] pro2;
assign pro2 = xpos_bus[23:16]+ ypos_bus[23:16]* MAP_ROW_SIZE;
wire col0;
wire col1;
wire col2;
check_collisions c0(.clksig(clksig1k), .next_tank_ptr(pro0),.bullet(1), .pass(switch), .collisions(col0));
check_collisions c1(.clksig(clksig1k), .next_tank_ptr(pro1),.bullet(1), .pass(switch),.collisions(col1)); // Collision for pro1
check_collisions c2(.clksig(clksig1k), .next_tank_ptr(pro2),.bullet(1), .pass(switch),.collisions(col2)); // Collision for pro2

reg [7:0] xpos [0:MAX_PROJECTILES-1];  // Array for individual projectile x positions
reg [7:0] ypos [0:MAX_PROJECTILES-1];  // Array for individual projectile y positions

integer i;

always @(xpos_bus,ypos_bus) begin
    // Extract xpos and ypos from the buses
    xpos[0] = xpos_bus[7:0];
    xpos[1] = xpos_bus[15:8];
    xpos[2] = xpos_bus[23:16];
    ypos[0] = ypos_bus[7:0];
    ypos[1] = ypos_bus[15:8];
    ypos[2] = ypos_bus[23:16];

//    // Iterate through all projectiles
 
//        // Wall hit detection
//        if (xpos[0] > xmax || xpos[0] < xmin || ypos[0] > ymax || ypos[0] < ymin) begin
//            hit_wall[0] <= 1;
//        end else begin
//            hit_wall[0] <= 0;
//        end

//        if (xpos[1] > xmax || xpos[1] < xmin || ypos[1] > ymax || ypos[1] < ymin) begin
//            hit_wall[1] <= 1;
//        end else begin
//            hit_wall[1] <= 0;
//        end
       
//        if (xpos[2] > xmax || xpos[2] < xmin || ypos[2] > ymax || ypos[2] < ymin) begin
//            hit_wall[2] <= 1;
//        end else begin
//            hit_wall[2] <= 0;
//        end
        if (col0) hit_wall[0] <=1;
        else hit_wall[0] <=0;
        if (col1) hit_wall[1] <=1;
        else hit_wall[1] <=0;
        if (col2) hit_wall[2] <=1;
        else hit_wall[2] <=0;
        
        // Tank hit detection
        if ((xpos[0]+ BULLET_HITBOX >= opp_tankx && xpos[0] < opp_tankx + TANK_HITBOX) &&  // Projectile in X bounds of tank
            (ypos[0]+ BULLET_HITBOX >= opp_tanky && ypos[0] < opp_tanky + TANK_HITBOX))   // Projectile in Y bounds of tank
        begin
            hit_tank[0] <= 1;
        end else begin
            hit_tank[0] <= 0;
        end
    
        if ((xpos[1]+ BULLET_HITBOX >= opp_tankx && xpos[1] < opp_tankx + TANK_HITBOX) &&  // Projectile in X bounds of tank
            (ypos[1]+ BULLET_HITBOX >= opp_tanky && ypos[1] < opp_tanky + TANK_HITBOX))   // Projectile in Y bounds of tank
        begin
           hit_tank[1] <= 1;
        end else begin
           hit_tank[1] <= 0;
        end
        
        if ((xpos[2]+ BULLET_HITBOX >= opp_tankx && xpos[2] < opp_tankx + TANK_HITBOX) &&  // Projectile in X bounds of tank
            (ypos[2]+ BULLET_HITBOX >= opp_tanky && ypos[2] < opp_tanky + TANK_HITBOX))   // Projectile in Y bounds of tank
        begin
           hit_tank[2] <= 1;
        end else begin
           hit_tank[2] <= 0;
        end
        
end

endmodule

