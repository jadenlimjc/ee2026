`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2024 01:59:38 PM
// Design Name: 
// Module Name: test_adder_simulation
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


module test_adder_simulation(

    );
    
    //Simulation Inputs
    reg [5:0]A, B;
    reg btnL;
    
    //Simulation Outputs
    wire [5:0] S;
    wire [1:0] T;
    wire [3:0] an;
    wire [6:0] seg;
    
    //Instantiate module to be simulated
    
    gradedlab2_adder dut(A, B, btnL, S, T, an, seg);
    
    //Stimuli
    
    initial begin
        A = 6'b100111; B = 6'b010101; btnL = 1'b0; #100;
        A = 6'b111111; B = 6'b111111; btnL = 1'b0; #100;
        A = 6'b011001; B = 6'b000111; btnL = 1'b0; #100;
        A = 6'b100111; B = 6'b010101; btnL = 1'b1; #100;
        A = 6'b111111; B = 6'b111111; btnL = 1'b1; #100;
        A = 6'b011001; B = 6'b000111; btnL = 1'b1; #100;
    end
    
endmodule
