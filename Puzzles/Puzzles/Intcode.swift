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
        case offsetRelativeBase = 9
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
            case .offsetRelativeBase:
                return 1
            }
        }
    }

    struct Instruction {

        struct Parameter {
            let value: Int
            let mode: ParameterMode
        }

        let opcode: Opcode
        let parameters: [Parameter]

        var length: Int {
            return 1 + opcode.numberOfParameters
        }
    }

    enum ProgramError: Error {
        case unknownOpcode
        case invalidParameter
    }

    enum ParameterMode: Int, RawRepresentable {
        case position = 0
        case immediate = 1
        case relative = 2
    }

    struct Memory {
        private(set) var initialMemory: [Int]
        private var sparseMemory: [Int: Int] = [:]

        init(_ memory: [Int]) {
            initialMemory = memory
        }

        subscript(index: Int) -> Int {
            get {
                if index < initialMemory.count {
                    return initialMemory[index]
                } else {
                    return sparseMemory[index, default: 0]
                }
            }
            set {
                if index < initialMemory.count {
                    initialMemory[index] = newValue
                } else {
                    sparseMemory[index] = newValue
                }
            }
        }
    }

    /// State
    private var pc = 0 // program counter
    private var rb = 0 // relative base
    private(set) var memory: Memory

    /// IO
    var input: InputBuffer = StdIn()
    var output: OutputBuffer = StdOut()
    private(set) var awaitingInput = false
    private let executableSize: Int

    init(memory: [Int]) {
        self.memory = Memory(memory)
        self.executableSize = memory.count
    }

    func pipeOutput(to: Intcode) {
        let pipe = Pipe()
        output = pipe
        to.input = pipe
    }

    func execute() throws {
        try runLoop()
    }

    private func runLoop() throws {
        while pc < executableSize {
            let instruction = try decodeInstruction()
            try  executeInstruction(instruction)
            if awaitingInput {
                break
            }
        }
    }

    private func decodeInstruction() throws -> Instruction {
        let rawOpcode = memory[pc]
        let intOpcode = rawOpcode % 100
        guard let opcode = Opcode(rawValue: intOpcode) else {
            throw ProgramError.unknownOpcode
        }
        var rawOptions = rawOpcode / 100
        let parameters = try (0..<opcode.numberOfParameters).map { i -> Instruction.Parameter in
            let rawParameterMode = rawOptions % 10
            guard let parameterMode = ParameterMode(rawValue: rawParameterMode) else {
                throw ProgramError.unknownOpcode
            }
            let value = memory[pc + 1 + i]
            rawOptions = rawOptions / 10
            return Instruction.Parameter(value: value, mode: parameterMode)
        }

        return Instruction(opcode: opcode, parameters: parameters)
    }

    private func read(_ param: Instruction.Parameter) -> Int {
        switch param.mode {
        case .position:
            return memory[param.value]
        case .immediate:
            return param.value
        case .relative:
            return memory[rb + param.value]
        }
    }

    private func write(_ param: Instruction.Parameter, value: Int) throws {
        switch param.mode {
        case .position:
            memory[param.value] = value
        case .immediate:
            throw ProgramError.invalidParameter
        case .relative:
            memory[rb + param.value] = value
        }
    }

    private func executeInstruction(_ instruction: Instruction) throws {
        var jumpPC: Int?
        let p = instruction.parameters
        switch instruction.opcode {
        case .add:
            let left = read(p[0])
            let right = read(p[1])
            try write(p[2], value: left + right)
        case .multiply:
            let left = read(p[0])
            let right = read(p[1])
            try write(p[2], value: left * right)
        case .halt:
            jumpPC = executableSize // effectively breaks the execution loop
        case .read:
            //print("Please provide an input value: ")
            guard input.hasData() else {
                awaitingInput = true
                return
            }
            let value = input.read()
            awaitingInput = false
            try write(p[0], value: value)
        case .write:
            let value = read(p[0])
            output.write(value: value)
        case .jumpIfTrue:
            let p1 = read(p[0])
            let p2 = read(p[1])
            if p1 != 0 {
                jumpPC = p2
            }
        case .jumpIfFalse:
            let p1 = read(p[0])
            let p2 = read(p[1])
            if p1 == 0 {
                jumpPC = p2
            }
        case .lessThan:
            let p1 = read(p[0])
            let p2 = read(p[1])
            try write(p[2], value: p1 < p2 ? 1 : 0)
        case .equals:
            let p1 = read(p[0])
            let p2 = read(p[1])
            try write(p[2], value: p1 == p2 ? 1 : 0)
        case .offsetRelativeBase:
            let offset = read(p[0])
            rb += offset
        }

        if let jumpPC = jumpPC {
            pc = jumpPC
        } else {
            pc += instruction.length
        }
    }
}

protocol InputBuffer {
    func read() -> Int
    func hasData() -> Bool
}

protocol OutputBuffer: class {
    func write(value: Int)
}

class StdIn: InputBuffer {
    func read() -> Int {
        Int(readLine()!)!
    }

    func hasData() -> Bool {
        return true
    }
}

class StdOut: OutputBuffer {
    func write(value: Int) {
        print(value)
    }
}

class Pipe: InputBuffer, OutputBuffer {
    private var data: [Int] = []

    func read() -> Int {
        return data.removeLast()
    }

    func write(value: Int) {
        data.insert(value, at: 0)
    }

    func hasData() -> Bool {
        !data.isEmpty
    }
}
