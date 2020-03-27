import XCTest
@testable import Puzzles

class DonutMazeTest: XCTestCase {

    func testSample1() {
        // Xcode trims ending whitespaces even inside string literals :/
        guard let inputFile = Bundle.current.url(forResource: "20-sample1", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = DonutMaze()
        XCTAssertEqual(sut.solvePartOne(input: maze), 23)
    }

    func testPartOne() {
        guard let inputFile = Bundle.current.url(forResource: "20", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = DonutMaze()
        XCTAssertEqual(sut.solvePartOne(input: maze), 644)
    }

    func testRecursiveSample1() {
        guard let inputFile = Bundle.current.url(forResource: "20-sample1", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = DonutMaze()
        XCTAssertEqual(sut.solvePartTwo(input: maze), 26)
    }

    func testRecursiveSample2() {
        guard let inputFile = Bundle.current.url(forResource: "20-sample2", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = DonutMaze()
        XCTAssertEqual(sut.solvePartTwo(input: maze), 396)
    }

    func testPartTwo() {
        guard let inputFile = Bundle.current.url(forResource: "20", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = DonutMaze()
        XCTAssertEqual(sut.solvePartTwo(input: maze), 7798)
    }
}
