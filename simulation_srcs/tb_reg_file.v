`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 23:51:13
// Design Name: 
// Module Name: tb_reg_file
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

module tb_reg_file;

    // Inputs to the module are 'reg'
    reg        clk;
    reg        we;
    reg [4:0]  rs1_addr;
    reg [4:0]  rs2_addr;
    reg [4:0]  rd_addr;
    reg [31:0] rd_data;

    // Outputs from the module are 'wire'
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Instantiate the Register File
    reg_file uut (
        .clk(clk),
        .we(we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // --- CLOCK GENERATOR ---
    // Invert the clock every 5 nanoseconds (Creates a 10ns clock period / 100MHz clock)
    always #5 clk = ~clk;

    initial begin
        // Initialize all inputs to zero
        clk = 0;
        we = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;

        // Wait a few cycles before starting
        #15;

        // TEST 1: Write the hex value 'AAAABBBB' into Register 5
        we = 1;
        rd_addr = 5'd5;
        rd_data = 32'hAAAABBBB;
        #10; // Wait for 1 clock cycle so the write actually happens

        // TEST 2: Read from Register 5 to see if it saved
        we = 0;         // Turn off write enable
        rs1_addr = 5'd5; // Read from address 5 on port 1
        #10;
        $display("Read Reg 5: %h (Expected: aaaabbbb)", rs1_data);

        // TEST 3: Try to hack the architecture by writing to Register 0
        we = 1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFFFFFF; // Try to write all 1s
        #10;

        // TEST 4: Read from Register 0 to prove it stayed 0
        we = 0;
        rs2_addr = 5'd0; // Read from address 0 on port 2
        #10;
        $display("Read Reg 0: %h (Expected: 00000000)", rs2_data);

        // Stop the simulation
        $finish;
    end

endmodule