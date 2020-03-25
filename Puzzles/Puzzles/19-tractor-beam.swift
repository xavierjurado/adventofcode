import Foundation

class TractorBeamInterface: InputBuffer, OutputBuffer {

    let area: Int
    var affectedPoints = 0
    var x = 0
    var y = 0
    var i = 0
    var finished = false

    init(area: Int) {
        self.area = area
    }

    func read() -> Int {
        defer { i += 1 }
        if i % 2 == 0 {
            return x
        } else {
            return y
        }
    }

    func hasData() -> Bool {
        !finished
    }

    func write(value: Int) {
        if value == 1 {
            affectedPoints += 1
        }
        computeNextState()
    }

    private func computeNextState() {
        guard x < area - 1 || y < area - 1 else {
            finished = true
            return
        }

        if x < area - 1 {
            x += 1
        } else {
            x = 0
            y += 1
        }
    }
}

class TractorBeam {

    func solvePartOne(memory: [Int]) throws -> Int {
        let computer = Intcode(memory: memory)
        let interface = TractorBeamInterface(area: 50)
        computer.input = interface
        computer.output = interface
        try computer.execute()
        return interface.affectedPoints
    }
}
