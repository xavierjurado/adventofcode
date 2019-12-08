import Foundation

class ProgramAlarm {

    let computer = Intcode()


    func solve(program: [Int]) -> Int {
        let program = computer.setup(program: program, noun: 12, verb: 2)
        guard let memory = try? computer.execute(program: program) else {
            fatalError()
        }

        return memory[0]
    }

}

extension ProgramAlarm {
    func solvePartTwo(program: [Int]) -> Int {
        let expectedOutput = 19690720

        for noun in 0...99 {
            for verb in 0...99 {
                let program = computer.setup(program: program, noun: noun, verb: verb)
                guard let memory = try? computer.execute(program: program) else { continue }
                if memory[0] == expectedOutput {
                    return 100 * noun + verb
                }
            }
        }

        fatalError()
    }
}
