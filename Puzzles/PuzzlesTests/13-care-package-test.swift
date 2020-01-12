import XCTest
@testable import Puzzles

class CarePackageTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "13", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = CarePackage()
        XCTAssertEqual(sut.solvePartOne(memory: program), 251)
    }
}
