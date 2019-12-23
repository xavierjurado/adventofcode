import XCTest
@testable import Puzzles

class SpaceImageTest: XCTestCase {

    let sut = SpaceImage()

    func testSampleCases() {
        let data = [1,2,3,4,5,6,7,8,9,0,1,2]
        XCTAssertEqual(sut.solve(data: data, wide: 3, tall: 2), 1)
    }

    func testSolvePartOne() {
        guard let inputFile = Bundle.current.url(forResource: "08", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let input = inputString.compactMap { Int("\($0)") }
        XCTAssertEqual(sut.solve(data: input), 2413)
    }
}
