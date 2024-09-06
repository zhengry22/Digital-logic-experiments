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

    // SRAM ʵ����
    SRAM uut (
        .sram_address(sram_address),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n)
    );

    // ��������˫������
    assign sram_data = (sram_we_n == 1'b0) ? data_in : 8'bz;
    assign data_out = sram_data;

    initial begin
        // ��ʼ���ź�
        sram_ce_n = 1'b1;
        sram_oe_n = 1'b1;
        sram_we_n = 1'b1;
        sram_address = 18'b0;
        data_in = 8'b0;

        // �ȴ� 10 ��ʱ�䵥λ
        #10;

        // ʹ�� SRAM
        sram_ce_n = 1'b0;

        // **д����**�����ַ 0x0 д�� 0xAA
        sram_address = 18'h00000;
        data_in = 8'hAA;
        sram_we_n = 1'b0;  // дʹ����Ч
        sram_oe_n = 1'b1;  // ���ʹ����Ч
        #10;
        sram_we_n = 1'b1;  // дʹ����Ч

        // **д����**�����ַ 0x1 д�� 0x55
        sram_address = 18'h00001;
        data_in = 8'h55;
        sram_we_n = 1'b0;
        sram_oe_n = 1'b1;
        #10;
        sram_we_n = 1'b1;

        // **������**���ӵ�ַ 0x0 ��ȡ����
        sram_address = 18'h00000;
        sram_oe_n = 1'b0;  // ���ʹ����Ч
        sram_we_n = 1'b1;  // дʹ����Ч
        #10;
        $display("Read data from address 0x0: 0x%h", data_out);
        sram_oe_n = 1'b1;  // ���ʹ����Ч

        // **������**���ӵ�ַ 0x1 ��ȡ����
        sram_address = 18'h00001;
        sram_oe_n = 1'b0;
        sram_we_n = 1'b1;
        #10;
        $display("Read data from address 0x1: 0x%h", data_out);
        sram_oe_n = 1'b1;

        // ���� SRAM
        sram_ce_n = 1'b1;

        // ��������
        #10;
        $finish;
    end

endmodule


