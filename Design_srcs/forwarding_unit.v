
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:00:34
// Design Name: 
// Module Name: forwarding_unit
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

module forwarding_unit (
    // Inputs from the Execute Stage (What registers does the current instruction need?)
    input  wire [4:0] id_ex_rs1,
    input  wire [4:0] id_ex_rs2,
    
    // Inputs from the Memory Stage (What register did the previous instruction calculate?)
    input  wire [4:0] ex_mem_rd,
    input  wire       ex_mem_reg_write,
    
    // Inputs from the Write-Back Stage (What register did the instruction before that calculate?)
    input  wire [4:0] mem_wb_rd,
    input  wire       mem_wb_reg_write,
    
    // Outputs to the ALU Multiplexers
    output reg  [1:0] forward_a,  // Controls Operand A
    output reg  [1:0] forward_b   // Controls Operand B
);

    always @(*) begin
        // Default: Do no forwarding (Use the normal data from the Register File)
        forward_a = 2'b00;
        forward_b = 2'b00;

        // ----------------------------------------------------
        // EX HAZARD: The instruction immediately ahead of us has our data
        // ----------------------------------------------------
        // Check Operand A (rs1)
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1)) begin
            forward_a = 2'b10;
        end
        // Check Operand B (rs2)
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2)) begin
            forward_b = 2'b10;
        end

        // ----------------------------------------------------
        // MEM HAZARD: The instruction two steps ahead of us has our data
        // ----------------------------------------------------
        // Check Operand A (rs1) - Only forward if the EX stage isn't ALREADY forwarding it
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs1)) begin
            forward_a = 2'b01;
        end
        // Check Operand B (rs2)
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs2)) begin
            forward_b = 2'b01;
        end
    end

endmodule