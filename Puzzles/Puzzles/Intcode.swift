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

        var length: Int {
            return 1 + opcode.numberOfParameters
        }
    }

    enum ProgramError: Error {
        case unknownOpcode
        case outOfBounds
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
            guard let opcode = Opcode(rawValue: program[i]) else {
                throw ProgramError.unknownOpcode
            }

            let n = opcode.numberOfParameters
            guard i + n < program.count else {
                throw ProgramError.outOfBounds
            }

            let p = program[(i + 1)..<(i + 1 + n)]
            let instruction = Instruction(opcode: opcode, parameters: Array(p))
            mutate(program: &program, instruction: instruction)

            if opcode == .halt {
                break
            }

            i += instruction.length
        }
        return program
    }

    private func mutate(program: inout [Int], instruction: Instruction) {
        let p = instruction.parameters
        switch instruction.opcode {
        case .add:
            let leftIndex = p[0]
            let rightIndex = p[1]
            let resultIndex = p[2]
            let left = program[leftIndex]
            let right = program[rightIndex]
            program[resultIndex] = left + right
        case .multiply:
            let leftIndex = p[0]
            let rightIndex = p[1]
            let resultIndex = p[2]
            let left = program[leftIndex]
            let right = program[rightIndex]
            program[resultIndex] = left * right
        case .halt:
            break
        case .read:
            let address = p[0]
            guard let input = readLine(), let value = Int(input) else { fatalError() }
            program[address] = value
        case .write:
            let address = p[0]
            let value = program[address]
            print(value)
        }
    }

}

//protocol IntcodeInstruction {
//    func execute(memory: inout[Int])
//}
//
//struct AddInstruction {
//    let parameters: [Int]
//    func execute(memory: inout[Int]) {
//        let leftIndex = parameters[0]
//        let rightIndex = parameters[1]
//        let resultIndex = parameters[2]
//        let left = memory[leftIndex]
//        let right = memory[rightIndex]
//        memory[resultIndex] = left + right
//    }
//}
//
//struct ReadInputInstruction {
//
//}
