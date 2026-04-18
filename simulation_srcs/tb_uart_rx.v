`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:54:50
// Design Name: 
// Module Name: tb_uart_rx
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

module tb_uart_rx;

    reg clk;
    reg reset;
    reg rx_in;

    wire [7:0] rx_data;
    wire       rx_done;

    // Use 10 clocks per bit for fast simulation
    localparam CLOCKS_PER_BIT = 10;
    localparam BIT_PERIOD = 100; // 10 clocks * 10ns per clock

    // Instantiate the UART RX
    uart_rx #(.CLOCKS_PER_BIT(CLOCKS_PER_BIT)) uut (
        .clk(clk),
        .reset(reset),
        .rx_in(rx_in),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        rx_in = 1; // Idle state is HIGH
        #25;
        reset = 0;
        #50;

        // ---------------------------------------------------------
        // SIMULATE AN INCOMING BYTE: ASCII 'B' (Hex: 0x42, Bin: 01000010)
        // Note: UART sends LSB (Least Significant Bit) first!
        // Sequence: Start(0), 0, 1, 0, 0, 0, 0, 1, 0, Stop(1)
        // ---------------------------------------------------------
        $display("Transmitting ASCII 'B' to the RX Module...");

        // Start Bit
        rx_in = 0;
        #BIT_PERIOD;

        // Bit 0
        rx_in = 0;
        #BIT_PERIOD;
        
        // Bit 1
        rx_in = 1;
        #BIT_PERIOD;
        
        // Bit 2
        rx_in = 0;
        #BIT_PERIOD;
        
        // Bit 3
        rx_in = 0;
        #BIT_PERIOD;
        
        // Bit 4
        rx_in = 0;
        #BIT_PERIOD;
        
        // Bit 5
        rx_in = 0;
        #BIT_PERIOD;
        
        // Bit 6
        rx_in = 1;
        #BIT_PERIOD;
        
        // Bit 7
        rx_in = 0;
        #BIT_PERIOD;

        // Stop Bit
        rx_in = 1;
        #BIT_PERIOD;

        // Wait for the state machine to hit CLEANUP and assert rx_done
        #50;
        $display("RX Output Data: %h (Expected: 42)", rx_data);
        
        $finish;
    end

endmodule