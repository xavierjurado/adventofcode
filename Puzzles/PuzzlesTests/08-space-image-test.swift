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

    func testSolvePartTwo() {
        guard let inputFile = Bundle.current.url(forResource: "08", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let input = inputString.compactMap { Int("\($0)") }
        sut.solvePartTwo(data: input)

        /*
         Expected Output:

         1110 0 0110 0 1110 0 1111 0 1110 0
         1001 0 1001 0 1001 0 0001 0 1001 0
         1110 0 1000 0 1001 0 0010 0 1110 0
         1001 0 1000 0 1110 0 0100 0 1001 0
         1001 0 1001 0 1000 0 1000 0 1001 0
         1110 0 0110 0 1000 0 1111 0 1110 0
 
           B      C      P      Z      B
         */
    }
}
