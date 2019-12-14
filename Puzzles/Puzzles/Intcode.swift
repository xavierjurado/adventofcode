import Foundation

class Intcode {

    enum Opcode: Int, RawRepresentable {
        case add = 1
        case multiply = 2
        case read = 3
        case write = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
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
            case .jumpIfTrue:
                return 2
            case .jumpIfFalse:
                return 2
            case .lessThan:
                return 3
            case .equals:
                return 3
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

    typealias Input = () -> String
    typealias Output = (Int) -> Void

    /// State
    private var pc = 0
    private var memory: [Int] = []
    private var programInput: Input?
    private var programOutput: Output?

    func setup(program: [Int], noun: Int, verb: Int) -> [Int] {
        var program = program
        program[1] = noun
        program[2] = verb
        return program
    }

    func execute(program: [Int], input: @escaping Input = Intcode.standardInput, output: @escaping Output = Intcode.standardOutput) throws -> [Int] {
        memory = program
        pc = 0
        programInput = input
        programOutput = output

        while pc < memory.count {
            let instruction = try decodeInstruction()
            try  executeInstruction(instruction)
        }

        return memory
    }

    private func decodeInstruction() throws -> Instruction {
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

    private func executeInstruction(_ instruction: Instruction) throws {
        var jumpPC: Int?
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
            jumpPC = memory.count // effectively breaks the execution loop
        case .read:
            let address = instruction.rawParameters[0]
            print("Please provide an input value: ")
            let input = programInput!()
            guard let value = Int(input) else { fatalError() }
            memory[address] = value
        case .write:
            let value = p[0]
            programOutput?(value)
        case .jumpIfTrue:
            let p1 = p[0]
            let p2 = p[1]
            if p1 != 0 {
                jumpPC = p2
            }
        case .jumpIfFalse:
            let p1 = p[0]
            let p2 = p[1]
            if p1 == 0 {
                jumpPC = p2
            }
        case .lessThan:
            let p1 = p[0]
            let p2 = p[1]
            let address = instruction.rawParameters[2]
            memory[address] = p1 < p2 ? 1 : 0
        case .equals:
            let p1 = p[0]
            let p2 = p[1]
            let address = instruction.rawParameters[2]
            memory[address] = p1 == p2 ? 1 : 0
        }

        if let jumpPC = jumpPC {
            pc = jumpPC
        } else {
            pc += instruction.length
        }
    }
}

extension Intcode {

    static var standardInput: Input {
        return {
            readLine()!
        }
    }

    static var standardOutput: Output {
        return { value in
            print(value)
        }
    }
}
