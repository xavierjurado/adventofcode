import XCTest
@testable import Puzzles

class SensorBoostTest: XCTestCase {

    func testPartOne() {
        let scanner = SingleValueScanner<Int>(testCaseName: "09", separator: CharacterSet(charactersIn: ","))
        let program = scanner.parse()
        let sut = Intcode(memory: program)
        let outputSpy = TestOutput()
        sut.input = TestInput(values: [1])
        sut.output = outputSpy
        XCTAssertNoThrow(try sut.execute())
        XCTAssertEqual(outputSpy.values.count, 1)

        print(outputSpy.values[0])
    }
}
