import Foundation

class TractorBeamInterface: InputBuffer, OutputBuffer {
    var affected = false
    var x = 0
    var y = 0
    private var i = 0

    func read() -> Int {
        defer { i += 1 }
        if i % 2 == 0 {
            return x
        } else {
            return y
        }
    }

    func hasData() -> Bool {
        return true
    }

    func write(value: Int) {
        affected = value == 1
    }
}

class TractorBeam {

    func solvePartOne(memory: [Int]) throws -> Int {
        var affectedPoints = 0
        let area = 50
        for y in 0..<area {
            for x in 0..<area {
                let computer = Intcode(memory: memory)
                let interface = TractorBeamInterface()
                computer.input = interface
                computer.output = interface
                interface.x = x
                interface.y = y
                try computer.execute()
                if interface.affected {
                    affectedPoints += 1
                }
            }
        }
        return affectedPoints
    }
}
