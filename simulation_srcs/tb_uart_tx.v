
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:50:28
// Design Name: 
// Module Name: tb_uart_tx
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

module tb_uart_tx;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx_active;
    wire tx_out;
    wire tx_done;

    // Instantiate the UART TX 
    // We override the parameter to 10 clocks per bit for a fast simulation!
    uart_tx #(.CLOCKS_PER_BIT(10)) uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_active(tx_active),
        .tx_out(tx_out),
        .tx_done(tx_done)
    );

    // 10ns Clock
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 0;
        #25;
        reset = 0;

        // TEST 1: Send the ASCII character 'A' (Hex: 0x41, Binary: 01000001)
        tx_data = 8'h41;
        tx_start = 1;  // Pulse the start button
        #10;
        tx_start = 0;

        // Wait dynamically until the module says it is finished
        @(posedge tx_done);
        #50;

        $display("UART TX Simulation Complete. Check the 'tx_out' waveform!");
        $finish;
    end

endmodule
