import Foundation

class ProgramAlarm {

    let computer = Intcode()


    func solve(program: [Int]) -> Int {
        let program = computer.setup(program: program, noun: 12, verb: 2)
        try! computer.execute(program: program)

        return computer.memory[0]
    }

}

extension ProgramAlarm {
    func solvePartTwo(program: [Int]) -> Int {
        let expectedOutput = 19690720

        for noun in 0...99 {
            for verb in 0...99 {
                let program = computer.setup(program: program, noun: noun, verb: verb)
                do {
                    try computer.execute(program: program)
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
