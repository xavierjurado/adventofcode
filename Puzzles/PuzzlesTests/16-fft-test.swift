import XCTest
import OSLog
@testable import Puzzles

class FlawedFrequencyTransmissionTest: XCTestCase {

    func testComputePattern() {
        let sut = FlawedFrequencyTransmission()
        let p1 = sut.computerPattern(at: 6)
        let p2 = (0..<p1.count).map {sut.computerPattern(for: 6, index: $0) }
        XCTAssertEqual(p1, p2)
    }

    func testOnePhase() {
        let signal = [1,2,3,4,5,6,7,8]
        let sut = FlawedFrequencyTransmission()
        XCTAssertEqual(sut.solvePartOne(list: signal), [4,8,2,2,6,1,5,8])
    }

    func testMultiplePhases() {
        let signal = [1,2,3,4,5,6,7,8]
        let sut = FlawedFrequencyTransmission()
        XCTAssertEqual(sut.solvePartOne(list: signal, phases: 4), [0,1,0,2,9,4,9,8])
    }

    func testPartOne() {
        guard let inputFile = Bundle.current.url(forResource: "16", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let signal = inputString.compactMap{ Int(String($0)) }
        let sut = FlawedFrequencyTransmission()
        let output = sut.solvePartOne(list: signal, phases: 100)
        XCTAssertEqual(output.prefix(upTo: 8), [1, 1, 8, 3, 3, 1, 8, 8])
    }

    func testShorterPartTwo() {
        let signal = "03036732577212944063491565474664".compactMap {  Int("\($0)") }
        let sut = FlawedFrequencyTransmission()
        let output = sut.solvePartTwo(list: signal)
        XCTAssertEqual(output, [8,4,4,6,2,0,2,6])
    }

    func testPartTwo() {
        guard let inputFile = Bundle.current.url(forResource: "16", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let signal = inputString.compactMap{ Int(String($0)) }
        let sut = FlawedFrequencyTransmission()
        let output = sut.solvePartTwo(list: signal)
        XCTAssertEqual(output, [5,5,0,0,5,0,0,0])
    }
}
