`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 01:10:39
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit (
    // What is the instruction currently in the Execute stage doing?
    input  wire       id_ex_mem_read,  // 1 = It's a Load (LW) instruction
    input  wire [4:0] id_ex_rd,        // The register it is loading data into
    
    // What does the instruction currently in the Decode stage need?
    input  wire [4:0] if_id_rs1,       // Source register 1
    input  wire [4:0] if_id_rs2,       // Source register 2
    
    // Outputs to control the pipeline flow
    output reg        stall_pc,        // 1 = Freeze Program Counter
    output reg        stall_if_id,     // 1 = Freeze IF/ID Register
    output reg        flush_id_ex      // 1 = Clear ID/EX Register (Inject Bubble)
);

    always @(*) begin
        // Default: Do not stall. Let the pipeline flow normally.
        stall_pc    = 1'b0;
        stall_if_id = 1'b0;
        flush_id_ex = 1'b0;

        // LOAD-USE HAZARD DETECTION
        // If the instruction in Execute is a Load (id_ex_mem_read == 1),
        // AND its destination register matches either source register of the current instruction...
        if (id_ex_mem_read && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin
            
            // ...We must pull the emergency brake for 1 clock cycle.
            stall_pc    = 1'b1;  // Stop fetching new instructions
            stall_if_id = 1'b1;  // Hold the current instruction in the Decode stage
            flush_id_ex = 1'b1;  // Send a harmless 0 into the Execute stage
            
        end
    end

endmodule
