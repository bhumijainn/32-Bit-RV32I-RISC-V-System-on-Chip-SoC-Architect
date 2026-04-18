`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:52:20
// Design Name: 
// Module Name: tb_inst_mem
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

module tb_inst_mem;

    // Inputs to module are 'reg'
    reg [31:0] tb_pc_addr;

    // Outputs from module are 'wire'
    wire [31:0] tb_instruction;

    // Instantiate the Instruction Memory
    inst_mem uut (
        .pc_addr(tb_pc_addr),
        .instruction(tb_instruction)
    );

    initial begin
        // Start at address 0
        tb_pc_addr = 32'd0;
        #10;
        $display("PC: %d | Instruction: %h (Expected: 11111111)", tb_pc_addr, tb_instruction);

        // Advance PC by 4 (Next instruction)
        tb_pc_addr = 32'd4;
        #10;
        $display("PC: %d | Instruction: %h (Expected: 22222222)", tb_pc_addr, tb_instruction);

        // Advance PC by 4
        tb_pc_addr = 32'd8;
        #10;
        $display("PC: %d | Instruction: %h (Expected: 33333333)", tb_pc_addr, tb_instruction);

        // Advance PC by 4
        tb_pc_addr = 32'd12;
        #10;
        $display("PC: %d | Instruction: %h (Expected: 44444444)", tb_pc_addr, tb_instruction);

        // Test an uninitialized address to ensure it outputs 0
        tb_pc_addr = 32'd20;
        #10;
        $display("PC: %d | Instruction: %h (Expected: 00000000)", tb_pc_addr, tb_instruction);

        $finish;
    end

endmodule