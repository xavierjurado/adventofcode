import XCTest
@testable import Puzzles

class SpacePoliceTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "11", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SpacePolice()
        XCTAssertEqual(sut.solvePartOne(memory: program), 2064)
    }

    func testPartTwo() {
        let scanner = SingleValueScanner<Int>(testCaseName: "11", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = SpacePolice()
        let output = sut.solvePartTwo(memory: program)

        // LPZKLGHR upside-down:
        let expectedOutput = """
        0111101000011110100101111001110100101001000
        0100001000010000101001000010010100101010000
        0100001110001000101001000010110100101110000
        0100001001000100110001000010000111101001000
        0100001001000010101001000010010100101001000
        0100001110011110100101000001100100101110000
        """

        XCTAssertEqual(output, expectedOutput)
    }
}
