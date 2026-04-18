`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:16:56
// Design Name: 
// Module Name: riscv_top_pipelined
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

module riscv_top_pipelined (
    input  wire clk,
    input  wire reset,
    input  wire rx_in,   // UART Receive Pin
    output wire tx_out   // UART Transmit Pin
);

    // =========================================================================
    // WIRE DECLARATIONS
    // =========================================================================
    
    // --- Hazard & Forwarding Wires ---
    wire stall_pc, stall_if_id, flush_id_ex;
    wire [1:0] forward_a, forward_b;
    
    // --- IF Stage Wires ---
    wire [31:0] if_pc_current, if_pc_next, if_instruction;
    
    // --- ID Stage Wires ---
    wire [31:0] id_pc, id_instruction;
    wire [31:0] id_rs1_data, id_rs2_data;
    reg  [31:0] id_imm_ext;
    wire id_reg_write, id_mem_to_reg, id_mem_write, id_alu_src;
    wire [3:0]  id_alu_ctrl;
    
    // --- EX Stage Wires ---
    wire [31:0] ex_pc, ex_rs1_data, ex_rs2_data, ex_imm;
    wire [4:0]  ex_rs1_addr, ex_rs2_addr, ex_rd_addr;
    wire ex_reg_write, ex_mem_to_reg, ex_mem_write, ex_alu_src;
    wire [3:0]  ex_alu_ctrl;
    reg  [31:0] forward_a_mux_out, forward_b_mux_out;
    wire [31:0] ex_alu_operand2, ex_alu_result;
    wire ex_zero; 
    
    // --- MEM Stage Wires ---
    wire [31:0] mem_alu_result, mem_rs2_data, mem_read_data;
    wire [4:0]  mem_rd_addr;
    wire mem_reg_write, mem_mem_to_reg, mem_mem_write;
    
    // --- WB Stage Wires ---
    wire [31:0] wb_mem_read_data, wb_alu_result, wb_reg_write_data;
    wire [4:0]  wb_rd_addr;
    wire wb_reg_write, wb_mem_to_reg;

    // =========================================================================
    // STAGE 1: INSTRUCTION FETCH (IF)
    // =========================================================================
    
    assign if_pc_next = stall_pc ? if_pc_current : (if_pc_current + 32'd4);

    pc PC_Inst (.clk(clk), .reset(reset), .pc_in(if_pc_next), .pc_out(if_pc_current));
    
    inst_mem ROM (.pc_addr(if_pc_current), .instruction(if_instruction));
    
    if_id_reg IF_ID (
        .clk(clk), .reset(reset), .stall(stall_if_id), .flush(1'b0), 
        .pc_in(if_pc_current), .inst_in(if_instruction),
        .pc_out(id_pc), .inst_out(id_instruction)
    );

    // =========================================================================
    // STAGE 2: INSTRUCTION DECODE (ID)
    // =========================================================================
    
    hazard_unit Hazard_Detection (
        .id_ex_mem_read(ex_mem_to_reg), .id_ex_rd(ex_rd_addr),
        .if_id_rs1(id_instruction[19:15]), .if_id_rs2(id_instruction[24:20]),
        .stall_pc(stall_pc), .stall_if_id(stall_if_id), .flush_id_ex(flush_id_ex)
    );

    control_unit CU (
        .opcode(id_instruction[6:0]), .reg_write(id_reg_write), 
        .alu_src(id_alu_src), .mem_write(id_mem_write), 
        .mem_to_reg(id_mem_to_reg), .alu_ctrl(id_alu_ctrl)
    );
    
    reg_file RegFile (
        .clk(clk), .we(wb_reg_write), 
        .rs1_addr(id_instruction[19:15]), .rs2_addr(id_instruction[24:20]), 
        .rd_addr(wb_rd_addr), .rd_data(wb_reg_write_data), 
        .rs1_data(id_rs1_data), .rs2_data(id_rs2_data)
    );

    // Immediate Generator
    always @(*) begin
        if (id_instruction[6:0] == 7'b0100011) // Store
            id_imm_ext = {{20{id_instruction[31]}}, id_instruction[31:25], id_instruction[11:7]};
        else // Load or Math
            id_imm_ext = {{20{id_instruction[31]}}, id_instruction[31:20]};
    end

    id_ex_reg ID_EX (
        .clk(clk), .reset(reset), .flush(flush_id_ex),
        .pc_in(id_pc), .rs1_data_in(id_rs1_data), .rs2_data_in(id_rs2_data), 
        .imm_in(id_imm_ext), .rs1_addr_in(id_instruction[19:15]), 
        .rs2_addr_in(id_instruction[24:20]), .rd_addr_in(id_instruction[11:7]),
        .reg_write_in(id_reg_write), .mem_to_reg_in(id_mem_to_reg), 
        .mem_write_in(id_mem_write), .alu_src_in(id_alu_src), .alu_ctrl_in(id_alu_ctrl),
        
        .pc_out(ex_pc), .rs1_data_out(ex_rs1_data), .rs2_data_out(ex_rs2_data), 
        .imm_out(ex_imm), .rs1_addr_out(ex_rs1_addr), 
        .rs2_addr_out(ex_rs2_addr), .rd_addr_out(ex_rd_addr),
        .reg_write_out(ex_reg_write), .mem_to_reg_out(ex_mem_to_reg), 
        .mem_write_out(ex_mem_write), .alu_src_out(ex_alu_src), .alu_ctrl_out(ex_alu_ctrl)
    );

    // =========================================================================
    // STAGE 3: EXECUTE (EX)
    // =========================================================================
    
    forwarding_unit Forwarding (
        .id_ex_rs1(ex_rs1_addr), .id_ex_rs2(ex_rs2_addr),
        .ex_mem_rd(mem_rd_addr), .ex_mem_reg_write(mem_reg_write),
        .mem_wb_rd(wb_rd_addr), .mem_wb_reg_write(wb_reg_write),
        .forward_a(forward_a), .forward_b(forward_b)
    );

    always @(*) begin
        case(forward_a)
            2'b00: forward_a_mux_out = ex_rs1_data;      
            2'b10: forward_a_mux_out = mem_alu_result;   
            2'b01: forward_a_mux_out = wb_reg_write_data;
            default: forward_a_mux_out = ex_rs1_data;
        endcase
    end

    always @(*) begin
        case(forward_b)
            2'b00: forward_b_mux_out = ex_rs2_data;      
            2'b10: forward_b_mux_out = mem_alu_result;   
            2'b01: forward_b_mux_out = wb_reg_write_data;
            default: forward_b_mux_out = ex_rs2_data;
        endcase
    end

    assign ex_alu_operand2 = ex_alu_src ? ex_imm : forward_b_mux_out;

    alu ALU_Inst (
        .rs1_i(forward_a_mux_out), .rs2_i(ex_alu_operand2), 
        .alu_ctrl_i(ex_alu_ctrl), .result_o(ex_alu_result), .zero_o(ex_zero)
    );

    ex_mem_reg EX_MEM (
        .clk(clk), .reset(reset),
        .alu_result_in(ex_alu_result), .rs2_data_in(forward_b_mux_out), .rd_addr_in(ex_rd_addr),
        .reg_write_in(ex_reg_write), .mem_to_reg_in(ex_mem_to_reg), .mem_write_in(ex_mem_write),
        
        .alu_result_out(mem_alu_result), .rs2_data_out(mem_rs2_data), .rd_addr_out(mem_rd_addr),
        .reg_write_out(mem_reg_write), .mem_to_reg_out(mem_mem_to_reg), .mem_write_out(mem_mem_write)
    );

    // =========================================================================
    // STAGE 4: MEMORY (MEM) & MEMORY-MAPPED I/O
    // =========================================================================
    
    // MMIO Address Decoding Logic
    wire is_uart_tx = (mem_alu_result == 32'h00008000);
    
    wire ram_we     = mem_mem_write & ~is_uart_tx;
    wire uart_tx_we = mem_mem_write &  is_uart_tx;

    data_mem RAM (
        .clk(clk), .we(ram_we), .addr(mem_alu_result), 
        .write_data(mem_rs2_data), .read_data(mem_read_data)
    );

    // UART Transmitter
    wire tx_active, tx_done;
    uart_tx #(.CLOCKS_PER_BIT(10)) UART_Transmitter (
        .clk(clk),
        .reset(reset),
        .tx_start(uart_tx_we),       
        .tx_data(mem_rs2_data[7:0]), 
        .tx_active(tx_active),
        .tx_out(tx_out),             
        .tx_done(tx_done)
    );

    // UART Receiver
    wire [7:0] rx_data;
    wire rx_done;
    uart_rx #(.CLOCKS_PER_BIT(10)) UART_Receiver (
        .clk(clk),
        .reset(reset),
        .rx_in(rx_in),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    mem_wb_reg MEM_WB (
        .clk(clk), .reset(reset),
        .mem_read_data_in(mem_read_data), .alu_result_in(mem_alu_result), .rd_addr_in(mem_rd_addr),
        .reg_write_in(mem_reg_write), .mem_to_reg_in(mem_mem_to_reg),
        
        .mem_read_data_out(wb_mem_read_data), .alu_result_out(wb_alu_result), .rd_addr_out(wb_rd_addr),
        .reg_write_out(wb_reg_write), .mem_to_reg_out(wb_mem_to_reg)
    );

    // =========================================================================
    // STAGE 5: WRITE BACK (WB)
    // =========================================================================
    
    assign wb_reg_write_data = wb_mem_to_reg ? wb_mem_read_data : wb_alu_result;

endmodule
