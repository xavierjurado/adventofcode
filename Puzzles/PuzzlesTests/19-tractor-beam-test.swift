import XCTest
@testable import Puzzles

class TractorBeamTest: XCTestCase {

    func testInterfaceExploresAllSpace() {
        let interface = TractorBeamInterface(area: 10)
        while interface.hasData() {
            _ = interface.read()
            _ = interface.read()
            interface.write(value: 0)
        }

        XCTAssertEqual(interface.x, 9)
        XCTAssertEqual(interface.y, 9)
        XCTAssertEqual(interface.i, 200)
    }

    func testSolvePartOne() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "19", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = TractorBeam()
        XCTAssertEqual(try sut.solvePartOne(memory: program), 0)
    }
}
