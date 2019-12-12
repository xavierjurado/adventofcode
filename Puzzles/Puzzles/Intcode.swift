import Foundation

class Intcode {

    enum Opcode: Int, RawRepresentable {
        case add = 1
        case multiply = 2
        case read = 3
        case write = 4
        case halt = 99

        var numberOfParameters: Int {
            switch self {
            case .add, .multiply:
                return 3
            case .halt:
                return 0
            case .read:
                return 1
            case .write:
                return 1
            }
        }
    }

    struct Instruction {
        let opcode: Opcode
        let parameters: [Int]
        let rawParameters: [Int]

        var length: Int {
            return 1 + opcode.numberOfParameters
        }
    }

    enum ProgramError: Error {
        case unknownOpcode
        case outOfBounds
    }

    enum ParameterMode: Int, RawRepresentable {
        case position = 0
        case immediate = 1
    }

    func setup(program: [Int], noun: Int, verb: Int) -> [Int] {
        var program = program
        program[1] = noun
        program[2] = verb
        return program
    }

    func execute(program: [Int]) throws -> [Int] {
        var program = program
        var i = 0
        while i < program.count {
            let instruction = try decodeInstruction(memory: program, pc: i)
            try  executeInstruction(instruction, memory: &program)

            if instruction.opcode == .halt {
                break
            }

            i += instruction.length
        }
        return program
    }

    func decodeInstruction(memory: [Int], pc: Int) throws -> Instruction {
        let rawOpcode = memory[pc]
        let intOpcode = rawOpcode % 100
        guard let opcode = Opcode(rawValue: intOpcode) else {
            throw ProgramError.unknownOpcode
        }
        var rawOptions = rawOpcode / 100
        var options = Array(repeating: ParameterMode.position, count: opcode.numberOfParameters)
        var i = 0
        while rawOptions > 0 {
            let rawParameterMode = rawOptions % 10
            guard let parameterMode = ParameterMode(rawValue: rawParameterMode) else {
                throw ProgramError.unknownOpcode
            }
            options[i] = parameterMode
            rawOptions = rawOptions / 10
            i += 1
        }

        guard pc + opcode.numberOfParameters < memory.count else {
            throw ProgramError.outOfBounds
        }

        let rawParameters = memory[(pc + 1)..<(pc + 1 + opcode.numberOfParameters)]
        let parameters = zip(rawParameters, options).map { value, mode -> Int in
            switch mode {
            case .position:
                return memory[value]
            case .immediate:
                return value
            }
        }

        return Instruction(opcode: opcode, parameters: parameters, rawParameters: Array(rawParameters))
    }

    private func executeInstruction(_ instruction: Instruction, memory: inout [Int]) throws {
        let p = instruction.parameters
        switch instruction.opcode {
        case .add:
            let left = p[0]
            let right = p[1]
            let resultAddress = instruction.rawParameters[2]
            memory[resultAddress] = left + right
        case .multiply:
            let left = p[0]
            let right = p[1]
            let resultAddress = instruction.rawParameters[2]
            memory[resultAddress] = left * right
        case .halt:
            break
        case .read:
            let address = instruction.rawParameters[0]
            print("Please provide an input value: ")
            guard let input = readLine(), let value = Int(input) else { fatalError() }
            memory[address] = value
        case .write:
            let value = p[0]
            print(value)
        }
    }
}
