`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 20:15:48
// Design Name: 
// Module Name: tb
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

module tb_alu;

    // Testbench inputs must be 'reg' so we can drive them in the initial block
    reg [31:0] tb_rs1;
    reg [31:0] tb_rs2;
    reg [3:0]  tb_alu_ctrl;

    // Testbench outputs must be 'wire' to catch the output of the module
    wire [31:0] tb_result;
    wire        tb_zero;

    // Instantiate the ALU
    alu uut (
        .rs1_i(tb_rs1),
        .rs2_i(tb_rs2),
        .alu_ctrl_i(tb_alu_ctrl),
        .result_o(tb_result),
        .zero_o(tb_zero)
    );

    initial begin
        // Test 1: Addition (10 + 5 = 15)
        tb_rs1 = 32'd10; tb_rs2 = 32'd5; tb_alu_ctrl = 4'b0000;
        #10;
        $display("ADD: %d + %d = %d", tb_rs1, tb_rs2, tb_result);

        // Test 2: Subtraction leading to Zero flag (10 - 10 = 0)
        tb_rs1 = 32'd10; tb_rs2 = 32'd10; tb_alu_ctrl = 4'b0001;
        #10;
        $display("SUB: %d - %d = %d | Zero Flag: %b", tb_rs1, tb_rs2, tb_result, tb_zero);

        $finish; // Stops the Vivado simulation
    end
endmodule