import XCTest
@testable import Puzzles

class TractorBeamTest: XCTestCase {

    func testSolvePartOne() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "19", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = TractorBeam(memory: program)
        XCTAssertEqual(try sut.solvePartOne(), 112)
    }

    func testSolvePartTwo() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "19", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = TractorBeam(memory: program)
        XCTAssertEqual(try sut.solvePartTwo(), 18261982)
    }
}
