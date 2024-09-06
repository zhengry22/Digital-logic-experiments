`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 08:48:48
// Design Name: 
// Module Name: PasswordLock
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


module PasswordLock(
    input wire CLK,
    input wire RST,
    input reg [3:0] Code, 
    input reg Mode, // 0 for set, 1 for verify 
    output reg Set,
    output reg Unlock,
    output reg Err,
    output reg Alarm // If wrong for 3 times in a row then Alarm will be on
);

    typedef enum {STATE_0, STATE_1, STATE_2, STATE_3, STATE_4} state_type;
    typedef enum {ERR_0, ERR_1, ERR_2, ERR_3} err_type;
    state_type state, next_state;
    err_type err, next_err;
    reg [15:0] real_password;
    reg [15:0] input_password;
    reg [15:0] superpassword = 16'h6385;
    
/* Below are FSM for STATE */
    always_ff @ (posedge CLK, posedge RST) begin
        if (!RST) begin
            state <= STATE_0;
        end
        else begin
            case (state)
                STATE_0: input_password[15:12] <= Code;
                STATE_1: input_password[11:8] <= Code;
                STATE_2: input_password[7:4] <= Code;
                STATE_3: input_password[3:0] <= Code;
                STATE_4: begin
                    if (err != ERR_3 && Mode == 0) begin
                        real_password <= input_password;
                    end
                    else begin
                        real_password <= real_password;
                    end
                end 
            endcase
            state <= next_state;
        end
    end
    
// Shift state
    always_comb begin
        if (RST) begin
            case (state)
                STATE_0: next_state = STATE_1;
                STATE_1: next_state = STATE_2;
                STATE_2: next_state = STATE_3;
                STATE_3: next_state = STATE_4;
                STATE_4: next_state = STATE_4;
            endcase
        end
        else begin
            next_state = state;
        end
    end
    
/* FSM for ERR */
    always_comb begin
        if (err == ERR_3) begin
            if (state == STATE_4 && Mode == 1 && input_password == superpassword ) begin
                err = ERR_0;
            end
            else begin
                err = err;
            end
        end
        else begin
            if (state == STATE_4) begin
                if (Mode == 1) begin
                    // input_password for verification
                    if (input_password == real_password) begin
                        err = ERR_0;
                    end
                    else begin
                        /* Change err */
                        case (err)
                            ERR_0: err = ERR_1;
                            ERR_1: err = ERR_2;
                            ERR_2: err = ERR_3;
                            ERR_3: err = ERR_3;
                        endcase 
                    end
                end
                else begin
                    // Set the password which doesn't change 
                    err = err;
                end
            end
            else begin
                err = err;
            end
        end
    end
    
/* Alarm lights */
    always_comb begin
        if (err == ERR_3) begin
            Alarm = 1;
        end
        else begin
            Alarm = 0;
        end
    end
    
/* Unlock, Err, and Set lights */
    always_comb begin
        if (Mode == 1) begin
            Set = 0;
            if (state == STATE_4) begin
                if (((err == ERR_3) && (input_password == superpassword)) || ((err != ERR_3) && (input_password == real_password))) begin
                    Unlock = 1;
                    Err = 0;
                end
                else begin
                    Err = 1;
                    Unlock = 0;
                end
            end
            else begin
                Unlock = 0;
                Err = 0;
            end
        end
        else begin
            Unlock = 0;
            Err = 0;
            if ( err != ERR_3 && state == STATE_4 ) begin
                Set = 1;
            end
            else begin
                Set = 0;
            end
        end
    end

endmodule