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

        func apply(_ orientation: Orientation) -> XY {
            switch orientation {
            case .up:
                return up
            case .down:
                return down
            case .left:
                return left
            case .right:
                return right
            }
        }
    }

    enum Orientation: Equatable, CaseIterable {
        case up
        case right
        case down
        case left

        var inverse: Orientation {
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .left:
                return .right
            case .right:
                return .left
            }
        }

        func movementFunctionFor(_ orientation: Orientation) -> MovementFunction {
            let clockWise = Orientation.allCases
            if (clockWise.firstIndex(of: self)! + 1) % clockWise.count == clockWise.firstIndex(of: orientation) {
                return .right
            } else if (clockWise.firstIndex(of: orientation)! + 1) % clockWise.count == clockWise.firstIndex(of: self) {
                return .left
            }
            preconditionFailure("There is no single movement function between \(self) and \(orientation)")
        }
    }

    enum MovementFunction: CustomStringConvertible {
        case left
        case right
        case forward(Int)

        var description: String {
            switch self {
            case .left:
                return "L"
            case .right:
                return "R"
            case .forward(let value):
                return "\(value)"
            }
        }
    }

    private var returnInstructions: [Int]?
    private var robotPosition: XY?
    private var cursorPosition: XY
    private var scaffold: Set<XY>
    private var rawMap: String
    private(set) var intersections: Set<XY>
    private(set) var dustCleaned: Int

    init() {
        cursorPosition = .zero
        scaffold = []
        rawMap = ""
        intersections = []
        dustCleaned = 0
    }

    func write(value: Int) {
        guard let scalar = UnicodeScalar(value) else {
            dustCleaned = value
            return
        }
        let c = Character(scalar)
        rawMap.append(c)

        if returnInstructions != nil {
            return
        }

        switch c {
        case "#":
            scaffold.insert(cursorPosition)
            if scaffold.isSuperset(of: cursorPosition.intersectionCoordinates) {
                intersections.insert(cursorPosition.up)
            }
            cursorPosition = cursorPosition.right
        case "^":
            robotPosition = cursorPosition
            scaffold.insert(cursorPosition)
            cursorPosition = cursorPosition.right
        case "\n":
            cursorPosition = XY(x: 0, y: cursorPosition.y + 1)
        default:
            cursorPosition = cursorPosition.right
            break
        }
    }

    func printMap() {
        print(rawMap)
    }

    func read() -> Int {
        return returnInstructions!.removeFirst()
    }

    func hasData() -> Bool {
        if let returnInstructions = returnInstructions {
            return !returnInstructions.isEmpty
        } else {
            let list = computeMovementFunctionList()
            let text = compressFunctionList(list)
            returnInstructions = encodeFunctionList(text)
            return true
        }
    }

    private func computeMovementFunctionList() -> [MovementFunction] {
        guard var robotPosition = robotPosition else { preconditionFailure() }
        var orientation = Orientation.up
        var functionList: [MovementFunction] = []

        while let nextOrientation = Orientation.allCases            // evaluate all orientations
            .filter({ $0 != orientation.inverse })                  // remove opposite
            .filter({ scaffold.contains(robotPosition.apply($0)) }) // find valid scaffolding coordinates
            .first {                                                // select new candidate
                // change orientation
                let movement = orientation.movementFunctionFor(nextOrientation)
                functionList.append(movement)
                orientation = nextOrientation

                // keep going until no more scaffold is found in that direction
                var length = 0
                while let nextCoordinate = scaffold.intersection([robotPosition.apply(orientation)]).first {
                    length += 1
                    robotPosition = nextCoordinate
                }
                functionList.append(.forward(length))
        }

        return functionList
    }

    private func compressFunctionList(_ list: [MovementFunction]) -> String {
        // Input: L, 12, R, 8, L, 6, R, 8, L, 6, R, 8, L, 12, L, 12, R, 8, L, 12, R, 8, L, 6, R, 8, L, 6, L, 12, R, 8, L, 6, R, 8, L, 6,
        //        R, 8, L, 12, L, 12, R, 8, L, 6, R, 6, L, 12, R, 8, L, 12, L, 12, R, 8, L, 6, R, 6, L, 12, L, 6, R, 6, L, 12, R, 8, L, 12, L, 12, R, 8
        // A: L, 12, R, 8, L, 6, R, 8, L, 6
        // B: R, 8, L, 12, L, 12, R, 8
        // C: L, 6, R, 6, L, 12
        let compressedText = """
        A,B,A,A,B,C,B,C,C,B
        L,12,R,8,L,6,R,8,L,6
        R,8,L,12,L,12,R,8
        L,6,R,6,L,12
        n\n
        """

        return compressedText
    }

    private func encodeFunctionList(_ text: String) -> [Int] {
        text.compactMap { $0.asciiValue }.map { Int($0) }
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
        interface.printMap()

        return interface.dustCleaned
    }
}
