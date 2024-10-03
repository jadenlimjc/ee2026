`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk, btnC, sw4,
    output cs, sdin, sclk, d_cn, resn, vccen, pmoden,
    inout ps2_clk, ps2_data,
    output [15:0] led,
    output [6:0] seg
);

    
    wire [12:0] pixel_index;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [15:0] oled_data;
    wire reset;
    wire enable;
    wire clk6p25m;
    wire clk25m;
    wire clk12p5m;
    wire clk1hz;
    
    // Instantiate the MouseCtl module
    wire [11:0] xpos, ypos;   // Mouse X and Y position
    wire [3:0] zpos;          // Mouse Z position (scroll wheel)
    wire left, middle, right; // Mouse button signals
    wire new_event;           // Mouse event signal
    
    flexible_clock clk6p25 (clk, 31'd7, clk6p25m);
    flexible_clock clk25 (clk, 31'd1, clk25m);
    flexible_clock clk12p5 (clk, 31'd3, clk12p5m);
    flexible_clock clk1 (clk, 31'd50000000, clk1hz);
    
    MouseCtl mouse (clk, reset, xpos, ypos, zpos, left, middle, right,
            new_event, 12'd0, 1'b0, 1'b0, 1'b0, 1'b0, ps2_clk, ps2_data);
            
    assign reset = right;
    assign enable = 1;
    
    paint painter (clk, clk25m, clk12p5m, clk6p25m, clk1hz,
        left, reset, enable, xpos, ypos, pixel_index,
        led, seg, oled_data);
        
    
    Oled_Display OLED (clk6p25m, reset, frame_begin, sending_pixels,
      sample_pixel, pixel_index, oled_data, cs, sdin, sclk, d_cn, resn, vccen,
      pmoden);
    
    


endmodule
