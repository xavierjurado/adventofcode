import Foundation

class ArcadeScreenInterface: OutputBuffer {

    struct XY: Hashable {
        var x: Int
        var y: Int
    }

    enum Tile: Int {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4
    }

    private var xPosition: Int = 0
    private var yPosition: Int = 0
    private var writeCount: Int = 0
    private var grid: [XY: Tile] = [:]

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
            let tile = Tile(rawValue: value)!
            grid[XY(x: xPosition, y: yPosition)] = tile
        default:
            fatalError()
        }
    }

    var blockTiles: Int {
        return grid.filter { $0.value == .block }.count
    }
}

class CarePackage {

    func solvePartOne(memory: [Int]) -> Int {
        let screen = ArcadeScreenInterface()
        let intcode = Intcode(memory: memory)
        intcode.output = screen
        try? intcode.execute()
        return screen.blockTiles
    }
}
