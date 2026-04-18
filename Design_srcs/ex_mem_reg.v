
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 00:58:09
// Design Name: 
// Module Name: ex_mem_reg
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

module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,
    
    // Data Inputs (From Execute Stage)
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_data_in,   // This is the data we write to RAM during a Store
    input  wire [4:0]  rd_addr_in,    // Destination register
    
    // Control Inputs
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,
    input  wire        mem_write_in,

    // Data Outputs (To Memory Stage)
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rs2_data_out,
    output reg  [4:0]  rd_addr_out,
    
    // Control Outputs
    output reg         reg_write_out,
    output reg         mem_to_reg_out,
    output reg         mem_write_out
);

    always @(posedge clk) begin
        if (reset) begin
            alu_result_out <= 0; rs2_data_out <= 0; rd_addr_out <= 0;
            reg_write_out <= 0; mem_to_reg_out <= 0; mem_write_out <= 0;
        end else begin
            alu_result_out <= alu_result_in; rs2_data_out <= rs2_data_in; rd_addr_out <= rd_addr_in;
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in; mem_write_out <= mem_write_in;
        end
    end

endmodule
