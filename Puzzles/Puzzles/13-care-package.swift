import Foundation

class ArcadeInterface: OutputBuffer, InputBuffer {

    struct XY: Hashable {
        var x: Int
        var y: Int

        static var zero: XY {
            return XY(x: 0, y: 0)
        }
    }

    enum Tile: Int {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4

        func toString() -> String {
            switch self {
            case .empty:
                return " "
            case .wall:
                return "▓"
            case .block:
                return "░"
            case .paddle:
                return "█"
            case .ball:
                return "o"
            }
        }
    }

    enum JoystickPosition: Int {
        case neutral = 0
        case left = -1
        case right = 1
    }

    var joystick: JoystickPosition?
    private(set) var score: Int = 0
    private var xPosition: Int = 0
    private var yPosition: Int = 0
    private var writeCount: Int = 0
    private var grid: [XY: Tile] = [:]
    private(set) var ballPosition: XY = .zero
    private(set) var paddlePosition: XY = .zero

    func write(value: Int) {
        defer {
            writeCount += 1
        }

        switch writeCount % 3 {
        case 0:
            xPosition = value
        case 1:
            yPosition = value
        case 2:
            if xPosition == -1, yPosition == 0 {
                score = value
            } else {
                let tile = Tile(rawValue: value)!
                let position = XY(x: xPosition, y: yPosition)
                grid[position] = tile
                if tile == .paddle {
                    paddlePosition = position
                } else if tile == .ball {
                    ballPosition = position
                }
            }
        default:
            fatalError()
        }
    }

    var blockTiles: Int {
        return grid.filter { $0.value == .block }.count
    }

    func read() -> Int {
        let value = joystick!.rawValue
        joystick = nil
        return value
    }

    func hasData() -> Bool {
        return joystick != nil
    }

    func printGrid() {
        let maxX = grid.keys.max { $0.x < $1.x }.map { $0.x }!
        let maxY = grid.keys.max { $0.y < $1.y }.map { $0.y }!

        var y = 0
        while y < maxY {
            var line = ""
            var x = 0
            while x < maxX {
                let tile = grid[XY(x: x, y: y)]!
                line += tile.toString()
                x += 1
            }
            print(line)
            y += 1
        }
    }
}

class CarePackage {

    func solvePartOne(memory: [Int]) -> Int {
        let screen = ArcadeInterface()
        let intcode = Intcode(memory: memory)
        intcode.output = screen
        try? intcode.execute()
        screen.printGrid()
        return screen.blockTiles
    }

    func solvePartTwo(memory: [Int], debug: Bool = false) -> Int {
        var memory = memory
        memory[0] = 2
        let interface = ArcadeInterface()
        let intcode = Intcode(memory: memory)
        intcode.output = interface
        intcode.input = interface

        repeat {
            try? intcode.execute()
            if debug {
                interface.printGrid()
            }

            if interface.paddlePosition.x < interface.ballPosition.x {
                interface.joystick = .right
            } else if interface.paddlePosition.x > interface.ballPosition.x {
                interface.joystick = .left
            } else {
                interface.joystick = .neutral
            }
        } while intcode.awaitingInput

        return interface.score
    }
}
