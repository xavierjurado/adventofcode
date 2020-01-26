import Foundation

class ASCIInterface: OutputBuffer, InputBuffer {

    struct XY: Hashable {
        var x: Int
        var y: Int

        static var zero: XY {
            return XY(x: 0, y: 0)
        }

        var intersectionCoordinates: Set<XY> {
            return [self, up, up.up, up.left, up.right]
        }

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
    }

    private var printPosition: XY
    private var scaffold: Set<XY>
    private var rawMap: String
    private(set) var intersections: Set<XY>

    init() {
        printPosition = .zero
        scaffold = []
        rawMap = ""
        intersections = []
    }

    func write(value: Int) {
        let c = Character(UnicodeScalar(value)!)
        rawMap.append(c)

        switch c {
        case "#":
            scaffold.insert(printPosition)
            if scaffold.isSuperset(of: printPosition.intersectionCoordinates) {
                intersections.insert(printPosition.up)
            }
            printPosition = printPosition.right
        case "\n":
            printPosition = XY(x: 0, y: printPosition.y + 1)
        default:
            printPosition = printPosition.right
            break
        }
    }

    func printMap() {
        print(rawMap)
    }

    func read() -> Int {
        return 0
    }

    func hasData() -> Bool {
        return true
    }

}

class SetAndForget {

    func solvePartOne(memory: [Int]) -> Int {
        let computer = Intcode(memory: memory)
        let interface = ASCIInterface()
        computer.output = interface
        try! computer.execute()
        interface.printMap()
        return interface.intersections.reduce(0) { $0 + $1.x * $1.y }
    }

    func solvePartTwo(memory: [Int]) -> Int {
        var memory = memory
        memory[0] = 2

        let computer = Intcode(memory: memory)
        let interface = ASCIInterface()
        computer.input = interface
        computer.output = interface
        try! computer.execute()

        return 0
    }
}
