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

    func testReverseDealIntoNewStack() {
        let sut = SlamShuffle.Command.dealIntoNewStack
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 9), 0)
    }

    func testReverseCutPositiveCards() {
        let sut = SlamShuffle.Command.cutCards(3)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 1), 4)
    }

    func testReverseCutNegativeCards() {
        let sut = SlamShuffle.Command.cutCards(-3)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 1), 8)
    }

    func testReverseDealWithIncrement() {
        // [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]
        let sut = SlamShuffle.Command.dealWithIncrement(3)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 7), 9)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 6), 2)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 5), 5)
        XCTAssertEqual(sut.inputIndex(deckSize: 10, outputIndex: 4), 8)

        // 0 3 6 9 2 5 8 1 4 7
        let sut2 = SlamShuffle.Command.dealWithIncrement(7)
        XCTAssertEqual(sut2.inputIndex(deckSize: 10, outputIndex: 7), 1)
        XCTAssertEqual(sut2.inputIndex(deckSize: 10, outputIndex: 6), 8)
        XCTAssertEqual(sut2.inputIndex(deckSize: 10, outputIndex: 5), 5)
        XCTAssertEqual(sut2.inputIndex(deckSize: 10, outputIndex: 4), 2)

        // [0, 1, 2, 3,  4, 5, 6,  7, 8, 9, 10, 11, 12]
        // [0, 9, 5, 1, 10, 6, 2, 11, 7, 3, 12,  8,  4]
        let sut3 = SlamShuffle.Command.dealWithIncrement(3)
        XCTAssertEqual(sut3.inputIndex(deckSize: 13, outputIndex: 7), 11)
        XCTAssertEqual(sut3.inputIndex(deckSize: 13, outputIndex: 6), 2)
        XCTAssertEqual(sut3.inputIndex(deckSize: 13, outputIndex: 5), 6)
        XCTAssertEqual(sut3.inputIndex(deckSize: 13, outputIndex: 4), 10)
    }

    func testReverseSample() {
        let commands: [SlamShuffle.Command] = [
            .dealIntoNewStack,
            .cutCards(-2),
            .dealWithIncrement(7), // bug!
            .cutCards(8),
            .cutCards(-4),
            .dealWithIncrement(7),
            .cutCards(3),
            .dealWithIncrement(9),
            .dealWithIncrement(3),
            .cutCards(-1)
        ]

        var deck = Array(0..<10)
        print(deck)
        for c in commands {
            deck = c.apply(deck)
            print(deck)
        }

        var index = 0
        for c in commands.reversed() {
            let initial = index
            index = c.inputIndex(deckSize: 10, outputIndex: index)
            print("\(initial) -> \(index)")
        }

        // [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
        XCTAssertEqual(index, 9)
    }

    func testPartTwo() {
        /*
        let scanner = SingleValueScanner<SlamShuffle.Command>(testCaseName: "22", separator: CharacterSet.newlines)
        let sut = SlamShuffle()
        // too low:   28422201821317
        // too high: 111095003418775
        XCTAssertEqual(sut.solvePartTwo(input: scanner.parse()), 6326)
         */
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
