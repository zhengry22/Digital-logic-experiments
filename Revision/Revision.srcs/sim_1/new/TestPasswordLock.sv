`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 09:28:46
// Design Name: 
// Module Name: TestPasswordLock
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

/* 
    Design a testing strategy as follow:
    First, set mode to 0, set the password to be 8421
    next, reset, input 8421 as the password to unlock
    and then input wrong password for 3 times to trigger the alarm
    When alarm is triggered, you can't change the password nor unlock by the password you set.
    To test this, first set mode to 0, reset and set the password to 5678, which will fail
    Then set mode to 1, reset and input 8421, which should fail
    afterwards, unlock by input the superpassword: 6385 and unlock.
    next reset and try to unlock using 5678 which should fail
    next reset and unlock using 8421, which should succeed
*/


module TestPasswordLock;
    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] code;
    reg mode;
    wire right;
    wire set;
    wire wrong;
    wire alarm;

    // Instantiate the PasswordLock module
    PasswordLock dut (
        .clk(clk),
        .rst(rst),
        .code(code),
        .mode(mode),
        .right(right),
        .set(set),
        .wrong(wrong),
        .alarm(alarm)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Testbench sequence
    initial begin
        // Initialize signals
        rst = 1;
        mode = 0;
        code = 4'b0000;

        // Reset the DUT
        #10 rst = 0;
        #10 rst = 1;

        // Set password to 8421
        code = 4'b1000;  // Set first digit to 8
        #10;
        code = 4'b0100;  // Set second digit to 4
        #10;
        code = 4'b0010;  // Set third digit to 2
        #10;
        code = 4'b0001;  // Set fourth digit to 1
        #10;
        #10;
        
        repeat (3) begin
            // Verify password 8421 (mode = 1)
        mode = 1;
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b1000;  // Enter first digit 8
        #10;
        code = 4'b0100;  // Enter second digit 4
        #10;
        code = 4'b0010;  // Enter third digit 2
        #10;
        code = 4'b0001;  // Enter fourth digit 1
        #10;
        if (right) $display("Password 8421: Verification SUCCESS");
        else $display("Password 8421: Verification FAILED");
        #10;
        // Input wrong password 3 times to trigger the alarm
        repeat (3) begin
            #10 rst = 0;
            #10 rst = 1;
            code = 4'b0001;  // Enter wrong digit 1
            #10;
            code = 4'b0010;  // Enter wrong digit 2
            #10;
            code = 4'b0011;  // Enter wrong digit 3
            #10;
            code = 4'b0100;  // Enter wrong digit 4
            #10;
            #10;
            if (wrong) $display("Wrong password: Verification FAILED as expected");
        end

        // Check if alarm is triggered
        if (alarm) $display("Alarm TRIGGERED after 3 wrong attempts");
        else $display("Alarm NOT triggered");

        // Attempt to set new password 5678, should fail due to alarm
        mode = 0;
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b0101;  // Attempt to set first digit to 5
        #10;
        code = 4'b0110;  // Attempt to set second digit to 6
        #10;
        code = 4'b0111;  // Attempt to set third digit to 7
        #10;
        code = 4'b1000;  // Attempt to set fourth digit to 8
        #10;
        #10;
        if (set) $display("Password 5678: Set unexpectedly SUCCESS");
        else $display("Password 5678: Set FAILED as expected due to alarm");

        // Verify password 8421, should fail due to alarm
        mode = 1;
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b1000;  // Enter first digit 8
        #10;
        code = 4'b0100;  // Enter second digit 4
        #10;
        code = 4'b0010;  // Enter third digit 2
        #10;
        code = 4'b0001;  // Enter fourth digit 1
        #10;
        #10;
        if (right) $display("Password 8421: Verification SUCCESS unexpectedly");
        else $display("Password 8421: Verification FAILED as expected due to alarm");

        // Unlock using superpassword 6385
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b0110;  // Enter first digit 6
        #10;
        code = 4'b0011;  // Enter second digit 3
        #10;
        code = 4'b1000;  // Enter third digit 8
        #10;
        code = 4'b0101;  // Enter fourth digit 5
        #10;
        #10;
        if (alarm == 0) $display("Superpassword 6385: Alarm RESET and system UNLOCKED");
        else $display("Superpassword 6385: FAILED to unlock");

        // Verify password 5678, should fail as it was never set
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b0101;  // Enter first digit 5
        #10;
        code = 4'b0110;  // Enter second digit 6
        #10;
        code = 4'b0111;  // Enter third digit 7
        #10;
        code = 4'b1000;  // Enter fourth digit 8
        #10;
        #10;
        if (right) $display("Password 5678: Verification SUCCESS unexpectedly");
        else $display("Password 5678: Verification FAILED as expected");

        // Verify password 8421, should succeed
        #10 rst = 0;
        #10 rst = 1;
        code = 4'b1000;  // Enter first digit 8
        #10;
        code = 4'b0100;  // Enter second digit 4
        #10;
        code = 4'b0010;  // Enter third digit 2
        #10;
        code = 4'b0001;  // Enter fourth digit 1
        #10;
        #10;
        if (right) $display("Password 8421: Verification SUCCESS");
        else $display("Password 8421: Verification FAILED");
        end
        

        // End simulation
        #10 $finish;
    end
endmodule


