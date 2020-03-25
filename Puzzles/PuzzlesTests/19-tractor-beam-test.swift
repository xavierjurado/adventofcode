import XCTest
@testable import Puzzles

class TractorBeamTest: XCTestCase {

    func testSolvePartOne() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "19", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = TractorBeam()
        XCTAssertEqual(try sut.solvePartOne(memory: program), 112)
    }
}
