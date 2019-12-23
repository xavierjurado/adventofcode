import XCTest
@testable import Puzzles

extension Bundle {
    private class Token {}
    class var current: Bundle {
        return self.init(for: Token.self)
    }
}

extension Array: LosslessStringConvertible where Element: LosslessStringConvertible {
    public init?(_ description: String) {
        self = description.trimmingCharacters(in: CharacterSet(charactersIn: "[] ")).split(separator: ",").compactMap { Element(String($0)) }
    }
}

class TestInput: InputBuffer {
    var values: [Int] = []

    init(values: [Int]) {
        self.values = values
    }

    func read() -> Int {
        values.removeFirst()
    }

    func hasData() -> Bool {
        return !values.isEmpty
    }
}

class TestOutput: OutputBuffer {

    var values: [Int] = []

    func write(value: Int) {
        values.append(value)
    }
}

class PassthroughOutput: OutputBuffer {
    var lastValue: Int?
    var destination: OutputBuffer

    init(destination: OutputBuffer) {
        self.destination = destination
    }

    func write(value: Int) {
        lastValue = value
        destination.write(value: value)
    }
}


class PuzzlesTests: XCTestCase {

    func testTheTiranyOfTheRocketEquation() {
        let sut = TheTiranyOfTheRocketEquation()
        XCTAssertEqual(sut.solve(mass: 12), 2)
        XCTAssertEqual(sut.solve(mass: 14), 2)
        XCTAssertEqual(sut.solve(mass: 1969), 654)
        XCTAssertEqual(sut.solve(mass: 100756), 33583)
        XCTAssertEqual(sut.solve(mass: [12, 14, 1969]), 2 + 2 + 654)
    }

    func testTheTiranyOfTheRocketEquationPartTwo() {
        let sut = TheTiranyOfTheRocketEquation()
        XCTAssertEqual(sut.solvePartTwo(mass: 14), 2)
        XCTAssertEqual(sut.solvePartTwo(mass: 1969), 966)
        XCTAssertEqual(sut.solvePartTwo(mass: 100756), 50346)
    }

    func testTheTiranyOfTheRocketEquationSolution() {
        let sut = TheTiranyOfTheRocketEquation()
        let scanner = SingleValueScanner<Int>(testCaseName: "01-the-tirany-of-the-rocket-equation")
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(mass: input), 3366415)
        XCTAssertEqual(sut.solvePartTwo(mass: input), 5046772)
    }

    func testProgramAlarm() {
        let sut = Intcode(memory: [1,9,10,3,2,3,11,0,99,30,40,50])
        XCTAssertNoThrow(try sut.execute())
        XCTAssertEqual(sut.memory, [3500,9,10,70,2,3,11,0,99,30,40,50])
    }

    func testProgramAlarmSolution() {
        let sut = ProgramAlarm()
        let scanner = SingleValueScanner<Int>(testCaseName: "02-program-alarm", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(program: input), 7210630)
        XCTAssertEqual(sut.solvePartTwo(program: input), 3892)
    }

    func testCrossedWires() {
        let sut = CrossedWires()
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R8,U5,L5,D3")!,
                                 secondWire: [CrossedWires.Path]("U7,R6,D4,L4")!), 6)
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R75,D30,R83,U83,L12,D49,R71,U7,L72")!,
                                 secondWire: [CrossedWires.Path]("U62,R66,U55,R34,D71,R55,D58,R83")!), 159)
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51")!,
                                 secondWire: [CrossedWires.Path]("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")!), 135)

        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R8,U5,L5,D3")!,
                                        secondWire: [CrossedWires.Path]("U7,R6,D4,L4")!), 30)
        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R75,D30,R83,U83,L12,D49,R71,U7,L72")!,
                                        secondWire: [CrossedWires.Path]("U62,R66,U55,R34,D71,R55,D58,R83")!), 610)
        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51")!,
                                        secondWire: [CrossedWires.Path]("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")!), 410)
    }

    func testCrossedWiresSolution() {
        let sut = CrossedWires()
        let scanner = SingleValueScanner<[CrossedWires.Path]>(testCaseName: "03-crossed-wires", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(firstWire: input[0], secondWire: input[1]), 248)
        XCTAssertEqual(sut.solvePartTwo(firstWire: input[0], secondWire: input[1]), 28580)
    }

    func testSecureContainer() {
        let sut = SecureContainer()
        XCTAssertTrue(sut.meetsCriteria(122345))
        XCTAssertFalse(sut.meetsCriteria(123456))
        XCTAssertTrue(sut.meetsCriteria(111111))
        XCTAssertFalse(sut.meetsCriteria(223450))

        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(112233))
        XCTAssertFalse(sut.hasTwoAdgacentDigitsPartTwo(123444))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(111122))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(172233))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(172233))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(231331))
        XCTAssertFalse(sut.hasTwoAdgacentDigitsPartTwo(111111))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(111211))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(112345))
    }

    func testSecureContainerSolution() {
        let sut = SecureContainer()
        XCTAssertEqual(sut.solve(), 931)
        XCTAssertEqual(sut.solvePartTwo(), 609)
    }

    func testSunnyWithAChanceOfAsteroids() {
        var sut = Intcode(memory: [1002,4,3,4,33])
        XCTAssertNoThrow(try sut.execute())
        XCTAssertEqual(sut.memory, [1002,4,3,4,99])
        sut = Intcode(memory: [1101,100,-1,4,0])
        XCTAssertNoThrow(try sut.execute())
        XCTAssertEqual(sut.memory, [1101,100,-1,4,99])

        let programInput = TestInput(values: [7])
        let programOutput = TestOutput()
        let program = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
        1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
        999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        sut = Intcode(memory: program)
        sut.input = programInput
        sut.output = programOutput
        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 999)

        programInput.values = [8]
        sut = Intcode(memory: program)
        sut.input = programInput
        sut.output = programOutput
        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 1000)

        programInput.values = [9]
        sut = Intcode(memory: program)
        sut.input = programInput
        sut.output = programOutput
        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 1001)

        let program2 = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
        programInput.values = [0]
        sut = Intcode(memory: program2)
        sut.input = programInput
        sut.output = programOutput
        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 0)
    }

    func testSunnyWithAChanceOfAsteroidsSolution() {
        let scanner = SingleValueScanner<Int>(testCaseName: "05-sunny-with-a-chance-of-asteroids", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        let programInput = TestInput(values: [1])
        let programOutput = TestOutput()
        var sut = Intcode(memory: input)
        sut.input = programInput
        sut.output = programOutput

        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 5821753)

        sut = Intcode(memory: input)
        sut.input = TestInput(values: [5])
        sut.output = programOutput
        try? sut.execute()
        XCTAssertEqual(programOutput.values.last, 11956381)
    }

    func testUniversalOrbitMapPartOne() {
        let sut = UniversalOrbitMap()
        let map = [UniversalOrbitMap.OrbitalRelationship]("COM)B,B)C,C)D,D)E,E)F,B)G,G)H,D)I,E)J,J)K,K)L")!
        XCTAssertEqual(sut.solvePartOne(map: map), 42)

        let scanner = SingleValueScanner<UniversalOrbitMap.OrbitalRelationship>(testCaseName: "06")
        let input = scanner.parse()
        XCTAssertEqual(sut.solvePartOne(map: input), 308790)
    }

    func testUniversalOrbitMapPartTwo() {
        let sut = UniversalOrbitMap()
        let scanner = SingleValueScanner<UniversalOrbitMap.OrbitalRelationship>(testCaseName: "06")
        let input = scanner.parse()
        XCTAssertEqual(sut.solvePartTwo(map: input), 472)
    }

    func testAmplificationCircuit() {
        let phasePermutations = [0, 1, 2, 3, 4].allPermutations()
        let scanner = SingleValueScanner<Int>(testCaseName: "07", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        var bestPermutationOutput = 0


        for phaseValues in phasePermutations {
            let computers = (1...5).map { _ in Intcode(memory: program) }
            let systemOutput = TestOutput()
            computers[0].input = TestInput(values: [phaseValues[0], 0])

            for i in 0..<4 {
                let c1 = computers[i]
                let c2 = computers[i + 1]
                let phase = phaseValues[i + 1]
                c1.pipeOutput(to: c2)
                c1.output.write(value: phase)
                try? c1.execute()
            }

            computers.last?.output = systemOutput
            try? computers.last?.execute()

            if systemOutput.values[0] > bestPermutationOutput {
                bestPermutationOutput = systemOutput.values[0]
            }

        }

        XCTAssertEqual(bestPermutationOutput, 117312)
    }

    func testAmplificationCircuitPartTwo() {
        let phasePermutations = [5, 6, 7, 8, 9].allPermutations()
        let scanner = SingleValueScanner<Int>(testCaseName: "07", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        var bestPermutationOutput = 0

        for phaseValues in phasePermutations {
            let computers = (1...5).map { _ in Intcode(memory: program) }

            // Bind all computers together
            for i in 0..<4 {
                let c1 = computers[i]
                let c2 = computers[i + 1]
                let phase = phaseValues[i + 1]
                c1.pipeOutput(to: c2)
                c1.output.write(value: phase)
            }
            computers.last?.pipeOutput(to: computers[0])
            computers.last?.output.write(value: phaseValues[0])
            computers.last?.output.write(value: 0)
            let systemOutput = PassthroughOutput(destination: computers.last!.output)
            computers.last?.output = systemOutput

            // Execute them all
            var executionComplete = false
            while !executionComplete {
                executionComplete = true
                for c in computers {
                    try! c.execute()
                    executionComplete = executionComplete && !c.awaitingInput
                }
            }

            if systemOutput.lastValue! > bestPermutationOutput {
                bestPermutationOutput = systemOutput.lastValue!
            }
        }

        XCTAssertEqual(bestPermutationOutput, 1336480)
    }
}

extension Array {
    func allPermutations() -> Array<Array> {
        guard count > 1 else { return [self] }
        var result: Array<Array> = []
        for i in startIndex..<endIndex {
            let value = self[i]
            var a = self
            a.remove(at: i)
            for p in a.allPermutations() {
                result.append([value] + p)
            }
        }

        return result
    }
}
