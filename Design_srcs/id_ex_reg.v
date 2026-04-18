
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 00:57:21
// Design Name: 
// Module Name: id_ex_reg
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

module id_ex_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,         // 1 = Clear to 0 (Inject bubble)
    
    // Data Inputs (From Decode Stage)
    input  wire [31:0] pc_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rs1_addr_in,   // Needed later for Forwarding
    input  wire [4:0]  rs2_addr_in,   // Needed later for Forwarding
    input  wire [4:0]  rd_addr_in,    // Destination register
    
    // Control Inputs
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,
    input  wire        mem_write_in,
    input  wire        alu_src_in,
    input  wire [3:0]  alu_ctrl_in,

    // Data Outputs (To Execute Stage)
    output reg  [31:0] pc_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rs1_addr_out,
    output reg  [4:0]  rs2_addr_out,
    output reg  [4:0]  rd_addr_out,
    
    // Control Outputs
    output reg         reg_write_out,
    output reg         mem_to_reg_out,
    output reg         mem_write_out,
    output reg         alu_src_out,
    output reg  [3:0]  alu_ctrl_out
);

    always @(posedge clk) begin
        if (reset || flush) begin
            pc_out <= 0; rs1_data_out <= 0; rs2_data_out <= 0; imm_out <= 0;
            rs1_addr_out <= 0; rs2_addr_out <= 0; rd_addr_out <= 0;
            reg_write_out <= 0; mem_to_reg_out <= 0; mem_write_out <= 0; 
            alu_src_out <= 0; alu_ctrl_out <= 0;
        end else begin
            pc_out <= pc_in; rs1_data_out <= rs1_data_in; rs2_data_out <= rs2_data_in; imm_out <= imm_in;
            rs1_addr_out <= rs1_addr_in; rs2_addr_out <= rs2_addr_in; rd_addr_out <= rd_addr_in;
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in; mem_write_out <= mem_write_in; 
            alu_src_out <= alu_src_in; alu_ctrl_out <= alu_ctrl_in;
        end
    end

endmodule
