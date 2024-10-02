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
    input clk, reset, btnC, sw4, [7:0] JA,
    output frame_begin, sending_pixels, sample_pixel,
    inout ps2_clk, ps2_data,
    input [15:0] pixel_data,
    output cs, sdin, sclk, d_cn, resn, vccen, pmoden, [1:0] pixel_index,
    output [15:0] oled_data,
    output [15:0] led
);

    
    // Clock divider for 6.25 MHz
    reg [3:0] clk_divider = 0; // 4-bit counter for dividing 100 MHz to 6.25 MHz
    wire clk6p25m;
    
    // Instantiate the MouseCtl module
    wire [11:0] xpos, ypos;   // Mouse X and Y position
    wire [3:0] zpos;          // Mouse Z position (scroll wheel)
    wire left, middle, right; // Mouse button signals
    wire new_event;           // Mouse event signal
    
    MouseCtl mouse (clk, reset, xpos, ypos, zpos, left, middle, right,
        new_event, 12'd0, 1'b0, 1'b0, 1'b0, 1'b0, ps2_clk, ps2_data);
        
     assign led[15] = left;
     assign led[14] = middle;
     assign led[13] = right;
    
    // Instantiate 6.25MHz clk
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_divider <= 0;
        else
            clk_divider <= clk_divider + 1;
    end
    
    reg [15:0] bg_colour;
    always @(posedge clk) begin
        if (sw4)
            bg_colour <= 16'hF800;
        else
            bg_colour <= 16'h07E0;
    end
    assign oled_data = bg_colour;
    
    Oled_Display OLED (clk6p25m, reset, frame_begin, sending_pixels,
      sample_pixel, pixel_index, oled_data, cs, sdin, sclk, d_cn, resn, vccen,
      pmoden);
    
    


endmodule