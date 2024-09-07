`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 16:53:23
// Design Name: 
// Module Name: TestSRAMRW
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


`timescale 1ns/1ps

module TestSRAMRW;

    // Signals for SRAMRW module
    reg clk;
    reg rst;
    reg rw; // 0 for write, 1 for read
    reg [3:0] address;
    
    // SRAM signals
    wire [17:0] sram_address;
    wire [7:0] sram_data;
    wire sram_ce_n;
    wire sram_oe_n;
    wire sram_we_n;
    
    // Outputs from SRAMRW
    wire [7:0] out_data;
    wire [1:0] state_light;
    
    // SRAM module instance
    SRAM sram (
        .sram_address(sram_address),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n)
    );
    
    // SRAMRW module instance
    SRAMRW sramrw (
        .clk(clk),
        .rst(rst),
        .rw(rw),
        .address(address),
        .sram_address(sram_address),
        .sram_data(sram_data),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n),
        .out_data(out_data),
        .state_light(state_light)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #500 clk = ~clk; // Clock period of 10ns
    end
    
    // Test procedure
    initial begin
        // Initialize
        rst = 1;
        rw = 0;
        address = 0;
        
        #1000;
        rst = 0;
        
        // Read data from each address
        for (int i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            address = i;
            rw = 1; // Read mode
            #3000;
            rst = 1;
            # 1000;
            rst = 0;
            $display("Read data at address %0d: %0d", i, out_data);
        end
        
        // Write data to each address
        for (int i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            address = i;
            rw = 0; // Write mode
            #3000;
            rst = 1;
            # 1000;
            rst = 0;
        end
        
        // Read data from each address
        for (int i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            address = i;
            rw = 1; // Read mode
            #3000;
            rst = 1;
            # 1000;
            rst = 0;
            $display("Read data at address %0d: %0d", i, out_data);
        end

        // Finish simulation
        $stop;
    end
endmodule

