class RISC_Nano:
    def __init__(self, memory_size=256):
        self.registers = [0] * 8  # 8 general-purpose registers (R0 - R7)
        self.memory = [0] * memory_size  # Byte-addressable memory
        self.pc = 0  # Program Counter

    def execute_command(self, command):
        parts = command.split()
        if len(parts) < 3:
            print("Invalid command format. Use: <instruction> <register> <value>")
            return

        instr, reg, value = parts[0].lower(), parts[1], parts[2]
        try:
            reg_idx = int(reg, 16)
            value = int(value)
        except ValueError:
            print("Invalid register or value format.")
            return

        if instr == "add":
            self.registers[reg_idx] += value
        elif instr == "sub":
            self.registers[reg_idx] -= value
        elif instr == "ldi":
            self.registers[reg_idx] = value
        else:
            print("Unknown instruction.")

    def dump_registers(self):
        """Print register values."""
        print("Registers:", self.registers)

# Interactive Mode
cpu = RISC_Nano()
while True:
    cmd = input("Enter instruction (e.g., 'add 0x4 10') or 'dump': ").strip()
    if cmd.lower() == 'dump':
        cpu.dump_registers()
    elif cmd.lower() == 'exit':
        break
    else:
        cpu.execute_command(cmd)
