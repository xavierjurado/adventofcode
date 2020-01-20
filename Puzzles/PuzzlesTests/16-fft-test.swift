import XCTest
@testable import Puzzles

class FlawedFrequencyTransmissionTest: XCTestCase {

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
}
