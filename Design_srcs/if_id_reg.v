
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 00:52:45
// Design Name: 
// Module Name: if_id_reg
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

module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,      // From Hazard Unit: 1 = Freeze
    input  wire        flush,      // From Hazard Unit: 1 = Clear to 0
    input  wire [31:0] pc_in,      // Address of current instruction
    input  wire [31:0] inst_in,    // The instruction from ROM
    
    output reg  [31:0] pc_out,     // Address passed to Decode stage
    output reg  [31:0] inst_out    // Instruction passed to Decode stage
);

    always @(posedge clk) begin
        if (reset || flush) begin
            // Clear everything to 0 on reset or flush
            pc_out   <= 32'b0;
            inst_out <= 32'b0;
        end 
        else if (!stall) begin
            // Only update if we are NOT stalling
            pc_out   <= pc_in;
            inst_out <= inst_in;
        end
        // If stall == 1, do nothing (keep old values)
    end

endmodule