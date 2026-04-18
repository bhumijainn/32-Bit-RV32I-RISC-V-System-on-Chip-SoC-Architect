`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:05:46
// Design Name: 
// Module Name: tb_data_mem
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

module tb_data_mem;

    // Inputs
    reg        clk;
    reg        we;
    reg [31:0] addr;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] read_data;

    // Instantiate the Data Memory
    data_mem uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        we = 0;
        addr = 0;
        write_data = 0;

        // Wait a few cycles
        #15;

        // TEST 1: Write the number 99 into memory address 12
        we = 1;                 // Turn on Write Enable
        addr = 32'd12;          // Address 12
        write_data = 32'd99;    // The data to save
        #10; // Wait for one clock cycle to let the data save

        // TEST 2: Read from memory address 12
        we = 0;                 // Turn off Write Enable
        // addr is still 12
        #10;
        $display("Read Address 12: %d (Expected: 99)", read_data);

        // TEST 3: Write the number 500 into memory address 40
        we = 1;
        addr = 32'd40;
        write_data = 32'd500;
        #10;

        // TEST 4: Read from memory address 40
        we = 0;
        addr = 32'd40;
        #10;
        $display("Read Address 40: %d (Expected: 500)", read_data);

        $finish;
    end

endmodule