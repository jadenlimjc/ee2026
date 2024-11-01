`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 23:43:39
// Design Name: 
// Module Name: get_winner
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


module get_winner(
    input clk,
    input [5:0] player1_state, player2_state, player3_state, player4_state,
    input game_end,
    output reg [1:0] winner,
    output reg early_end
    );
    
    localparam [1:0] ONE = 2'b00,
                    TWO = 2'b01,
                    THREE = 2'b10,
                    FOUR = 2'b11;
    reg [1:0] max_lives;                
    always @ (*) begin
        early_end = 0;
        if (game_end) begin
        //compare [3:2] of each player_state, whichever player has highest lives wins  
            max_lives = player1_state[3:2];
            winner = ONE;
            
            // Compare player 2's lives with current max
            if (player2_state[3:2] > max_lives) begin
                max_lives = player2_state[3:2];
                winner = TWO;
            end
            
            // Compare player 3's lives with current max
            if (player3_state[3:2] > max_lives) begin
                max_lives = player3_state[3:2];
                winner = THREE;
            end
            
            // Compare player 4's lives with current max
            if (player4_state[3:2] > max_lives) begin
                max_lives = player4_state[3:2];
                winner = FOUR;
            end  
        end
        else begin
        //scenario where only one player still has more than zero lives
            if (player1_state[3:2] > 2'b00 && player2_state[3:2] == 2'b00 && player3_state[3:2] == 2'b00 && player4_state[3:2] == 2'b00) begin
                winner = ONE;
                early_end = 1;
            end
            else if (player2_state[3:2] > 2'b00 && player1_state[3:2] == 2'b00 && player3_state[3:2] == 2'b00 && player4_state[3:2] == 2'b00) begin
                winner = TWO;
                early_end = 1;
            end
            else if (player3_state[3:2] > 2'b00 && player1_state[3:2] == 2'b00 && player2_state[3:2] == 2'b00 && player4_state[3:2] == 2'b00) begin
                winner = THREE;
                early_end = 1;
            end
            else if (player4_state[3:2] > 2'b00 && player1_state[3:2] == 2'b00 && player2_state[3:2] == 2'b00 && player3_state[3:2] == 2'b00) begin
                winner = FOUR;
                early_end = 1;
            end
            else
                winner = ONE;
                early_end = 0;
        end
    end
endmodule
