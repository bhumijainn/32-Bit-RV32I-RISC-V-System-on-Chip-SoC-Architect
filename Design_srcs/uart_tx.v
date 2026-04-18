`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:49:38
// Design Name: 
// Module Name: uart_tx
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

module uart_tx #(
    // Parameterized for easy simulation. 
    // For real hardware at 100MHz and 115200 Baud, set this to 868.
    parameter CLOCKS_PER_BIT = 100 
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,    // Pulse HIGH to begin sending
    input  wire [7:0] tx_data,     // The 8-bit byte to send (e.g., ASCII character)
    output reg        tx_active,   // HIGH while sending
    output reg        tx_out,      // The physical serial wire out to the real world
    output reg        tx_done      // Pulses HIGH for 1 clock when finished
);

    // State Machine Definitions
    localparam IDLE       = 3'b000;
    localparam START_BIT  = 3'b001;
    localparam DATA_BITS  = 3'b010;
    localparam STOP_BIT   = 3'b011;
    localparam CLEANUP    = 3'b100;

    reg [2:0]  state;
    reg [31:0] clock_count;
    reg [2:0]  bit_index;
    reg [7:0]  saved_data;

    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            tx_active   <= 0;
            tx_out      <= 1; // UART idle state is always HIGH
            tx_done     <= 0;
            clock_count <= 0;
            bit_index   <= 0;
            saved_data  <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_out      <= 1;
                    tx_done     <= 0;
                    clock_count <= 0;
                    bit_index   <= 0;

                    if (tx_start) begin
                        tx_active  <= 1;
                        saved_data <= tx_data;
                        state      <= START_BIT;
                    end else begin
                        tx_active  <= 0;
                    end
                end

                START_BIT: begin
                    tx_out <= 0; // Start bit is LOW
                    if (clock_count < CLOCKS_PER_BIT - 1) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count <= 0;
                        state       <= DATA_BITS;
                    end
                end

                DATA_BITS: begin
                    tx_out <= saved_data[bit_index]; // Send the current bit
                    if (clock_count < CLOCKS_PER_BIT - 1) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1; // Move to next bit
                        end else begin
                            bit_index <= 0;
                            state     <= STOP_BIT;
                        end
                    end
                end

                STOP_BIT: begin
                    tx_out <= 1; // Stop bit is HIGH
                    if (clock_count < CLOCKS_PER_BIT - 1) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count <= 0;
                        tx_done     <= 1; // Signal that we are finished
                        state       <= CLEANUP;
                    end
                end

                CLEANUP: begin
                    tx_done   <= 0; // Pull done signal back down
                    tx_active <= 0;
                    state     <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule
