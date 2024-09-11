`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2024 22:03:02
// Design Name: 
// Module Name: blinky
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

//module to handle loading sequence at the start of the program
module led_start (
    input wire CLOCK_100MHZ,
    input wire [31:0] TIME_COUNT,
    output reg [6:0] LEDS,
    output reg leds_on
);
    reg [31:0] clock_divider; //register to count up to 100 mill clk cycles
    reg [2:0] count; //counter to track which led to turn on
    
    always @(posedge CLOCK_100MHZ) begin
        if (clock_divider >= 86000000) begin // when 86 million clock cycles are reached (0.86 seconds)
            clock_divider <= 0;
            if (count < 7) begin
                LEDS[count] = 1'b1;
                count <= count + 1;
            end else if (LEDS == 7'b1111111) begin
                leds_on <= 1'b1; //bool to track that all leds are on
            end
        end else begin
            clock_divider <= clock_divider + 1;
        end
    end
    
    initial begin 
        LEDS = 7'b0000000;
        count = 0;
        leds_on = 1'b0;
    end
endmodule

// module to handle switches and LED blinking

module led_blinker (
    input wire CLOCK_100MHZ, 
    input wire [2:0] sw, 
    input wire LEDS_ON, //condition to check if all LEDs are on
    output reg [6:0] LEDS
);
    reg [25:0] blink_counter;
    reg blink_1hz, blink_10hz, blink_100hz;
    
    always @(posedge CLOCK_100MHZ) begin
        //Generate 3 blinking signals
        blink_counter <= blink_counter + 1;
        if (blink_counter >= 50000000) begin //1hz
            blink_1hz <= ~blink_1hz;
            blink_counter <= 0;
        end
        if (blink_counter % 5000000 == 0) blink_10hz <= ~blink_10hz;  // 10 Hz
        if (blink_counter % 500000 == 0) blink_100hz <= ~blink_100hz;  // 100 Hz
    end
    
    always @(posedge CLOCK_100MHZ) begin
        if (LEDS_ON == 1'b1) begin //check if all leds are on
            if (sw == 3'b000) begin
                LEDS <= 7'b1111111; // All LEDs ON
            end
            else if (sw[2] == 1'b1) begin
                LEDS <= {4'b1111, blink_100hz, 2'b11}; //dont cares for sw1 and sw0  if sw2 is on
            end
            else if (sw[1] == 1'b1) begin
                LEDS <= {5'b11111, blink_10hz, 1'b1}; //dont care for sw0
            end
            else if (sw[0] == 1'b1) begin
                LEDS <= {6'b111111, blink_1hz};
            end
        end 
    end
endmodule
                    
module blinky(
    input wire clk,
    input wire [2:0] sw,
    output wire [6:0] led

    );
    wire [6:0] led_start_out;
    wire [6:0] led_blink_out;
    wire leds_on;
    reg [31:0] TIME_COUNT = 31'd86000000;
    
    //instantiate start seq
    led_start start (clk,TIME_COUNT,led_start_out,leds_on);
    
    //instantiate led blinker
    led_blinker led_blink (clk,sw,leds_on,led_blink_out);
    
    assign led = leds_on ? led_blink_out : led_start_out;
    
    
endmodule
