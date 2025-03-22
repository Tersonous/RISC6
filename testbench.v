`timescale 1ns / 1ps

module tb_risc6_core;

    // Inputs to the RISC6 core
    reg clk;
    reg rst;
    reg [31:0] instr;

    // Outputs from the RISC6 core
    wire [31:0] pc;
    wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7;
    wire halt;

    // Instantiate the RISC6 core module
    risc6_core uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .pc(pc),
        .R0(R0), .R1(R1), .R2(R2), .R3(R3),
        .R4(R4), .R5(R5), .R6(R6), .R7(R7),
        .halt(halt)
    );

    // Clock Generation: 10ns period
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns
    end

    // Test Vector: Apply instructions to the RISC6 core
    initial begin
        // Initialize the signals
        clk = 0;
        rst = 0;
        instr = 0;

        // Apply reset
        rst = 1;
        #10 rst = 0;

        // Test LDI (Load Immediate)
        instr = {6'b000000, 2'b00, 24'b000000000000000000000010}; // LDI R0, 2
        #10;

        instr = {6'b000000, 2'b01, 24'b000000000000000000000011}; // LDI R1, 3
        #10;

        // Test ADD (Add)
        instr = {6'b000001, 2'b10, 2'b01, 2'b00}; // ADD R2, R1, R0
        #10;

        // Test SUB (Subtract)
        instr = {6'b000010, 2'b11, 2'b10, 2'b00}; // SUB R3, R2, R0
        #10;

        // Test AND (Logical AND)
        instr = {6'b000011, 2'b00, 2'b01, 2'b10}; // AND R0, R1, R2
        #10;

        // Test STR (Store Register)
        instr = {6'b000111, 2'b01, 2'b10}; // STR R1, R2 (Store R1 value in memory[2])
        #10;

        // Test HALT (Halt Execution)
        instr = {6'b111111, 26'b0}; // HLT (Halt)
        #10;

        // Finish simulation after halt
        $finish;
    end

    // Monitor Outputs (for debugging)
    initial begin
        $monitor("Time: %0t | PC: %d | R0: %d | R1: %d | R2: %d | R3: %d | R4: %d | R5: %d | R6: %d | R7: %d | Halt: %d",
                 $time, pc, R0, R1, R2, R3, R4, R5, R6, R7, halt);
    end

endmodule
