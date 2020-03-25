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

    let memory: [Int]

    init(memory: [Int]) {
        self.memory = memory
    }

    struct XY: Hashable {
        var x: Int
        var y: Int

        var left: XY {
            return XY(x: x - 1, y: y)
        }

        var right: XY {
            return XY(x: x + 1, y: y)
        }

        var up: XY {
            return XY(x: x, y: y - 1)
        }

        var down: XY {
            return XY(x: x, y: y + 1)
        }

        func down(times: Int) -> XY {
            return XY(x: x, y: y + times)
        }

        func left(times: Int) -> XY {
            return XY(x: x - times, y: y)
        }

    }

    func solvePartOne() throws -> Int {
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

    func solvePartTwo() throws -> Int {
        let shipSize = 99
        var topRightEdge = XY(x: 8, y: 9)
        var topLeftEdge: XY?

        while topLeftEdge == nil {
            topRightEdge = topRightEdge.down
            while isAffected(at: topRightEdge.right) {
                topRightEdge = topRightEdge.right
            }

            let bottomLeftCandidate = topRightEdge.down(times: shipSize).left(times: shipSize)
            guard bottomLeftCandidate.x >= 0 else { continue }
            if isAffected(at: bottomLeftCandidate) {
                precondition(isAffected(at: topRightEdge))
                topLeftEdge = topRightEdge.left(times: shipSize)
            }
        }

        return topLeftEdge!.x * 10_000 + topLeftEdge!.y
    }

    private func isAffected(at point: XY) -> Bool {
        let computer = Intcode(memory: memory)
        let interface = TractorBeamInterface()
        computer.input = interface
        computer.output = interface
        interface.x = point.x
        interface.y = point.y
        try! computer.execute()
        return interface.affected
    }
}
