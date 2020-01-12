import XCTest
@testable import Puzzles

class NBodyProblemTest: XCTestCase {

    func testMotion() {
        let sut = NBodyProblem()
        var bodies = [
            NBodyProblem.Body(position: NBodyProblem.XYZ(x: -1, y:   0, z:  2), velocity: .zero),
            NBodyProblem.Body(position: NBodyProblem.XYZ(x:  2, y: -10, z: -7), velocity: .zero),
            NBodyProblem.Body(position: NBodyProblem.XYZ(x:  4, y:  -8, z:  8), velocity: .zero),
            NBodyProblem.Body(position: NBodyProblem.XYZ(x:  3, y:   5, z: -1), velocity: .zero),
        ]

        bodies = sut.step(bodies: bodies)

        // After 1 step
        XCTAssertEqual(bodies[0].position, NBodyProblem.XYZ(x: 2, y: -1, z:  1))
        XCTAssertEqual(bodies[1].position, NBodyProblem.XYZ(x: 3, y: -7, z: -4))
        XCTAssertEqual(bodies[2].position, NBodyProblem.XYZ(x: 1, y: -7, z:  5))
        XCTAssertEqual(bodies[3].position, NBodyProblem.XYZ(x: 2, y:  2, z:  0))

        for _ in 0..<9 {
            bodies = sut.step(bodies: bodies)
        }

        // After 10 steps
        XCTAssertEqual(bodies[0].position, NBodyProblem.XYZ(x: 2, y:  1, z: -3))
        XCTAssertEqual(bodies[1].position, NBodyProblem.XYZ(x: 1, y: -8, z:  0))
        XCTAssertEqual(bodies[2].position, NBodyProblem.XYZ(x: 3, y: -6, z:  1))
        XCTAssertEqual(bodies[3].position, NBodyProblem.XYZ(x: 2, y:  0, z:  4))
    }

    func testPartOne() {
        let separators = CharacterSet(charactersIn: "<>xyz=, \n")
        let scanner = SingleValueScanner<NBodyProblem.Body>(testCaseName: "12", separator: separators)
        let data = scanner.parse()
        let sut = NBodyProblem()

        XCTAssertEqual(sut.solve(bodies: data), 13399)
    }

    func testPartTwo() {
        let separators = CharacterSet(charactersIn: "<>xyz=, \n")
        let scanner = SingleValueScanner<NBodyProblem.Body>(testCaseName: "12", separator: separators)
        let data = scanner.parse()
        let sut = NBodyProblem()

        XCTAssertEqual(sut.solvePartTwo(bodies: data), 312992287193064)
    }
}

extension NBodyProblem.Body: Scannable {
    static func parse(scanner: Scanner) -> NBodyProblem.Body? {
        var x = 0
        var y = 0
        var z = 0
        if scanner.scanInt(&x), scanner.scanInt(&y), scanner.scanInt(&z) {
            return NBodyProblem.Body(position: NBodyProblem.XYZ(x: x, y: y, z: z), velocity: .zero)
        } else {
            return nil
        }
    }
}
