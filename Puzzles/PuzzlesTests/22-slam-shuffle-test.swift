import XCTest
@testable import Puzzles

class SlamShuffleTest: XCTestCase {

    let sample = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    func testDealIntoNewStack() {
        let sut = SlamShuffle.Command.dealIntoNewStack
        XCTAssertEqual(sut.apply(sample), sample.reversed())
    }

    func testCutPositiveCards() {
        let sut = SlamShuffle.Command.cutCards(3)
        XCTAssertEqual(sut.apply(sample), [3, 4, 5, 6, 7, 8, 9, 0, 1 , 2])
    }

    func testCutNegativeCards() {
        let sut = SlamShuffle.Command.cutCards(-3)
        XCTAssertEqual(sut.apply(sample), [7, 8, 9, 0, 1 , 2, 3, 4, 5, 6])
    }

    func testDealWithIncrement() {
        let sut = SlamShuffle.Command.dealWithIncrement(3)
        XCTAssertEqual(sut.apply(sample), [0, 7, 4, 1, 8, 5, 2, 9, 6, 3])
    }

    func testSample() {
        let commands: [SlamShuffle.Command] = [
            .dealIntoNewStack,
            .cutCards(-2),
            .dealWithIncrement(7),
            .cutCards(8),
            .cutCards(-4),
            .dealWithIncrement(7),
            .cutCards(3),
            .dealWithIncrement(9),
            .dealWithIncrement(3),
            .cutCards(-1)
        ]

        var deck = Array(0..<10)
        for c in commands {
            deck = c.apply(deck)
        }
        XCTAssertEqual(deck, [9, 2, 5, 8, 1, 4, 7, 0, 3, 6])
    }

    func testPartOne() {
        let scanner = SingleValueScanner<SlamShuffle.Command>(testCaseName: "22", separator: CharacterSet.newlines)
        let sut = SlamShuffle()
        XCTAssertEqual(sut.solvePartOne(input: scanner.parse()), 6326)
    }
}

extension SlamShuffle.Command: Scannable {
    static func parse(scanner: Scanner) -> SlamShuffle.Command? {
        let characterSet = CharacterSet.lowercaseLetters.union(CharacterSet.whitespaces)
        var command: NSString?
        var value: Int = 0

        guard scanner.scanCharacters(from: characterSet, into: &command) else { return nil }

        switch command?.trimmingCharacters(in: CharacterSet.whitespaces) {
        case "cut" where scanner.scanInt(&value):
            return .cutCards(value)
        case "deal with increment" where scanner.scanInt(&value):
            return .dealWithIncrement(value)
        case "deal into new stack":
            return .dealIntoNewStack
        default:
            return nil
        }
    }
}
