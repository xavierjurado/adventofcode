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

extension Array: LosslessStringConvertible where Element: LosslessStringConvertible {
    public init?(_ description: String) {
        self = description.trimmingCharacters(in: CharacterSet(charactersIn: "[] ")).split(separator: ",").compactMap { Element(String($0)) }
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
        let scanner = SingleValueScanner<Int>(testCaseName: "01-the-tirany-of-the-rocket-equation")
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(mass: input), 3366415)
        XCTAssertEqual(sut.solvePartTwo(mass: input), 5046772)
    }

    func testProgramAlarm() {
        let sut = Intcode()
        XCTAssertEqual(try? sut.execute(program: [1,9,10,3,2,3,11,0,99,30,40,50]), [3500,9,10,70,2,3,11,0,99,30,40,50])
    }

    func testProgramAlarmSolution() {
        let sut = ProgramAlarm()
        let scanner = SingleValueScanner<Int>(testCaseName: "02-program-alarm", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(program: input), 7210630)
        XCTAssertEqual(sut.solvePartTwo(program: input), 3892)
    }

    func testCrossedWires() {
        let sut = CrossedWires()
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R8,U5,L5,D3")!,
                                 secondWire: [CrossedWires.Path]("U7,R6,D4,L4")!), 6)
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R75,D30,R83,U83,L12,D49,R71,U7,L72")!,
                                 secondWire: [CrossedWires.Path]("U62,R66,U55,R34,D71,R55,D58,R83")!), 159)
        XCTAssertEqual(sut.solve(firstWire: [CrossedWires.Path]("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51")!,
                                 secondWire: [CrossedWires.Path]("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")!), 135)

        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R8,U5,L5,D3")!,
                                        secondWire: [CrossedWires.Path]("U7,R6,D4,L4")!), 30)
        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R75,D30,R83,U83,L12,D49,R71,U7,L72")!,
                                        secondWire: [CrossedWires.Path]("U62,R66,U55,R34,D71,R55,D58,R83")!), 610)
        XCTAssertEqual(sut.solvePartTwo(firstWire: [CrossedWires.Path]("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51")!,
                                        secondWire: [CrossedWires.Path]("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")!), 410)
    }

    func testCrossedWiresSolution() {
        let sut = CrossedWires()
        let scanner = SingleValueScanner<[CrossedWires.Path]>(testCaseName: "03-crossed-wires", separator: CharacterSet(charactersIn: ","))
        let input = scanner.parse()
        XCTAssertEqual(sut.solve(firstWire: input[0], secondWire: input[1]), 248)
        XCTAssertEqual(sut.solvePartTwo(firstWire: input[0], secondWire: input[1]), 28580)
    }

    func testSecureContainer() {
        let sut = SecureContainer()
        XCTAssertTrue(sut.meetsCriteria(122345))
        XCTAssertFalse(sut.meetsCriteria(123456))
        XCTAssertTrue(sut.meetsCriteria(111111))
        XCTAssertFalse(sut.meetsCriteria(223450))

        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(112233))
        XCTAssertFalse(sut.hasTwoAdgacentDigitsPartTwo(123444))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(111122))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(172233))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(172233))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(231331))
        XCTAssertFalse(sut.hasTwoAdgacentDigitsPartTwo(111111))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(111211))
        XCTAssertTrue(sut.hasTwoAdgacentDigitsPartTwo(112345))
    }

    func testSecureContainerSolution() {
        let sut = SecureContainer()
        XCTAssertEqual(sut.solve(), 931)
        XCTAssertEqual(sut.solvePartTwo(), 609)
    }
}
