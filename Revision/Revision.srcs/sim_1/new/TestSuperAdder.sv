`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 15:08:55
// Design Name: 
// Module Name: TestSuperAdder
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


module TestSuperAdder;
/* 
    The input of a super adder includes: number A, number B, carry;
    While the output contains a carry sign and the 4 bit result.
    We will link the result to a decoder that receives 4 bits in order to create the visual effect.
*/

    reg [3:0] A;
    reg [3:0] B;
    reg carry;
    wire [3:0] midresult;
    wire nextcarry;
    wire [6:0] out;
    integer i, j, k; // Used for the loop of A, B and carry respectively
    
initial begin
/* To fully test our program, we need to go through all the possible inputs */
        for (i = 0; i < 16; i = (i + 1) % 16) begin
            for (j = 0; j < 16; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    A = i;
                    B = j;
                    carry = k;
                    # 500;
                end
            end 
        end     
end

SuperAdder sa(
    .A(A),
    .B(B),
    .carry(carry),
    .result(midresult),
    .nextcarry(nextcarry)
);

Decoder1 d(
    .a(midresult),
    .lights(out)
);

endmodule
