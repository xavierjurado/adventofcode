import XCTest
@testable import Puzzles

class SetAndForgetTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "17", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SetAndForget()
        XCTAssertEqual(sut.solvePartOne(memory: program), 5068)
    }
}
