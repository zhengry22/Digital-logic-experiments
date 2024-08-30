`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 20:30:20
// Design Name: 
// Module Name: TestCounter
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


module TestCounter;

reg clk = 1'b0;
reg switch = 1;
reg rst = 1;
reg [3:0] low;
reg [3:0] high;
integer i;
integer j = 175;
integer k = 210;
integer l = 0;
initial begin
    /* Test whether reset and the increment is suceessful */
    low = 0;
    high = 0;
    for (i = 0; i < 180; i = (i + 1) % 180) begin
        if ((l > k) && (l % k > 0) && (l % k < 35)) begin
            switch = 0;
        end
        else begin
            switch = 1;
        end
        clk = ~clk;
        #500;
        rst = 1;
        if ((i != 0) && (i % j == 0)) begin
            rst = 0;
            if (j < 60) begin
                j = 180;
            end
            else begin
                j = j - 1;
            end
        end
        else begin
            rst = rst;
        end
        l = (l + 1) % 1000;
    end
end

Counter cnt(
    .clk(clk),
    .switch(switch),
    .rst(rst),
    .low(low),
    .high(high)
);
endmodule
