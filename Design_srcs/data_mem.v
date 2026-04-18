`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:04:46
// Design Name: 
// Module Name: data_mem
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

module data_mem (
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] ram [0:63];
    integer i;

    // Initialize RAM with our test variables
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            ram[i] = 32'b0;
        end
        
        ram[0] = 32'h00008000; // Address 0 holds the MMIO target address
        ram[1] = 32'h00000041; // Address 4 holds the ASCII letter 'A'
    end

    // --- READ LOGIC (Combinational) ---
    assign read_data = ram[addr[31:2]];

    // --- WRITE LOGIC (Synchronous) ---
    always @(posedge clk) begin
        if (we) begin
            ram[addr[31:2]] <= write_data;
        end
    end

endmodule