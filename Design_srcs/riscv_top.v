
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:09:24
// Design Name: 
// Module Name: riscv_top
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

module riscv_top (
    input wire clk,
    input wire reset
);

    // -----------------------------------------
    // 1. DECLARE INTERNAL WIRES (The copper traces on your motherboard)
    // -----------------------------------------
    wire [31:0] pc_current, pc_next, instruction;
    wire [31:0] rs1_data, rs2_data, alu_result, mem_read_data, reg_write_data;
    wire [31:0] alu_operand2;
    reg  [31:0] imm_ext; // Immediate value extracted from instruction
    
    // Control Unit wires
    wire        reg_write, alu_src, mem_write, mem_to_reg, zero;
    wire [3:0]  alu_ctrl;

    // -----------------------------------------
    // 2. HARDWARE ROUTING LOGIC
    // -----------------------------------------
    // The PC always counts up by 4 in a basic processor
    assign pc_next = pc_current + 32'd4;

    // Multiplexer: Does the ALU read from Register 2, or the Immediate value?
    assign alu_operand2 = alu_src ? imm_ext : rs2_data;

    // Multiplexer: Do we write ALU math or RAM data back to the Register File?
    assign reg_write_data = mem_to_reg ? mem_read_data : alu_result;

    // Immediate Generator (Extracts numbers hidden inside the instruction)
    always @(*) begin
        if (instruction[6:0] == 7'b0100011) begin
            // S-Type (Store): The immediate is split into two pieces
            imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end else begin
            // I-Type (Load): The immediate is all in one piece
            imm_ext = {{20{instruction[31]}}, instruction[31:20]};
        end
    end

    // -----------------------------------------
    // 3. INSTANTIATE MODULES (Solder the chips to the board)
    // -----------------------------------------
    pc PC_Inst (
        .clk(clk), .reset(reset), 
        .pc_in(pc_next), .pc_out(pc_current)
    );
    
    inst_mem ROM (
        .pc_addr(pc_current), 
        .instruction(instruction)
    );
    
    control_unit CU (
        .opcode(instruction[6:0]), .reg_write(reg_write), 
        .alu_src(alu_src), .mem_write(mem_write), 
        .mem_to_reg(mem_to_reg), .alu_ctrl(alu_ctrl)
    );
    
    reg_file RegFile (
        .clk(clk), .we(reg_write), 
        .rs1_addr(instruction[19:15]), .rs2_addr(instruction[24:20]), 
        .rd_addr(instruction[11:7]), .rd_data(reg_write_data), 
        .rs1_data(rs1_data), .rs2_data(rs2_data)
    );
    
    alu ALU_Inst (
        .rs1_i(rs1_data), .rs2_i(alu_operand2), .alu_ctrl_i(alu_ctrl), 
        .result_o(alu_result), .zero_o(zero)
    );
    
    data_mem RAM (
        .clk(clk), .we(mem_write), 
        .addr(alu_result), .write_data(rs2_data), 
        .read_data(mem_read_data)
    );

endmodule