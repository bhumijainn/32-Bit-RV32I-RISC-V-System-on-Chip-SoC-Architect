`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 00:59:07
// Design Name: 
// Module Name: mem_wb_reg
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

module mem_wb_reg (
    input  wire        clk,
    input  wire        reset,
    
    // Data Inputs (From Memory Stage)
    input  wire [31:0] mem_read_data_in,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  rd_addr_in,    // Destination register
    
    // Control Inputs
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,

    // Data Outputs (To Write Back Stage)
    output reg  [31:0] mem_read_data_out,
    output reg  [31:0] alu_result_out,
    output reg  [4:0]  rd_addr_out,
    
    // Control Outputs
    output reg         reg_write_out,
    output reg         mem_to_reg_out
);

    always @(posedge clk) begin
        if (reset) begin
            mem_read_data_out <= 0; alu_result_out <= 0; rd_addr_out <= 0;
            reg_write_out <= 0; mem_to_reg_out <= 0;
        end else begin
            mem_read_data_out <= mem_read_data_in; alu_result_out <= alu_result_in; rd_addr_out <= rd_addr_in;
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in;
        end
    end

endmodule