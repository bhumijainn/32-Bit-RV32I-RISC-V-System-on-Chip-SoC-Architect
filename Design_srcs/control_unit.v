`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:59:31
// Design Name: 
// Module Name: control_unit
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

module control_unit (
    input  wire [6:0] opcode,       // The bottom 7 bits of the instruction
    output reg        reg_write,    // 1 = Write to Register File
    output reg        alu_src,      // 0 = ALU reads Register 2, 1 = ALU reads Immediate value
    output reg        mem_write,    // 1 = Write to Data Memory (RAM)
    output reg        mem_to_reg,   // 0 = Send ALU result to Register, 1 = Send RAM data to Register
    output reg [3:0]  alu_ctrl      // Tells ALU what math to do
);

    always @(*) begin
        // DEFAULT VALUES: Initialize all outputs to 0 first.
        // This is a crucial industry trick to prevent Vivado from creating "Latches".
        reg_write  = 1'b0; 
        alu_src    = 1'b0; 
        mem_write  = 1'b0; 
        mem_to_reg = 1'b0; 
        alu_ctrl   = 4'b0000;
        
        // Decode the Opcode
        case (opcode)
            7'b0110011: begin // R-Type Instructions (e.g., ADD, SUB)
                reg_write  = 1'b1; 
                alu_src    = 1'b0; 
                mem_write  = 1'b0; 
                mem_to_reg = 1'b0; 
                alu_ctrl   = 4'b0000; // Tell ALU to ADD
            end
            
            7'b0000011: begin // I-Type Load Instructions (e.g., LW - Load Word)
                reg_write  = 1'b1; 
                alu_src    = 1'b1; 
                mem_write  = 1'b0; 
                mem_to_reg = 1'b1; 
                alu_ctrl   = 4'b0000; // Tell ALU to ADD (to calculate memory address)
            end
            
            7'b0100011: begin // S-Type Store Instructions (e.g., SW - Store Word)
                reg_write  = 1'b0; // DO NOT write to registers!
                alu_src    = 1'b1; 
                mem_write  = 1'b1; // Write to RAM!
                mem_to_reg = 1'b0; 
                alu_ctrl   = 4'b0000; // Tell ALU to ADD (to calculate memory address)
            end
            
            default: begin
                // If we get an unknown instruction, do nothing.
                reg_write  = 1'b0; 
                alu_src    = 1'b0; 
                mem_write  = 1'b0; 
                mem_to_reg = 1'b0; 
                alu_ctrl   = 4'b0000;
            end
        endcase
    end

endmodule