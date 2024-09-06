`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 14:27:09
// Design Name: 
// Module Name: TestSRAM
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


module TestSRAM;

    reg  [17:0] sram_address;
    wire [7:0]  sram_data;
    reg         sram_ce_n;
    reg         sram_oe_n;
    reg         sram_we_n;

    reg  [7:0]  data_in;
    wire [7:0]  data_out;

    // SRAM 实例化
    SRAM uut (
        .sram_address(sram_address),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n)
    );

    // 数据总线双向连接
    assign sram_data = (sram_we_n == 1'b0) ? data_in : 8'bz;
    assign data_out = sram_data;

    initial begin
        // 初始化信号
        sram_ce_n = 1'b1;
        sram_oe_n = 1'b1;
        sram_we_n = 1'b1;
        sram_address = 18'b0;
        data_in = 8'b0;

        // 等待 10 个时间单位
        #10;

        // 使能 SRAM
        sram_ce_n = 1'b0;

        // **写操作**：向地址 0x0 写入 0xAA
        sram_address = 18'h00000;
        data_in = 8'hAA;
        sram_we_n = 1'b0;  // 写使能有效
        sram_oe_n = 1'b1;  // 输出使能无效
        #10;
        sram_we_n = 1'b1;  // 写使能无效

        // **写操作**：向地址 0x1 写入 0x55
        sram_address = 18'h00001;
        data_in = 8'h55;
        sram_we_n = 1'b0;
        sram_oe_n = 1'b1;
        #10;
        sram_we_n = 1'b1;

        // **读操作**：从地址 0x0 读取数据
        sram_address = 18'h00000;
        sram_oe_n = 1'b0;  // 输出使能有效
        sram_we_n = 1'b1;  // 写使能无效
        #10;
        $display("Read data from address 0x0: 0x%h", data_out);
        sram_oe_n = 1'b1;  // 输出使能无效

        // **读操作**：从地址 0x1 读取数据
        sram_address = 18'h00001;
        sram_oe_n = 1'b0;
        sram_we_n = 1'b1;
        #10;
        $display("Read data from address 0x1: 0x%h", data_out);
        sram_oe_n = 1'b1;

        // 禁用 SRAM
        sram_ce_n = 1'b1;

        // 结束仿真
        #10;
        $finish;
    end

endmodule


