`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2024 15:18:12
// Design Name: 
// Module Name: game_timer
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


module game_timer(
    input clk,
    input clk1hz,
    input clk10hz,
    input reset,
    input start,
    input pause,
    output reg [6:0] seg,
    output reg [3:0] an

    );
    
    
    reg [3:0] ones, tens, hundreds;
    
    reg [1:0] current_digit;
    reg [16:0] digit_timer;

    localparam [6:0] ZERO = 7'b1000000,
                      ONE = 7'b1111001,
                      TWO = 7'b0100100,
                      THREE = 7'b0110000,
                      FOUR = 7'b0011001,
                      FIVE = 7'b0010010,
                      SIX = 7'b0000010,
                      SEVEN = 7'b1111000,
                      EIGHT = 7'b0000000,
                      NINE = 7'b0010000;
                      
    initial begin
        ones = 0;
        tens = 0;
        hundreds = 3;
    end
    always @(posedge clk10hz or posedge reset) begin
        if (reset) begin
            current_digit <= 0;
        end else begin
            current_digit <= current_digit + 1;
            if (current_digit == 2) begin
                current_digit <= 0;
            end
        end
    end
    
    always @(posedge clk1hz or posedge reset) begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 3;
        end else if (start && !pause) begin
            if (ones == 0) begin
                if (tens == 0) begin
                    if (hundreds > 0) begin
                        ones <= 9;
                        tens <= 5;
                        hundreds <= hundreds - 1;
                    end
                end else begin
                    tens <= tens - 1;
                    ones <= 9;
                end
            end else begin
                ones <= ones - 1;
            end
        end
    end
                        
    always @(current_digit) begin
        case (current_digit)
            2'b00 : an = 4'b1110;
            2'b01 : an = 4'b1101;
            2'b10 : an = 4'b1011;
        endcase
    end
       
    always @(*) begin
        case (current_digit)
            2'b00 : begin       // ONES DIGIT
                case(ones)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
                    
            2'b01 : begin       // TENS DIGIT
                case(tens)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
                    
            2'b10 : begin       // HUNDREDS DIGIT
                case(hundreds)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                endcase
            end
        endcase
    end
                            
                    
            
endmodule
