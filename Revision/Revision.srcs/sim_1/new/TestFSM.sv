`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 21:34:58
// Design Name: 
// Module Name: TestFSM
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


module TestFSM;

reg clk = 0;
reg clr;
reg in = 1;
reg [1:0] state = 2'b00;
reg exor;

/* CLK */
initial begin
    forever begin
        clk = ~clk;
        # 500;
    end
end

/* CLR */
initial begin
    clr = 1;
    # 1000;
    clr = 0;
end

/* in */
initial begin
    forever begin
        # 4200;
        in = ~in;
    end
end

FSM fsm(
    .clk(clk),
    .clr(clr),
    .in(in),
    .state(state),
    .exor(exor)
);
endmodule
