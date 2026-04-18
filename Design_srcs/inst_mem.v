`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:45:28
// Design Name: 
// Module Name: inst_mem
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

module inst_mem (
    input  wire [31:0] pc_addr,
    output wire [31:0] instruction
);

    reg [31:0] rom [0:63];
    integer i;

    initial begin
        // Fill memory with 0s first
        for (i = 0; i < 64; i = i + 1) begin
            rom[i] = 32'b0; 
        end
        
        // 1. lw x1, 0(x0) -> Load 0x8000 into register x1
        rom[0] = 32'h00002083; 
        
        // 2. lw x2, 4(x0) -> Load 0x41 ('A') into register x2
        rom[1] = 32'h00402103; 
        
        // 3. sw x2, 0(x1) -> Store 'A' into address 0x8000 (Triggers UART!)
        rom[2] = 32'h0020A023; 
    end

    // Read Logic (Combinational)
    assign instruction = rom[pc_addr[31:2]];

endmodule