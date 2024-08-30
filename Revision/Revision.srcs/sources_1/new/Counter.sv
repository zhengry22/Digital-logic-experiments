`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 20:21:22
// Design Name: 
// Module Name: Counter
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


module Counter(
    input wire clk,
    input wire switch,
    input wire rst,
    output reg [3:0] low,
    output reg [3:0] high
    );
    
    always_ff @ (posedge clk, negedge rst) begin 
        /* The counter adopts asynchronized reset */
        if (rst == 0) begin
            low <= 0;
            high <= 0;
        end
        else begin
            if (switch == 1) begin
                if (low == 9) begin
                    // High should +1 or turn from 5 to 0
                    high <= (high + 1) % 6;
                end
                else begin
                    // High stays the same 
                    high <= high;
                end
                low <= (low + 1) % 10;
                end
            else begin
                low <= low;
                high <= high;
            end
        end
    end
endmodule
