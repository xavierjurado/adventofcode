import XCTest
@testable import Puzzles

class SpringDroidAdventureTest: XCTestCase {

    func testSolvePartOne() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "21", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SpringDroidAdventure()
        XCTAssertEqual(sut.solvePartOne(memory: program), 19357335)
    }

    func testSolvePartTwo() throws {
        let scanner = SingleValueScanner<Int>(testCaseName: "21", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SpringDroidAdventure()
        XCTAssertEqual(sut.solvePartTwo(memory: program), 1140147758)
    }
}
