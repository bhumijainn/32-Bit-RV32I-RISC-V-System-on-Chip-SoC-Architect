
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 23:48:27
// Design Name: 
// Module Name: reg_file
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

module reg_file (
    input  wire        clk,
    input  wire        we,
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    reg [31:0] registers [31:0];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) registers[i] = 32'b0;
    end

    // --- INTERNAL FORWARDING LOGIC ---
    // If we are writing to a register on the same cycle we are reading it, 
    // bypass the old value and output the new rd_data immediately.
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : 
                      ((we && (rd_addr == rs1_addr)) ? rd_data : registers[rs1_addr]);

    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : 
                      ((we && (rd_addr == rs2_addr)) ? rd_data : registers[rs2_addr]);

    always @(posedge clk) begin
        if (we && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= rd_data;
        end
    end
endmodule