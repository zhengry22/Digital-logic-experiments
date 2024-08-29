`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 14:23:23
// Design Name: 
// Module Name: SuperAdder
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

/* This module is a Super Adder for 4 bit numbers */
module SuperAdder(
        input wire [3:0] A,
        input wire [3:0] B,
        input wire carry,
        output wire [3:0] result
    );
    
    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;
    genvar i;
    /* Using the keyword generate and a for loop to assign values to G and P */
    generate 
        for (i = 0; i < 4; i = i + 1) begin: genetate_G_P
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate
    
    assign C[0] = G[0] | (P[0] & carry);
    assign C[1] = G[1] | (P[1] & G[0]) | (P[2] & P[1] & carry);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0])
     | (P[2] & P[1] & P[0] & carry);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) |
    (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry);
    
    genvar j;
    generate 
        for (j = 0; j < 4; j = j + 1) begin: sum
            
        end
    endgenerate
    
    
endmodule
