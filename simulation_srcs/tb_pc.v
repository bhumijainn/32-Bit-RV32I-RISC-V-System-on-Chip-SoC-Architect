`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:20:43
// Design Name: 
// Module Name: tb_pc
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


`timescale 1ns / 1ps

module tb_pc;

    // Inputs to module are 'reg'
    reg        clk;
    reg        reset;
    reg [31:0] pc_in;

    // Output from module is 'wire'
    wire [31:0] pc_out;

    // Instantiate the Program Counter
    pc uut (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Generate a 10ns clock
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;      // Keep the processor in reset initially
        pc_in = 32'd0;

        // Wait a few cycles
        #15;
        
        // TEST 1: Release reset and simulate normal execution
        // RISC-V instructions are 32 bits (4 bytes) long, so the PC usually counts up by 4
        reset = 0; 
        pc_in = 32'd4;   // Tell PC to go to address 4
        #10;
        $display("Time: %0t | PC Out: %d (Expected: 4)", $time, pc_out);

        pc_in = 32'd8;   // Tell PC to go to address 8
        #10;
        $display("Time: %0t | PC Out: %d (Expected: 8)", $time, pc_out);

        // TEST 2: Simulate a Branch or Jump (e.g., jumping to address 100)
        pc_in = 32'd100;
        #10;
        $display("Time: %0t | PC Out: %d (Expected: 100)", $time, pc_out);

        // TEST 3: Hit the reset button while running
        reset = 1;
        pc_in = 32'd104; // The PC should ignore this and go to 0
        #10;
        $display("Time: %0t | PC Out: %d (Expected: 0)", $time, pc_out);

        $finish;
    end

endmodule