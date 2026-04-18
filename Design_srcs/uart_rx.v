`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:54:07
// Design Name: 
// Module Name: uart_rx
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

module uart_rx #(
    // Keep this synced with your TX module! 
    parameter CLOCKS_PER_BIT = 100 
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       rx_in,       // The physical serial wire from the outside world
    output reg  [7:0] rx_data,     // The assembled 8-bit byte
    output reg        rx_done      // Pulses HIGH for 1 clock when a byte is fully received
);

    localparam IDLE       = 3'b000;
    localparam START_BIT  = 3'b001;
    localparam DATA_BITS  = 3'b010;
    localparam STOP_BIT   = 3'b011;
    localparam CLEANUP    = 3'b100;

    reg [2:0]  state;
    reg [31:0] clock_count;
    reg [2:0]  bit_index;

    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            rx_done     <= 0;
            rx_data     <= 0;
            clock_count <= 0;
            bit_index   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done     <= 0;
                    clock_count <= 0;
                    bit_index   <= 0;
                    
                    // The line naturally idles HIGH. A drop to LOW means a message is starting.
                    if (rx_in == 0) begin
                        state <= START_BIT;
                    end
                end

                START_BIT: begin
                    // Wait for HALF a bit period to sample the very center of the start bit
                    if (clock_count == (CLOCKS_PER_BIT / 2)) begin
                        // Check if it's still LOW (prevents false starts from electrical noise)
                        if (rx_in == 0) begin
                            clock_count <= 0;
                            state       <= DATA_BITS;
                        end else begin
                            state       <= IDLE;
                        end
                    end else begin
                        clock_count <= clock_count + 1;
                    end
                end

                DATA_BITS: begin
                    // Wait a FULL bit period to sample the center of the data bit
                    if (clock_count < CLOCKS_PER_BIT - 1) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count          <= 0;
                        rx_data[bit_index]   <= rx_in; // Store the sampled bit
                        
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state     <= STOP_BIT;
                        end
                    end
                end

                STOP_BIT: begin
                    // Wait a FULL bit period to sample the center of the stop bit
                    if (clock_count < CLOCKS_PER_BIT - 1) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        rx_done     <= 1; // Signal the CPU that we have a new byte!
                        clock_count <= 0;
                        state       <= CLEANUP;
                    end
                end

                CLEANUP: begin
                    state   <= IDLE;
                    rx_done <= 0; // Pull done signal back down
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule