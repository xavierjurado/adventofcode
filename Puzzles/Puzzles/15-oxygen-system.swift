import Foundation

class RepairDroidInterface: InputBuffer, OutputBuffer {

    enum MovementCommand: Int, CaseIterable {
        case north = 1
        case south = 2
        case west  = 3
        case east  = 4

        func inverse() -> MovementCommand {
            switch self {
            case .north:
                return .south
            case .south:
                return .north
            case .west:
                return .east
            case .east:
                return .west
            }
        }
    }

    enum StatusCode: Int {
        case wall = 0
        case moved = 1
        case found = 2
    }

    enum Content: Character {
        case wall = "#"
        case empty = "."
        case leak = "@"
    }

    struct XY: Hashable {
        var x: Int
        var y: Int

        static var zero: XY {
            return XY(x: 0, y: 0)
        }

        func move(_ command: MovementCommand) -> XY {
            switch command {
            case .north:
                return XY(x: x, y: y + 1)
            case .south:
                return XY(x: x, y: y - 1)
            case .west:
                return XY(x: x + 1, y: y)
            case .east:
                return XY(x: x - 1, y: y)
            }
        }
    }

    // Accept a movement command
    func read() -> Int {
        let first = commandQueue.removeFirst()
        lastCommand = first
        return first.rawValue
    }

    func hasData() -> Bool {
        return !commandQueue.isEmpty
    }

    // Report on the status of the repair droid
    func write(value: Int) {
        let status = StatusCode(rawValue: value)!
        computeNextMovementCommand(for: status)
    }

    func optimalPathLength() -> Int? {
        guard let leakLocation = leakLocation else { return nil }
        let optimalPath = computeOptimalPath(from: leakLocation)
        printMap(path: optimalPath)
        return distTo[leakLocation]
    }

    private var position: XY
    private var lastCommand : MovementCommand?
    private var commandQueue: [MovementCommand]
    private var map: [XY: Content]
    private var pathTo: [XY: XY] = [:]
    private var distTo: [XY: Int]
    private var leakLocation: XY?


    init() {
        position = .zero
        commandQueue = MovementCommand.allCases
        map = [.zero: .empty]
        distTo = [.zero: 0]
    }

    private func computeNextMovementCommand(for status: StatusCode) {
        guard let lastCommand = lastCommand else { fatalError() }
        switch status {
        case .wall:
            let triedPosition = position.move(lastCommand)
            map[triedPosition] = .wall
        case .moved:
            let from = position
            position = position.move(lastCommand)
            let backtracing = map[position] != nil
            if !backtracing {
                distTo[position] = distTo[from]! + 1
                pathTo[position] = from
                map[position] = .empty
                commandQueue = movementCommand(from: position) + [lastCommand.inverse()] + commandQueue
            }
        case .found:
            let from = position
            position = position.move(lastCommand)
            leakLocation = position
            distTo[position] = distTo[from]! + 1
            pathTo[position] = from
            map[position] = .leak
            commandQueue = [lastCommand.inverse()] + commandQueue
        }
    }

    // return commands to go to places I've never been or places I'm more
    private func movementCommand(from p: XY) -> [MovementCommand] {
        let candidates: [MovementCommand] = MovementCommand.allCases
        return candidates.filter { command in
            let position = p.move(command)
            return map[position] == nil
        }
    }

    private func computeOptimalPath(from p: XY) -> [XY] {
        var steps: [XY] = [p]
        while let from = pathTo[steps.last!] {
            steps.append(from)
        }
        return steps
    }

    private func printMap(path: [XY] = []) {
        var minX = Int.max
        var maxX = Int.min
        var minY = Int.max
        var maxY = Int.min

        for xy in map.keys {
            minX = min(xy.x, minX)
            maxX = max(xy.x, maxX)
            minY = min(xy.y, minY)
            maxY = max(xy.y, maxY)
        }

        let dy = abs(maxY - minY) + 1
        let dx = abs(maxX - minX) + 1

        var normalizedOutput: [[Character]] = Array(repeating: Array(repeating: "?", count: dx), count:dy)
        for (xy, content) in map {
            let character = path.contains(xy) ? "o" : content.rawValue
            normalizedOutput[xy.y - minY][xy.x - minX] = character
        }

        let raw = normalizedOutput.map { $0.map(String.init).joined() }.joined(separator: "\n")
        print(raw)
    }
}

class OxygenSystem {

    func solvePartOne(memory: [Int]) -> Int {
        let computer = Intcode(memory: memory)
        let interface = RepairDroidInterface()
        computer.input = interface
        computer.output = interface
        try! computer.execute()
        return interface.optimalPathLength()!
    }
}
