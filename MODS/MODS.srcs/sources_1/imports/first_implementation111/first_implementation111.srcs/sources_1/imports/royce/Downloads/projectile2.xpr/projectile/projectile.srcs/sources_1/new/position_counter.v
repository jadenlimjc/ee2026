
module position_counter
#(
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96,
    parameter MAP_ROW_SIZE = 200,
    parameter MAP_HEIGHT_SIZE =200,
    parameter TANK_HITBOX =9,  
    parameter WHITE = 16'hFFFF,
    parameter BLACK = 16'h0,
    parameter COLOUR_RED = 16'hF800,
    parameter COLOUR_GREEN = 16'h07E0,
    parameter COLOUR_BLUE = 16'h001F,
    parameter COLOUR_ORANGE = 16'hFBE0,
    parameter MAX_PROJECTILES = 3,
    parameter RIGHT = 4'b0001,
    parameter LEFT = 4'b0010,
    parameter UP  = 4'b1000,
    parameter DOWN = 4'b0100
    )
    (
    input CLOCK, 
    input slow_clk_20hz,
    input [31:0]tank_ptr,  // x and y are both 8-bit values tank
    input [3:0] dir, 
    input switch,
    input switch1,
    input shoot, 
    input [2:0] hit_wall,
    input [2:0] hit_tank,
    output reg [2:0] led = 0,
    output reg [23:0] xpos_bus = 0,  // bus for projectile x positions (8 bits per projectile)
    output reg [23:0] ypos_bus = 0   // bus for projectile y positions (8 bits per projectile)
    
);
//reg [3:0]dir = 4'b1000;
wire [7:0]x;
wire [7:0]y;
assign x = tank_ptr%MAP_ROW_SIZE + TANK_HITBOX/2;  //tank_x coordinate in relation to MAP
assign y = tank_ptr/MAP_ROW_SIZE + TANK_HITBOX/2;  //tank_y coordinate in relation to MAP
  // Allow up to 5 active projectiles at once
//custom_clock u1 (.clk(CLOCK), .cycle_delay(2499999), .clock_signal(slow_clk_20hz));


reg [7:0] nextx [0:MAX_PROJECTILES-1];  // each projectile's next x-position (8 bits)
reg [7:0] nexty [0:MAX_PROJECTILES-1];  // each projectile's next y-position (8 bits)
reg [3:0] shootdir [0:MAX_PROJECTILES-1];  // direction for each projectile
reg active = 0;  // active status for each projectile (1 bit)
reg active1 = 0;
reg active2 = 0;
integer i;

initial begin
shootdir[0] = 3'b0;
shootdir[1] = 3'b0;
shootdir[2] = 3'b0; //increase to 3 proj
nextx[0] = 8'b0;
nextx[1] = 8'b0;
nextx[2] = 8'b0;
nexty[0] = 8'b0;
nexty[1] = 8'b0;
nexty[2] = 8'b0;
end
reg [1:0] fire_counter = 0;
reg shoot_prev = 0;
wire shoot_edge = (shoot && !shoot_prev);
always @ (posedge slow_clk_20hz)
begin
    shoot_prev <= shoot;
    
    if (shoot_edge) begin
        if (switch) begin
        begin
        fire_counter <= 2'b10;
        end
        // Handle firing of projectiles individually
        case (fire_counter)
            2'b00: begin
            if (!active) 
                begin
                xpos_bus[7:0] <= x;
                ypos_bus[7:0] <= y;
                nextx[0] <= x;
                nexty[0] <= y;
                shootdir[0] = dir;
                active <= 1;
                fire_counter <= 2'b01;
                end 
                end
            2'b01: begin
            if (!active1) 
                begin
                xpos_bus[15:8] <= x;
                ypos_bus[15:8] <= y;
                nextx[1] <= x;
                nexty[1] <= y;
                shootdir[1] = dir;
                active1 <= 1;
                fire_counter <= 2'b10;
                end
                end
            2'b10:begin
            if (!active2)
                begin
                xpos_bus[23:16] <= x;
                ypos_bus[23:16] <= y;
                nextx[2] <= x;
                nexty[2] <= y;
                shootdir[2] = dir;
                active2 <= 1;
                fire_counter <= 2'b00;
                end
            end
       endcase
       end
       else begin
       case (fire_counter)
            2'b00: begin
            if (!active) begin
            xpos_bus[7:0] <= x;
            ypos_bus[7:0] <= y;
            nextx[0] <= x;
            nexty[0] <= y;
            shootdir[0] = dir;
            active <= 1;
            fire_counter <= 2'b01;
            end
            end
            2'b01: begin
            if (!active1) begin
            xpos_bus[15:8] <= x;
            ypos_bus[15:8] <= y;
            nextx[1] <= x;
            nexty[1] <= y;
            shootdir[1] = dir;
            active1 <= 1;
            fire_counter <= 2'b00;
            end
            end
            2'b10,2'b11:begin
                fire_counter <= 2'b00;
            end
            endcase
       end
    end
    else begin
        // Move each active projectile
            if (active) begin
                if (hit_wall[0] || hit_tank[0]) begin
                    active <= 0;  // Deactivate on hit
                    led[0] <= 0;
                end else 
                    begin
                    xpos_bus[7:0] <= nextx[0];
                    ypos_bus[7:0] <= nexty[0];
                    if (switch1==0) begin
                    case (shootdir[0])
                        UP: nexty[0] <= nexty[0] - 1;
                        DOWN: nexty[0] <= nexty[0] + 1;
                        LEFT: nextx[0] <= nextx[0] - 1;
                        RIGHT: nextx[0] <= nextx[0] + 1;
                    endcase
                    end
                    else begin
                    case (dir)
                        UP: nexty[0] <= nexty[0] - 1;
                        DOWN: nexty[0] <= nexty[0] + 1;
                        LEFT: nextx[0] <= nextx[0] - 1;
                        RIGHT: nextx[0] <= nextx[0] + 1;
                    endcase
                    shootdir[0] <= dir;
                    end
                    led[0] <= 1;  // reset led
                    end
            end
            if (active1) begin
               if (hit_wall[1] || hit_tank[1]) begin
               active1 <= 0;  // Deactivate on hit
               led[1] <= 0;
               end else begin
                xpos_bus[15:8] <= nextx[1];
                ypos_bus[15:8] <= nexty[1];
               case (shootdir[1])
               UP: nexty[1] <= nexty[1] - 1;
               DOWN: nexty[1] <= nexty[1] + 1;
               LEFT: nextx[1] <= nextx[1] - 1;
               RIGHT: nextx[1] <= nextx[1] + 1;
               endcase
               led[1] <= 1;  // reset led
               end
            end
            if (active2) begin
              if (hit_wall[2] || hit_tank[2]) begin
                active2 <= 0;  // Deactivate on hit
                led[2] <= 0;
              end else begin
              xpos_bus[23:16] <= nextx[2];
              ypos_bus[23:16] <= nexty[2];
              case (shootdir[2])
              UP: nexty[2] <= nexty[2] - 1;
              DOWN: nexty[2] <= nexty[2] + 1;
              LEFT: nextx[2] <= nextx[2] - 1;
              RIGHT: nextx[2] <= nextx[2] + 1;
              endcase
              led[2] <= 1;  // reset led
              end
         end
    end
//    xpos_bus = {xpos[1],xpos[0]};
//    ypos_bus = {ypos[1],ypos[0]}; cannot doesnt work
end
endmodule