
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:10:54
// Design Name: 
// Module Name: tb_riscv_top
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

module tb_riscv_top;

    reg clk;
    reg reset;

    // Instantiate the Top-Level Core
    riscv_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Generate a 10ns Clock
    always #5 clk = ~clk;

    initial begin
        // Step 1: Power on and hold Reset
        clk = 0;
        reset = 1; 
        #20;
        
        // Step 2: Release Reset. The PC drops to 0 and the program begins!
        reset = 0; 
        
        // Step 3: Wait for the 4 instructions in our ROM to finish executing
        #50;
        
        $display("-----------------------------------------");
        $display("PROGRAM EXECUTION COMPLETE");
        $display("-----------------------------------------");
        $display("Look at your Data Memory (RAM) waveforms.");
        $display("Address 8 should now contain the value 25.");
        
        $finish;
    end

endmodule
