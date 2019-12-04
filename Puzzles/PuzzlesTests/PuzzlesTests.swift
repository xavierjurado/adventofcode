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
    let separator: CharacterSet
    init(testCaseName: String, separator: CharacterSet = .whitespacesAndNewlines) {
        self.testCaseName = testCaseName
        self.separator = separator
    }

    func parse() -> [Int] {
        guard let inputFile = Bundle.current.url(forResource: testCaseName, withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let scanner = Scanner(string: inputString)
        scanner.charactersToBeSkipped = separator
        var x = 0
        var result: [Int] = []
        while scanner.scanInt(&x) {
            result.append(x)
        }

        return result
    }
}

class PuzzlesTests: XCTestCase {

    func testTheTiranyOfTheRocketEquation() {
        let sut = TheTiranyOfTheRocketEquation()
        XCTAssertEqual(sut.solve(mass: 12), 2)
        XCTAssertEqual(sut.solve(mass: 14), 2)
        XCTAssertEqual(sut.solve(mass: 1969), 654)
        XCTAssertEqual(sut.solve(mass: 100756), 33583)
        XCTAssertEqual(sut.solve(mass: [12, 14, 1969]), 2 + 2 + 654)
    }

    func testTheTiranyOfTheRocketEquationPartTwo() {
        let sut = TheTiranyOfTheRocketEquation()
        XCTAssertEqual(sut.solvePartTwo(mass: 14), 2)
        XCTAssertEqual(sut.solvePartTwo(mass: 1969), 966)
        XCTAssertEqual(sut.solvePartTwo(mass: 100756), 50346)
    }

    func testTheTiranyOfTheRocketEquationSolution() {
        let sut = TheTiranyOfTheRocketEquation()
        let scanner = SingleValueScanner(testCaseName: "01-the-tirany-of-the-rocket-equation")
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(mass: input), 3366415)
        XCTAssertEqual(sut.solvePartTwo(mass: input), 5046772)
    }

    func testProgramAlarm() {
        let sut = ProgramAlarm()
        XCTAssertEqual(sut.execute(program: [1,9,10,3,2,3,11,0,99,30,40,50]), [3500,9,10,70,2,3,11,0,99,30,40,50])
    }

    func testProgramAlarmSolution() {
        let sut = ProgramAlarm()
        let scanner = SingleValueScanner(testCaseName: "02-program-alarm", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(program: input), 7210630)
    }
}
