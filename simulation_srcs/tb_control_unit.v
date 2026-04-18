`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:00:32
// Design Name: 
// Module Name: tb_control_unit
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

module tb_control_unit;

    // Inputs
    reg [6:0] tb_opcode;

    // Outputs
    wire tb_reg_write;
    wire tb_alu_src;
    wire tb_mem_write;
    wire tb_mem_to_reg;
    wire [3:0] tb_alu_ctrl;

    // Instantiate the Control Unit
    control_unit uut (
        .opcode(tb_opcode),
        .reg_write(tb_reg_write),
        .alu_src(tb_alu_src),
        .mem_write(tb_mem_write),
        .mem_to_reg(tb_mem_to_reg),
        .alu_ctrl(tb_alu_ctrl)
    );

    initial begin
        // TEST 1: R-Type (ADD/SUB)
        tb_opcode = 7'b0110011; 
        #10;
        $display("R-Type -> RegWrite:%b ALUSrc:%b MemWrite:%b Mem2Reg:%b", 
                 tb_reg_write, tb_alu_src, tb_mem_write, tb_mem_to_reg);

        // TEST 2: I-Type (Load Word)
        tb_opcode = 7'b0000011;
        #10;
        $display("LOAD   -> RegWrite:%b ALUSrc:%b MemWrite:%b Mem2Reg:%b", 
                 tb_reg_write, tb_alu_src, tb_mem_write, tb_mem_to_reg);

        // TEST 3: S-Type (Store Word)
        tb_opcode = 7'b0100011;
        #10;
        $display("STORE  -> RegWrite:%b ALUSrc:%b MemWrite:%b Mem2Reg:%b", 
                 tb_reg_write, tb_alu_src, tb_mem_write, tb_mem_to_reg);

        $finish;
    end

endmodule
