import XCTest
@testable import Puzzles

class SpacePoliceTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "11", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SpacePolice()
        XCTAssertEqual(sut.solvePartOne(memory: program), 2064)
    }
}
