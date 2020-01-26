import Foundation

class ASCIInterface: OutputBuffer {

    struct XY: Hashable {
        var x: Int
        var y: Int

        static var zero: XY {
            return XY(x: 0, y: 0)
        }

        var intersectionCoordinates: Set<XY> {
            return [self, XY(x: x, y: y - 1), XY(x: x, y: y - 2), XY(x: x - 1, y: y - 1), XY(x: x + 1, y: y - 1)]
        }
    }

    private var position: XY
    private var scaffold: Set<XY>
    private var rawMap: String
    private(set) var intersections: Set<XY>

    init() {
        position = .zero
        scaffold = []
        rawMap = ""
        intersections = []
    }

    func write(value: Int) {
        let c = Character(UnicodeScalar(value)!)
        rawMap.append(c)

        switch c {
        case "#":
            scaffold.insert(position)
            if scaffold.isSuperset(of: position.intersectionCoordinates) {
                let intersection = XY(x: position.x, y: position.y - 1)
                intersections.insert(intersection)
            }
            position.x += 1
        case "\n":
            position = XY(x: 0, y: position.y + 1)
        default:
            position.x += 1
            break
        }

    }

    func printMap() {
        print(rawMap)
    }
}

class SetAndForget {

    func solvePartOne(memory: [Int]) -> Int {
        let computer = Intcode(memory: memory)
        let interface = ASCIInterface()
        computer.output = interface
        try! computer.execute()
        interface.printMap()
        print(interface.intersections)

        return interface.intersections.reduce(0) { $0 + $1.x * $1.y }
    }
}
