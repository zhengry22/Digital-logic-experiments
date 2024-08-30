`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 21:35:24
// Design Name: 
// Module Name: TestDivider
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


module TestDivider;
reg clk = 0;
reg [4:0] div = 4;
reg div_clk;

integer i;
integer mult = 1 << div;
initial begin
    /* In order to test the divider's ability to adjust its cycle, we may alter div */
    for (i = 0; i < mult; i = (i + 1) % mult) begin
        # 500;
        clk = ~clk;
        if (i == 0) begin
            div_clk = ~div_clk;
        end
        else begin
            div_clk = div_clk;
        end
    end
end

Divider dv(
    .clk(clk),
    .div(div),
    .div_clk(div_clk)
);
endmodule
