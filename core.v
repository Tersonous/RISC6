module risc6_core (
    input clk,            // Clock signal
    input rst,            // Reset signal
    input [31:0] instr,  // Instruction input
    output reg [31:0] pc,   // Program Counter output
    output reg [31:0] R0, R1, R2, R3, R4, R5, R6, R7, // Individual Registers
    output reg halt      // Halt signal
);

    // Define memory (256 locations for simplicity)
    reg [31:0] memory [0:255];

    // Instruction opcodes (6-bit)
    parameter LDI = 6'b000000;   // Load Immediate
    parameter ADD = 6'b000001;   // Add
    parameter SUB = 6'b000010;   // Subtract
    parameter AND = 6'b000011;   // AND
    parameter OR  = 6'b000100;   // OR
    parameter XOR = 6'b000101;   // XOR
    parameter JMP = 6'b000110;   // Jump
    parameter STR = 6'b000111;   // Store Register
    parameter HLT = 6'b111111;   // Halt

    // Define the register file as individual registers
    reg [31:0] regfile [0:7];

    // Initialize registers and memory
    initial begin
        pc = 0;
        halt = 0;
        regfile[0] = 0; regfile[1] = 0; regfile[2] = 0; regfile[3] = 0;
        regfile[4] = 0; regfile[5] = 0; regfile[6] = 0; regfile[7] = 0;
    end

    // Fetch and decode the instruction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;    // Reset program counter
            halt <= 0;  // Reset halt signal
            regfile[0] <= 0; regfile[1] <= 0; regfile[2] <= 0; regfile[3] <= 0;
            regfile[4] <= 0; regfile[5] <= 0; regfile[6] <= 0; regfile[7] <= 0;
        end
        else begin
            case (instr[31:26])  // Check opcode (first 6 bits)
                LDI: begin  // Load Immediate (LDI R1, 10)
                    regfile[instr[25:24]] <= instr[23:0];  // Load the immediate value into the register
                end

                ADD: begin  // Add (ADD R1, R2)
                    regfile[instr[25:24]] <= regfile[instr[23:22]] + regfile[instr[21:20]];  // R1 = R2 + R3
                end

                SUB: begin  // Subtract (SUB R1, R2)
                    regfile[instr[25:24]] <= regfile[instr[23:22]] - regfile[instr[21:20]];  // R1 = R2 - R3
                end

                AND: begin  // AND (AND R1, R2)
                    regfile[instr[25:24]] <= regfile[instr[23:22]] & regfile[instr[21:20]];  // R1 = R2 & R3
                end

                OR: begin  // OR (OR R1, R2)
                    regfile[instr[25:24]] <= regfile[instr[23:22]] | regfile[instr[21:20]];  // R1 = R2 | R3
                end

                XOR: begin  // XOR (XOR R1, R2)
                    regfile[instr[25:24]] <= regfile[instr[23:22]] ^ regfile[instr[21:20]];  // R1 = R2 ^ R3
                end

                STR: begin  // Store Register (STR R1, R2)
                    memory[regfile[instr[23:22]]] <= regfile[instr[25:24]];  // Store value from R1 into memory at address in R2
                end

                JMP: begin  // Jump (JMP Address)
                    pc <= instr[23:0];  // Set program counter to the jump address
                end

                HLT: begin  // Halt Execution (HLT)
                    halt <= 1;  // Halt the execution
                end

                default: begin
                    halt <= 1;  // Invalid instruction - halt
                end
            endcase
            // Increment program counter after execution unless it's a jump
            if (instr[31:26] != JMP)
                pc <= pc + 1;
        end
    end

    // Assign individual registers to output ports in always block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
            R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 0;
        end else begin
            R0 <= regfile[0];
            R1 <= regfile[1];
            R2 <= regfile[2];
            R3 <= regfile[3];
            R4 <= regfile[4];
            R5 <= regfile[5];
            R6 <= regfile[6];
            R7 <= regfile[7];
        end
    end

endmodule
