# Define RISC6 Registers (8 General Purpose Registers)
registers = {f'R{i}': 0 for i in range(8)}

# Define Memory (Simulating RAM with a dictionary)
memory = {}

# Flags for conditional jumps
flags = {'EQ': False}  # EQ flag for JE and JNE

# Instruction Set Implementation
def execute_instruction(instruction):
    parts = instruction.split()
    if not parts:
        return True  # Continue if the instruction is empty
    
    opcode = parts[0].upper()

    if opcode == 'LDI':  # Load Immediate: LDI R1, 10
        try:
            reg, value = parts[1].strip(','), int(parts[2])
            registers[reg] = value
        except (IndexError, ValueError):
            print(f"Error: Invalid LDI instruction format.")
            return True  # Continue execution
    
    elif opcode == 'LDR':  # Load from memory: LDR R1, R2
        try:
            reg, addr_reg = parts[1].strip(','), parts[2]
            registers[reg] = memory.get(registers[addr_reg], 0)
        except (IndexError, KeyError):
            print(f"Error: Invalid LDR instruction or memory access error.")
            return True  # Continue execution
    
    elif opcode == 'STR':  # Store to memory: STR R1, R2
        try:
            reg, addr_reg = parts[1].strip(','), parts[2]
            memory[registers[addr_reg]] = registers[reg]
        except (IndexError, KeyError):
            print(f"Error: Invalid STR instruction or memory access error.")
            return True  # Continue execution
    
    elif opcode == 'ADD':  # ADD R1, R2
        try:
            reg1, reg2 = parts[1].strip(','), parts[2]
            registers[reg1] += registers[reg2]
        except (IndexError, KeyError):
            print(f"Error: Invalid ADD instruction format or registers.")
            return True  # Continue execution
    
    elif opcode == 'SUB':  # SUB R1, R2
        try:
            reg1, reg2 = parts[1].strip(','), parts[2]
            registers[reg1] -= registers[reg2]
        except (IndexError, KeyError):
            print(f"Error: Invalid SUB instruction format or registers.")
            return True  # Continue execution
    
    elif opcode in ('AND', 'OR', 'XOR'):  # Logical Operations
        try:
            reg1, reg2 = parts[1].strip(','), parts[2]
            if opcode == 'AND':
                registers[reg1] &= registers[reg2]
            elif opcode == 'OR':
                registers[reg1] |= registers[reg2]
            elif opcode == 'XOR':
                registers[reg1] ^= registers[reg2]
        except (IndexError, KeyError):
            print(f"Error: Invalid {opcode} instruction format or registers.")
            return True  # Continue execution
    
    elif opcode == 'CMP':  # Compare R1, R2
        try:
            reg1, reg2 = parts[1].strip(','), parts[2]
            flags['EQ'] = (registers[reg1] == registers[reg2])
        except (IndexError, KeyError):
            print(f"Error: Invalid CMP instruction format or registers.")
            return True  # Continue execution
    
    elif opcode == 'JUMP':  # JUMP Address
        try:
            return int(parts[1]) - 1  # Adjust for automatic increment
        except (IndexError, ValueError):
            print(f"Error: Invalid JUMP instruction format.")
            return True  # Continue execution
    
    elif opcode == 'JE':  # Jump if Equal JE Address
        try:
            if flags['EQ']:
                return int(parts[1]) - 1
        except (IndexError, ValueError):
            print(f"Error: Invalid JE instruction format.")
            return True  # Continue execution
    
    elif opcode == 'JNE':  # Jump if Not Equal JNE Address
        try:
            if not flags['EQ']:
                return int(parts[1]) - 1
        except (IndexError, ValueError):
            print(f"Error: Invalid JNE instruction format.")
            return True  # Continue execution
    
    elif opcode == 'NOP':  # No Operation
        pass
    
    elif opcode == 'HLT':  # Halt Execution
        print("Execution Halted.")
        return False
    
    else:
        print(f"Unknown instruction: {instruction}")
    
    return True

# Interactive Mode
def interactive_mode():
    print("RISC6 Interactive Simulator. Type 'HLT' or 'exit' to stop.")
    while True:
        command = input("RISC6> ").strip()
        if command.lower() == "exit":
            break
        if command == "HLT":
            print("Execution Halted.")
            break
        
        if not execute_instruction(command):
            break
        
        print_state()

# Print Registers and Memory State
def print_state():
    print("Registers:", registers)
    print("Memory:", memory)
    print("Flags:", flags, "\n")

# Start Interactive Mode
if __name__ == "__main__":
    interactive_mode()
