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

    func maximumDistanceFromLeak() -> Int? {
        let max = distTo.max { $0.value < $1.value }!
        let path = computeOptimalPath(from: max.key)
        printMap(path: path)
        return max.value
    }

    private var position: XY
    private var lastCommand : MovementCommand?
    private var commandQueue: [MovementCommand]
    private var map: [XY: Content]
    private var pathTo: [XY: XY]
    private var distTo: [XY: Int]
    private var leakLocation: XY?
    private var findFurthestDistanceFromLeak: Bool

    init(findFurthestDistanceFromLeak: Bool) {
        self.findFurthestDistanceFromLeak = findFurthestDistanceFromLeak
        position = .zero
        commandQueue = MovementCommand.allCases
        map = [.zero: .empty]
        distTo = [.zero: 0]
        pathTo = [:]
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
            let backtrack = map[position] != nil
            map[position] = .empty
            let alt = distTo[from]! + 1
            if alt < distTo[position, default: .max] {
                distTo[position] = alt
                pathTo[position] = from
            }
            if !backtrack {
                commandQueue = movementCommand(from: position) + [lastCommand.inverse()] + commandQueue
            }
        case .found:
            let from = position
            position = position.move(lastCommand)
            map[position] = .leak
            let alt = distTo[from]! + 1
            if alt < distTo[position, default: .max] {
                distTo[position] = alt
                pathTo[position] = from
            }
            commandQueue = [lastCommand.inverse()] + commandQueue
            leakLocation = position

            if findFurthestDistanceFromLeak {
                findFurthestDistanceFromLeak = false
                restartFromLeak(position)
            }
        }
    }

    // return commands to go to places I've never been or places I've found a better way to reach
    private func movementCommand(from p: XY) -> [MovementCommand] {
        let candidates: [MovementCommand] = MovementCommand.allCases
        return candidates.filter { command in
            let position = p.move(command)
            return map[position] != .wall && distTo[p]! + 1 < distTo[position, default: .max]
        }
    }

    private func computeOptimalPath(from p: XY) -> [XY] {
        var steps: [XY] = [p]
        while let from = pathTo[steps.last!] {
            steps.append(from)
        }
        return steps
    }

    private func restartFromLeak(_ leak: XY) {
        commandQueue = MovementCommand.allCases
        map = [leak: .leak]
        distTo = [leak: 0]
        pathTo = [:]
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
            var character = path.contains(xy) ? "o" : content.rawValue
            if xy == path.first {
                character = "F"
            }
            if xy == path.last {
                character = "T"
            }
            normalizedOutput[xy.y - minY][xy.x - minX] = character
        }

        let raw = normalizedOutput.map { $0.map(String.init).joined() }.joined(separator: "\n")
        print(raw)
    }
}

class OxygenSystem {

    func solvePartOne(memory: [Int]) -> Int {
        let computer = Intcode(memory: memory)
        let interface = RepairDroidInterface(findFurthestDistanceFromLeak: false)
        computer.input = interface
        computer.output = interface
        try! computer.execute()
        return interface.optimalPathLength()!
    }

    func solvePartTwo(memory: [Int]) -> Int {
        let computer = Intcode(memory: memory)
        let interface = RepairDroidInterface(findFurthestDistanceFromLeak: true)
        computer.input = interface
        computer.output = interface
        try! computer.execute()
        return interface.maximumDistanceFromLeak()!
    }
}
