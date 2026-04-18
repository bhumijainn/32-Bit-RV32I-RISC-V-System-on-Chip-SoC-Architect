`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 20:12:19
// Design Name: 
// Module Name: alu
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

module alu (
    input  wire [31:0] rs1_i,
    input  wire [31:0] rs2_i,
    input  wire [3:0]  alu_ctrl_i,
    output reg  [31:0] result_o,   // 'reg' because it's driven in an always block
    output wire        zero_o      // 'wire' because it's continuously assigned
);

    always @(*) begin
        case (alu_ctrl_i)
            4'b0000: result_o = rs1_i + rs2_i;         // ADD
            4'b0001: result_o = rs1_i - rs2_i;         // SUB
            4'b0010: result_o = rs1_i & rs2_i;         // AND
            4'b0011: result_o = rs1_i | rs2_i;         // OR
            4'b0100: result_o = rs1_i ^ rs2_i;         // XOR
            4'b0101: result_o = rs1_i << rs2_i[4:0];   // SLL
            4'b0110: result_o = rs1_i >> rs2_i[4:0];   // SRL
            default: result_o = 32'b0;                 // Prevent latches!
        endcase
    end

    assign zero_o = (result_o == 32'b0) ? 1'b1 : 1'b0;

endmodule
