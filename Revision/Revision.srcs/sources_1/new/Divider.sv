`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 21:08:02
// Design Name: 
// Module Name: Divider
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


module Divider(
    input wire clk,
    input reg [4:0] div, // The cycle will be 2^div times than the original cycle
    output reg div_clk = 0
    );
    integer i = 0;
    const integer mult = 1 << div;
    always_ff @ (posedge clk) begin
        if (i == 0) begin
            /* When i == 0, change the signal of div_clk*/
            div_clk = ~div_clk;
            i = (i + 1) % mult;
        end
        else begin
            div_clk = div_clk;
            i = (i + 1) % mult;
        end
    end
endmodule
