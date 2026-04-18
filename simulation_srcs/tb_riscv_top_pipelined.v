`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:21:11
// Design Name: 
// Module Name: tb_riscv_top_pipelined
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

module tb_riscv_top_pipelined;

    reg clk;
    reg reset;

    // Instantiate the Pipelined Core
    riscv_top_pipelined uut (
        .clk(clk),
        .reset(reset)
    );

    // Generate a 10ns Clock
    always #5 clk = ~clk;

    initial begin
        // Step 1: Power on and hold Reset
        clk = 0;
        reset = 1; 
        #25; // Wait a few cycles
        
        // Step 2: Release Reset. The pipeline begins filling!
        reset = 0; 
        
        // Step 3: Wait for the pipeline to process the ROM instructions
        // A 5-stage pipeline takes 5 cycles to finish the FIRST instruction, 
        // and 1 cycle for each instruction after that.
        #100;
        
        $display("-----------------------------------------");
        $display("PIPELINED EXECUTION COMPLETE");
        $display("-----------------------------------------");
        $display("Open the uut -> RAM module in your waveform viewer.");
        $display("You should see data successfully flowing through all 5 stages!");
        
        $finish;
    end

endmodule
