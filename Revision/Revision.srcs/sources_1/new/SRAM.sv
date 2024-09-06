`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 10:40:56
// Design Name: 
// Module Name: SRAM
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


module SRAM(
    input  wire [17:0] sram_address,
    inout  wire [7:0]  sram_data,
    input  wire        sram_ce_n,  // Chip enable (active high)
    input  wire        sram_oe_n,  // Output enable (active high)
    input  wire        sram_we_n   // Write enable (active high), when 
    );

    // 定义 16 个 8 位的存储单元
    reg [7:0] store [16];
    
    initial begin
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            store[i] = 8'b0;
        end
    end

    // 数据总线输出控制
    assign sram_data = (sram_ce_n == 1'b0 && sram_oe_n == 1'b0 && sram_we_n == 1'b1) ? store[sram_address[3:0]] : 8'bz;

    // 写操作
    always_comb begin
        if (sram_ce_n == 1'b0 && sram_we_n == 1'b0) begin
            store[sram_address[3:0]] = sram_data;
        end
    end
endmodule

