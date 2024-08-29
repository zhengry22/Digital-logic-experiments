`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 12:14:16
// Design Name: 
// Module Name: tb
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


module DecoderSim;
integer i = 0;
reg [3:0] sw;
wire [6:0] out;

initial begin
    forever begin
        sw = i;
        #500;
        i = i + 1;
        if (i >= 16) i = i - 16;
    end
end

Decoder1 d(
    .a(sw),
    .lights(out)
);

endmodule
