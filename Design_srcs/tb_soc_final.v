`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 02:10:30
// Design Name: 
// Module Name: tb_soc_final
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

module tb_soc_final;

    reg clk;
    reg reset;
    reg rx_in;

    wire tx_out;

    // Instantiate the SoC
    riscv_top_pipelined uut (
        .clk(clk),
        .reset(reset),
        .rx_in(rx_in),
        .tx_out(tx_out)
    );

    // Generate a 10ns Clock
    always #5 clk = ~clk;

    initial begin
        // Step 1: Power on
        clk = 0;
        reset = 1; 
        rx_in = 1; // UART line naturally idles HIGH
        #25;
        
        // Step 2: Release reset. The pipeline begins filling!
        reset = 0; 
        
        // The processor will:
        // 1. Load 0x8000 into x1
        // 2. Load 0x41 ('A') into x2
        // 3. Store 0x41 into 0x8000
        // 4. The MMIO logic routes this to the UART TX, and the `tx_out` wire starts toggling!
        
        // Step 3: Wait for the UART to physically send all the bits
        // 10 bits * 100ns per bit = 1000ns minimum. We wait 1500ns to be safe.
        #1500; 
        
        $display("-----------------------------------------");
        $display("SoC EXECUTION COMPLETE");
        $display("Check the 'tx_out' wire in your waveform. You will see it transmitting ASCII 'A'!");
        
        $finish;
    end

endmodule