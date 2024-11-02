`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2024 09:41:29
// Design Name: 
// Module Name: move_frame
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


module move_frame
    #(
    parameter MAP_ROW_SIZE =200,
    parameter MAP_HEIGHT_SIZE =200,
    parameter SCREEN_Y = 64,
    parameter SCREEN_X = 96
    )
  

  
  (
    input clksig,
    input [3:0] dir,
    input [31:0] tank_ptr,next_tank_ptr,
        
    input frame_move_request,    // Output to request frame movement
    output reg frame_moved_done = 0,           // Input from task_d to confirm the frame has moved

    output reg [31:0] frame_ptr
 

    
);
   


   

//   assign pixel_x = pixel_index%96;
//   assign pixel_y = pixel_index/96;

   reg [7:0] frameptr_x = 30;
   reg  [7:0] frameptr_y = 40;
    reg frame_move_pending = 0  ;


      always @ (posedge clksig)
      begin 

              
               if (dir == 4'b0010 && frameptr_x >0) // left
                   begin
                   frameptr_x <= frameptr_x -1;
                   end             
               else if (dir == 4'b0001 && frameptr_x < MAP_ROW_SIZE - SCREEN_X) // right
                   begin
                   frameptr_x <= frameptr_x +1;
                   
                   end
               else if (dir == 4'b1000 && frameptr_y > 0) // up
                   begin
                   frameptr_y <= frameptr_y -1;
                   end    
               else if (dir == 4'b0100 && frameptr_y < MAP_HEIGHT_SIZE - SCREEN_Y ) // down
                   
                   begin
                   frameptr_y <= frameptr_y +1;
                   
                   end    
                   
               frame_ptr =  frameptr_y*MAP_ROW_SIZE +frameptr_x;
                   

              end
              
        
          
          

  endmodule


       
