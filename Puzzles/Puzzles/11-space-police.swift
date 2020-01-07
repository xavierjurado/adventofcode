import Foundation

class PaintingRobotInterface: InputBuffer, OutputBuffer {

    enum Color: Int {
        case black = 0
        case white = 1
    }

    enum Rotation: Int {
        case left = 0 // left 90 degrees
        case right = 1 // right 90 degrees
    }

    enum Direction {
        case up
        case right
        case down
        case left

        func apply(_ r: Rotation) -> Direction {
            let clockwise: [Direction] = [.up, .right, .down, .left]
            var index = clockwise.firstIndex(of: self)!
            index += r == .left ? -1 : 1
            index += 4
            index = index % 4
            return clockwise[index]
        }
    }

    struct XY: Hashable {
        var x: Int
        var y: Int
    }

    private(set) var paintedPanels: [XY: Color] = [:]
    private var currentPosition: XY = XY(x: 0, y: 0)
    private var currentDirection: Direction = .up
    private var writeCount: Int = 0

    // Camera access: 0 if back, 1 if white
    func read() -> Int {
        let panelColor = paintedPanels[currentPosition, default: .black]
        return panelColor.rawValue
    }

    func hasData() -> Bool {
        return true
    }

    // 1. color to paint the panel
    // 2. direction the robot should turn
    func write(value: Int) {
        defer {
            writeCount += 1
        }
        if writeCount % 2 == 0 {
            let color = Color(rawValue: value)!
            paintedPanels[currentPosition] = color
        } else {
            let rotation = Rotation(rawValue: value)!
            currentDirection = currentDirection.apply(rotation)
            switch currentDirection {
            case .up:
                currentPosition.y += 1
            case .right:
                currentPosition.x += 1
            case .down:
                currentPosition.y -= 1
            case .left:
                currentPosition.x -= 1
            }
        }
    }
}

class SpacePolice {

    func solvePartOne(memory: [Int]) -> Int {
        let program = Intcode(memory: memory)
        let interface = PaintingRobotInterface()
        program.input = interface
        program.output = interface
        try? program.execute()

        return interface.paintedPanels.count
    }
}
