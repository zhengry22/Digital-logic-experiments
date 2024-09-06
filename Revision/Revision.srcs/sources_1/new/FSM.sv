`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 21:26:00
// Design Name: 
// Module Name: FSM
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


module FSM(
    input wire clk,
    input wire clr,
    input wire in,
    output reg [1:0] state,
    output reg exor
);
    parameter S0=2'b00,S1=2'b01,S2=2'b11,S3=2'b10;
    reg [2:0] next_state;
    always_ff @(posedge clk, posedge clr) begin
        if(clr) 
            state<=S0;
        else
            state<=next_state;
    end
    
    always_comb begin
            case(state)
                2'b00: begin
                    if (in == 1) next_state = 2'b01;
                    else next_state = 2'b11;
                end
                2'b01: begin
                    if (in == 1) next_state = 2'b10;
                    else next_state = 2'b00;
                end
                2'b10: begin 
                    if (in == 1) next_state = 2'b11;
                    else next_state = 2'b01;
                end
                2'b11: begin
                    if (in == 1) next_state = 2'b00;
                    else next_state = 2'b10;
                end
            endcase
    end
    
    always_comb begin
        if (in == 1) exor = state[1] ^ state[0];
        else exor = !(state[1] ^ state[0]);
    end
endmodule
