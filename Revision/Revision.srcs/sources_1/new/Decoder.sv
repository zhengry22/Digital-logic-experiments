`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 11:01:53
// Design Name: 
// Module Name: Decoder
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


module Decoder1 (
        input wire [3:0] a,
        output wire [6:0] lights
    );
    
    logic [15:0] eq;
    integer i;
    
    always_comb begin
        for (i = 0; i < 16; i = i + 1) begin
            eq[i] = (i == a);
        end
    end
    
    assign lights[0] = (eq[0] || eq[2] || eq[3] || eq[5] || eq[6] || eq[7] || eq[8] || eq[9] || eq[10] || eq[12] || eq[14] || eq[15]); // lights[0]: 2, 3, 5, 6, 7, 8, 9, A, C, E, F
    assign lights[1] = (eq[0] || eq[1] || eq[2] || eq[3] || eq[4] || eq[7] || eq[8] || eq[9] || eq[10] || eq[13]); // lights[1]: 0, 1, 2, 3, 4, 7, 8, 9, A, D
    assign lights[2] = (eq[0] || eq[1] || eq[3] || eq[4] || eq[5] || eq[6] || eq[7] || eq[8] || eq[9] || eq[10] || eq[11] || eq[13]); // lights[2]: 0, 1, 3, 4, 5, 6, 7, 8, 9, A, B, D
    assign lights[3] = (eq[0] || eq[2] || eq[3] || eq[5] || eq[6] || eq[8] || eq[9] || eq[11] || eq[12] || eq[13] || eq[14]); // lights[3]: 0, 2, 3, 5, 6, 8, 9, B, C, D, E
    assign lights[4] = (eq[0] || eq[2] || eq[6] || eq[8] || eq[10] || eq[11] || eq[12] || eq[13] || eq[14] || eq[15]); // lights[4]: 0, 2, 6, 8, A, B, C, D, E, F 
    assign lights[5] = (eq[0] || eq[4] || eq[5] || eq[6] || eq[8] || eq[9] || eq[10] || eq[11] || eq[12] || eq[14] || eq[15]); // lights[5]: 0, 4, 5, 6, 8, 9, A, B, C, E, F
    assign lights[6] = (eq[2] || eq[3] || eq[4] || eq[5] || eq[6] || eq[8] || eq[9] || eq[10] || eq[11] || eq[13] || eq[14] || eq[15]); // lights[6]: 2, 3, 4, 5, 6, 8, 9, A, B, D, E, F    

endmodule
