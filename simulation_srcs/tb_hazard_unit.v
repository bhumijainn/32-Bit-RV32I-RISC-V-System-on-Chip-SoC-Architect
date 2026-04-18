`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:11:36
// Design Name: 
// Module Name: tb_hazard_unit
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

module tb_hazard_unit;

    // Inputs
    reg       id_ex_mem_read;
    reg [4:0] id_ex_rd;
    reg [4:0] if_id_rs1;
    reg [4:0] if_id_rs2;

    // Outputs
    wire stall_pc;
    wire stall_if_id;
    wire flush_id_ex;

    // Instantiate the Unit
    hazard_unit uut (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .stall_pc(stall_pc),
        .stall_if_id(stall_if_id),
        .flush_id_ex(flush_id_ex)
    );

    initial begin
        // Initialize
        id_ex_mem_read = 0; id_ex_rd = 0;
        if_id_rs1 = 0; if_id_rs2 = 0;
        #10;

        // TEST 1: Normal Operation (No Load)
        // EX has an ADD writing to x5. ID needs x5. (This is a data hazard, but the
        // Forwarding Unit handles this! The Hazard Unit should do nothing).
        id_ex_mem_read = 0; 
        id_ex_rd = 5; 
        if_id_rs1 = 5; 
        if_id_rs2 = 6;
        #10;
        $display("Test 1 (Normal)   -> Stall PC:%b, Stall IF/ID:%b, Flush ID/EX:%b (Expected: 0, 0, 0)", 
                 stall_pc, stall_if_id, flush_id_ex);

        // TEST 2: Load-Use Hazard on rs1
        // EX has a LW writing to x5. ID needs x5 immediately.
        id_ex_mem_read = 1; 
        id_ex_rd = 5; 
        if_id_rs1 = 5; 
        if_id_rs2 = 6;
        #10;
        $display("Test 2 (LW Haz 1) -> Stall PC:%b, Stall IF/ID:%b, Flush ID/EX:%b (Expected: 1, 1, 1)", 
                 stall_pc, stall_if_id, flush_id_ex);

        // TEST 3: Load-Use Hazard on rs2
        // EX has a LW writing to x6. ID needs x6 immediately.
        id_ex_mem_read = 1; 
        id_ex_rd = 6; 
        if_id_rs1 = 2; 
        if_id_rs2 = 6;
        #10;
        $display("Test 3 (LW Haz 2) -> Stall PC:%b, Stall IF/ID:%b, Flush ID/EX:%b (Expected: 1, 1, 1)", 
                 stall_pc, stall_if_id, flush_id_ex);

        // TEST 4: Load without Hazard
        // EX has a LW writing to x10. ID needs x2 and x3. (No collision).
        id_ex_mem_read = 1; 
        id_ex_rd = 10; 
        if_id_rs1 = 2; 
        if_id_rs2 = 3;
        #10;
        $display("Test 4 (Safe LW)  -> Stall PC:%b, Stall IF/ID:%b, Flush ID/EX:%b (Expected: 0, 0, 0)", 
                 stall_pc, stall_if_id, flush_id_ex);

        $finish;
    end

endmodule
