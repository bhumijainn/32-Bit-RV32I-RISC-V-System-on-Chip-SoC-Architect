`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 00:54:46
// Design Name: 
// Module Name: tb_if_id_reg
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




module tb_if_id_reg;

    // Inputs
    reg        clk;
    reg        reset;
    reg        stall;
    reg        flush;
    reg [31:0] pc_in;
    reg [31:0] inst_in;

    // Outputs
    wire [31:0] pc_out;
    wire [31:0] inst_out;

    // Instantiate the IF/ID Register
    if_id_reg uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_in),
        .inst_in(inst_in),
        .pc_out(pc_out),
        .inst_out(inst_out)
    );

    // Clock Generator (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Step 1: Initialization & Reset
        clk = 0;
        reset = 1;
        stall = 0;
        flush = 0;
        pc_in = 32'd0;
        inst_in = 32'd0;
        #15; // Wait for reset to clear

        // TEST 1: Normal Operation (Data flows through)
        reset = 0;
        pc_in = 32'd4;
        inst_in = 32'hAAAABBBB;
        #10; // Wait 1 clock cycle
        $display("Normal -> PC: %d | Inst: %h (Expected: 4, aaaabbbb)", pc_out, inst_out);

        // TEST 2: The Stall (Inputs change, but output should freeze)
        stall = 1;
        pc_in = 32'd8;           // New PC arrives
        inst_in = 32'hCCCCDDDD;  // New Instruction arrives
        #10;
        $display("Stall  -> PC: %d | Inst: %h (Expected: 4, aaaabbbb)", pc_out, inst_out);

        // TEST 3: Resume Normal (Stall turns off, new data flows through)
        stall = 0;
        #10;
        $display("Resume -> PC: %d | Inst: %h (Expected: 8, ccccdddd)", pc_out, inst_out);

        // TEST 4: The Flush (A bad branch was taken, clear the register)
        flush = 1;
        pc_in = 32'd12;
        inst_in = 32'hEEEEFFFF;
        #10;
        $display("Flush  -> PC: %d | Inst: %h (Expected: 0, 00000000)", pc_out, inst_out);

        $finish;
    end

endmodule