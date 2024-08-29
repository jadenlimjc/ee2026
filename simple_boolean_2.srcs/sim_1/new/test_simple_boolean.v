`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2024 02:16:49 PM
// Design Name: 
// Module Name: my_control_module_simulation
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


module my_control_module_simulation(

    );
    // simulation outputs
    reg A;
    reg B;
    
    //instantiation of modulet o be simulated
    wire LED1;
    wire LED2;
    wire LED3;
    
    //instantiation of module to be simulated
    my_control_module dut(A, B, LED1, LED2, LED3);
    
    //stimuli
    initial begin
        A = 0; B = 0;
        A = 0; B = 1;
        A = 1; B = 0;
        A = 1; B = 1;
    end
    
endmodule
