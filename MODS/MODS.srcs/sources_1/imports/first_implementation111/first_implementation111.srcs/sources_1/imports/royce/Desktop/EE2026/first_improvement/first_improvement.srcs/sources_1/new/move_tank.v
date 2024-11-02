`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 17:58:32
// Design Name: 
// Module Name: move_tank
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


module move_tank#(
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96,
    parameter MAP_ROW_SIZE = 200,
    
    parameter MAP_HEIGHT_SIZE =200,
    parameter BORDER =2, 
    parameter WHITE = 16'hFFFF,
    parameter BLACK = 16'h0,
    parameter COLOUR_RED = 16'hF800,
    parameter COLOUR_GREEN = 16'h07E0,
    parameter COLOUR_BLUE = 16'h001F,
    parameter COLOUR_ORANGE = 16'hFBE0
    )
    (input clksig,
        input [4:0] btn,
        input [31:0] frame_ptr,
        input collisions,
        output reg [3:0]dir,
        output reg [3:0] frame_dir,
        output reg [31:0] tank_ptr,
        output reg [31:0] next_tank_ptr

    );
//    reg [3:0] dir;
    wire [7:0] frameptr_x;
    wire  [7:0] frameptr_y;
    reg [7:0] tank_x;
    reg [7:0] tank_y;
    reg [7:0] next_tank_x;
    reg [7:0] next_tank_y;
    assign frameptr_x = frame_ptr%MAP_ROW_SIZE;
    assign frameptr_y = frame_ptr/MAP_ROW_SIZE;
    reg updated =0;
    
    reg [2:0] count = 0;
    always @ (posedge clksig  )
          begin
          //------------------------------------INITIALISE-------------------------//
            if (count != 7) begin
                    next_tank_x <= SCREEN_X/2 + frameptr_x;
                    next_tank_y <= SCREEN_Y/2 + frameptr_y;
                    next_tank_ptr = next_tank_y*MAP_ROW_SIZE +next_tank_x;
                   frame_dir <= 4'b0000;
                    
                    tank_x <= next_tank_x;
                    tank_y <= next_tank_y;
                    tank_ptr <= next_tank_y*MAP_ROW_SIZE +next_tank_x;;

                    count <=count +1;
                end 
                //-----------------------------SET DIRECTION--------------------------------//
                else  begin
                if (btn[1] || btn[2] || btn[3] || btn[4])
                    dir <= {btn[1], btn[4], btn[2], btn[3]};
                else if (btn[0] )begin
//                    dir <= 4'd0;
//                    count <= count - 2;
                    end
                
                //-----------------------------CALCULATE NEXT_TANK--------------------------------//
                  case (dir)
                     4'b1000:
                     begin next_tank_y <= tank_y -1;// signal travel up _store next position in next_tank_ptr
                           next_tank_x <= tank_x;
                     end
                     4'b0100: 
                     begin next_tank_y <= tank_y +1;// signal travel down _store next position in next_tank_ptr
                           next_tank_x <= tank_x;
                     end
                     4'b0010: 
                     begin next_tank_x <= tank_x -1;// signal travel left _store next position in next_tank_ptr
                           next_tank_y <= tank_y;
                     end                        
                     4'b0001: 
                     begin next_tank_x <= tank_x +1;// signal travel right _store next position in next_tank_ptr
                           next_tank_y <= tank_y;
                     end
                     default:begin next_tank_x <= tank_x; // else stay
                                      next_tank_y <= tank_y;
                                      end
                   endcase
                   next_tank_ptr <= next_tank_y*MAP_ROW_SIZE +next_tank_x; // calculate next_tank_ptr
                   
                   //----------------------------CHECKS AND MOVE FRAME AND TANK----------------//
                   if (collisions != 1 )begin //check if next_tank pos has collisions
                   
                      if(tank_ptr != next_tank_ptr)begin // check if there is a need to move
                      tank_x <= next_tank_x;
                      tank_y <= next_tank_y;
                      tank_ptr <= next_tank_y *MAP_ROW_SIZE + next_tank_x; //update tank_ptr with next_tank_posotion  
                      updated <= 1;
                      
                      end
                        
                         if( updated)begin
                         if(dir == 4'b1000 && frameptr_y >= MAP_HEIGHT_SIZE - SCREEN_Y -1&& tank_y > SCREEN_Y/2 + frameptr_y)begin // if at btm wall and not centred   
                            frame_dir <= 4'b0000;
                            end                    
                         else if(dir == 4'b0100 && frameptr_y <= 1 && tank_y < SCREEN_Y/2 + frameptr_y)begin // if at top wall and not centred                                                
                              frame_dir <= 4'b0000; //lock frame
                              end                        
                         else if(dir == 4'b0010 &&  frameptr_x >= MAP_ROW_SIZE - SCREEN_X -1 && tank_x > SCREEN_X/2 + frameptr_x)begin // if at right wall and not centred
                              frame_dir <= 4'b0000; //lock frame
                             end 
                         else if( dir == 4'b0001 && frameptr_x <= 1 && tank_x  < SCREEN_X/2 + frameptr_x)begin // if at left wall and not centred 
                              frame_dir <= 4'b0000;                             
                             end
                         else frame_dir <=dir; // else signal frame to move as usual
                         updated <=0;

                         
                         end
                         else frame_dir <= 4'b0000;
                         end

                        else frame_dir <= 4'b0000; //if collision stop frame, reset direction 

                 end 
                          
           end

endmodule
