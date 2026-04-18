`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:19:52
// Design Name: 
// Module Name: pc
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

module pc (
    input  wire        clk,      // Processor clock
    input  wire        reset,    // Synchronous reset
    input  wire [31:0] pc_in,    // The next address to jump to
    output reg  [31:0] pc_out    // The current address
);

    // Synchronous logic: everything happens on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            // If reset is HIGH, force the PC to 0
            pc_out <= 32'b0;
        end else begin
            // Otherwise, update the PC with the next address
            pc_out <= pc_in;
        end
    end

endmodule
