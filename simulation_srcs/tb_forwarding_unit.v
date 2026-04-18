
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:02:23
// Design Name: 
// Module Name: tb_forwarding_unit
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

module tb_forwarding_unit;

    // Inputs
    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] ex_mem_rd;
    reg       ex_mem_reg_write;
    reg [4:0] mem_wb_rd;
    reg       mem_wb_reg_write;

    // Outputs
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // Instantiate the Unit
    forwarding_unit uut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin
        // Initialize all to 0
        id_ex_rs1 = 0; id_ex_rs2 = 0;
        ex_mem_rd = 0; ex_mem_reg_write = 0;
        mem_wb_rd = 0; mem_wb_reg_write = 0;
        #10;

        // TEST 1: No Hazards (Normal Execution)
        // Current instruction needs x5 and x6. Previous instructions wrote to x10 and x11.
        id_ex_rs1 = 5; id_ex_rs2 = 6;
        ex_mem_rd = 10; ex_mem_reg_write = 1;
        mem_wb_rd = 11; mem_wb_reg_write = 1;
        #10;
        $display("Test 1 (No Hazard) -> FwdA: %b, FwdB: %b (Expected: 00, 00)", forward_a, forward_b);

        // TEST 2: EX Hazard on rs1 (Immediate collision)
        // Current needs x5. The instruction right in front of it just calculated x5!
        id_ex_rs1 = 5; id_ex_rs2 = 6;
        ex_mem_rd = 5; ex_mem_reg_write = 1;
        mem_wb_rd = 11; mem_wb_reg_write = 1;
        #10;
        $display("Test 2 (EX Hazard) -> FwdA: %b, FwdB: %b (Expected: 10, 00)", forward_a, forward_b);

        // TEST 3: MEM Hazard on rs2 (Delayed collision)
        // Current needs x6. The instruction two steps ahead of it calculated x6!
        id_ex_rs1 = 5; id_ex_rs2 = 6;
        ex_mem_rd = 10; ex_mem_reg_write = 1; // Unrelated
        mem_wb_rd = 6;  mem_wb_reg_write = 1; // Collision on rs2!
        #10;
        $display("Test 3 (MEM Hazard)-> FwdA: %b, FwdB: %b (Expected: 00, 01)", forward_a, forward_b);
        
        // TEST 4: The x0 exception
        // Current needs x0. The previous instruction wrote to x0. (Should NOT forward!)
        id_ex_rs1 = 0; id_ex_rs2 = 0;
        ex_mem_rd = 0; ex_mem_reg_write = 1;
        #10;
        $display("Test 4 (x0 Check)  -> FwdA: %b, FwdB: %b (Expected: 00, 00)", forward_a, forward_b);

        $finish;
    end

endmodule
