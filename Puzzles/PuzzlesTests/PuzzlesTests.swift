//
//  PuzzlesTests.swift
//  PuzzlesTests
//
//  Created by Xavier Jurado on 03/12/2019.
//  Copyright © 2019 Xavier Jurado. All rights reserved.
//

import XCTest
@testable import Puzzles

extension Bundle {
    private class Token {}
    class var current: Bundle {
        return self.init(for: Token.self)
    }
}

class SingleValueScanner {
    let testCaseName: String
    init(testCaseName: String) {
        self.testCaseName = testCaseName
    }

    func parse() -> [Int] {
        guard let inputFile = Bundle.current.url(forResource: testCaseName, withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let scanner = Scanner(string: inputString)
        var x = 0
        var result: [Int] = []
        while scanner.scanInt(&x) {
            result.append(x)
        }

        return result
    }
}

class PuzzlesTests: XCTestCase {

    let sut = TheTiranyOfTheRocketEquation()

    func testTheTiranyOfTheRocketEquation() {
        XCTAssertEqual(sut.solve(mass: 12), 2)
        XCTAssertEqual(sut.solve(mass: 14), 2)
        XCTAssertEqual(sut.solve(mass: 1969), 654)
        XCTAssertEqual(sut.solve(mass: 100756), 33583)
        XCTAssertEqual(sut.solve(mass: [12, 14, 1969]), 2 + 2 + 654)
    }

    func testTheTiranyOfTheRocketEquationPartTwo() {
        XCTAssertEqual(sut.solvePartTwo(mass: 14), 2)
        XCTAssertEqual(sut.solvePartTwo(mass: 1969), 966)
        XCTAssertEqual(sut.solvePartTwo(mass: 100756), 50346)
    }

    func testTheTiranyOfTheRocketEquationSolution() {
        let scanner = SingleValueScanner(testCaseName: "01-the-tirany-of-the-rocket-equation")
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(mass: input), 3366415)
        XCTAssertEqual(sut.solvePartTwo(mass: input), 5046772)
    }
}
