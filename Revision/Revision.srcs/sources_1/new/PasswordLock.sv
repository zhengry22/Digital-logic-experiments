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
    input wire clk,
    input wire rst,
    input wire [3:0] code,
    input wire mode,
    output reg right = 0,
    output reg set = 0,
    output reg wrong = 0,
    output reg alarm = 0 // Wrong in 3 consecutive attempts causes alarm to light up
    );
    
    /* Define the states for fsm */
    typedef enum {STATE_0, STATE_1, STATE_2, STATE_3, STATE_4} state_type; 
    typedef enum {ERR_0, ERR_1, ERR_2, ERR_3} err_type;
    state_type my_state = STATE_0;
    err_type my_err = ERR_0;
    
    /* Define the originial password as 1234 */
    reg [15:0] password = 16'h1234;
    reg [15:0] superpassword = 16'h6385;
    reg [15:0] verify = 16'h0000;
    reg lock = 1;
    
    always_ff @ (posedge clk, negedge rst) begin
        if (rst == 0) begin
            my_state <= STATE_0;
            set <= 0;
            right <= 0;
            wrong <= 0;
            lock <= 1;
        end
        else begin
            if (mode == 0) begin
               /* mode = 0: set password */
               if (my_err == ERR_3) begin
                    /* Can't set password */
                    set <= 0;
                    alarm <= 1;
                    my_state <= my_state;
               end
               else begin
                   case(my_state) 
                        STATE_0: begin
                            password[15:12] <= code;
                            my_state <= STATE_1;
                        end
                        STATE_1: begin
                            password[11:8] <= code;
                            my_state <= STATE_2;
                        end
                        STATE_2: begin
                            password[7:4] <= code;
                            my_state <= STATE_3;
                        end
                        STATE_3: begin
                            password[3:0] <= code;
                            my_state <= STATE_4;
                        end
                        STATE_4: begin
                            /* We have received the entire password */
                            if (right == 1 || wrong == 1) begin
                                /* Switch directly from mode 1 to 0, the set light shouldn't lit up */
                                set <= 0;
                            end
                            else begin
                                set <= 1;
                            end
                        end
                   endcase
                end
            end     
            else begin
               /* mode = 1: verify password */
               case(my_state) 
                    STATE_0: begin
                        verify[15:12] <= code;
                        my_state <= STATE_1;
                    end
                    STATE_1: begin
                        verify[11:8] <= code;
                        my_state <= STATE_2;
                    end
                    STATE_2: begin
                        verify[7:4] <= code;
                        my_state <= STATE_3;
                    end
                    STATE_3: begin
                        verify[3:0] <= code;
                        my_state <= STATE_4;
                    end
                    STATE_4: begin
                        /* We have received the entire password */
                        if (set == 1) begin
                            /* Switch directly from mode 1 to 0, the set light shouldn't lit up */
                            wrong <= 0;
                            right <= 0;
                        end
                        else begin
                            if (my_err == ERR_3) begin
                                if (verify == superpassword) begin
                                    my_err <= ERR_0;
                                    alarm <= 0;
                                end
                                else begin
                                    alarm <= 1;
                                    my_err <= ERR_3;
                                end
                            end
                            else begin
                                if (verify == password) begin
                                    right <= 1;
                                    wrong <= 0;
                                    my_err <= ERR_0;
                                end
                                else begin   
                                    wrong <= 1;
                                    right <= 0;
                                    if (lock == 1) begin
                                        case (my_err)
                                            ERR_0: my_err <= ERR_1;
                                            ERR_1: my_err <= ERR_2;
                                            ERR_2: begin
                                                my_err <= ERR_3;
                                                alarm <= 1;
                                            end
                                            ERR_3: begin
                                                my_err <= ERR_3;
                                                alarm <= 1;
                                            end
                                        endcase
                                        lock <= 0;
                                    end
                                    else begin
                                        my_err <= my_err;
                                    end
                                end
                            end                           
                        end
                    end
               endcase
            end
        end
    end
endmodule
