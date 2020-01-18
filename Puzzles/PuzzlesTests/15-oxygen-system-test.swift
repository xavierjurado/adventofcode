import XCTest
@testable import Puzzles

class OxygenSystemTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "15", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = OxygenSystem()
        XCTAssertEqual(sut.solvePartOne(memory: program), 244)
    }

    func testPartTwo() {
        let scanner = SingleValueScanner<Int>(testCaseName: "15", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = OxygenSystem()
        XCTAssertEqual(sut.solvePartTwo(memory: program), 278)
    }
}
