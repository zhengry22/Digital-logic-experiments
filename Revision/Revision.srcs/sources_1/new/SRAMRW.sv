`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 14:15:43
// Design Name: 
// Module Name: SRAMRW
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


module SRAMRW(
    // Input
    input wire clk,
    input wire rst,
    input wire rw, // 0 for write, 1 for read
    input reg [3:0] address,
    
    // Output to SRAM
    output reg [17:0] sram_address,
    inout reg [7:0] sram_data,
    output reg sram_ce_n,
    output reg sram_oe_n,
    output reg sram_we_n,
    
    // Output to environment
    output reg [7:0] out_data,
    output reg [1:0] state_light
    );
    
    typedef enum {STATE_0, STATE_1, STATE_2, STATE_3} states;
    states state, next_state;
    reg [7:0] mid;
    
    assign sram_data = (sram_ce_n == 1'b0 && sram_oe_n == 1'b0 && sram_we_n == 1'b1) ? 8'bz : mid;

// Handling the inputs in each state (but why not use comb?)
    always_ff @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= STATE_0;
            sram_address <= 18'b0;
            mid <= 8'b0;
            sram_ce_n <= 0;
            sram_oe_n <= 0;
            sram_we_n <= 1;
        end
        else begin
            case (state)
                STATE_0: begin
                    if (rw == 1) begin
                        sram_address[3:0] <= address;
                        sram_we_n <= 1;
                    end
                    else begin
                        sram_address[3:0] <= address;
                        mid[3:0] <= address + 1;
                        sram_we_n <= 1;
                    end
                end
                STATE_1: begin
                    if (rw == 1) begin
                        sram_we_n <= 1;
                    end
                    else begin
                        sram_we_n <= 0;
                    end
                end
                STATE_2: sram_we_n <= 1;
                STATE_3:;
            endcase
            state <= next_state;
        end
    end

// Handling the shifts
    always_comb begin
        case (state)
            STATE_0: next_state = STATE_1;
            STATE_1: next_state = STATE_2;
            STATE_2: next_state = STATE_3;
            STATE_3: next_state = STATE_3;
        endcase
    end

// Handling output
    always_comb begin
        if (rw == 1 && state == STATE_3) begin
            out_data = sram_data;
        end
        else begin
            out_data = 7'b0;
        end
    end
    
    always_comb begin
        case(state)
            STATE_0: state_light = 2'b00;
            STATE_1: state_light = 2'b01;
            STATE_2: state_light = 2'b10;
            STATE_3: state_light = 2'b11;
            default: state_light = 2'b00;
        endcase
    end
endmodule
