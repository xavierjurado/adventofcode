import Foundation

class ProgramAlarm {
    func solve(program: [Int]) -> Int {
        let program = setup(program: program, noun: 12, verb: 2)
        let computer = Intcode(memory: program)
        try! computer.execute()

        return computer.memory[0]
    }

    func setup(program: [Int], noun: Int, verb: Int) -> [Int] {
        var program = program
        program[1] = noun
        program[2] = verb
        return program
    }

}

extension ProgramAlarm {
    func solvePartTwo(program: [Int]) -> Int {
        let expectedOutput = 19690720

        for noun in 0...99 {
            for verb in 0...99 {
                let program = setup(program: program, noun: noun, verb: verb)
                let computer = Intcode(memory: program)
                do {
                    try computer.execute()
                } catch {
                    continue
                }
                if computer.memory[0] == expectedOutput {
                    return 100 * noun + verb
                }
            }
        }

        fatalError()
    }
}
