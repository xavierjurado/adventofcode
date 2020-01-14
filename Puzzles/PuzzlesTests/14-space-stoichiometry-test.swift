import XCTest
@testable import Puzzles

class SpaceStoichiometryTest: XCTestCase {

    typealias Reaction = SpaceStoichiometry.Reaction
    typealias Chemical = SpaceStoichiometry.Chemical

    func testFirstExample() {
        let sut = SpaceStoichiometry()
        let reactions = [
            Reaction(input: [Chemical(id: "ORE", quantity: 10)], output: Chemical(id: "A", quantity: 10)),
            Reaction(input: [Chemical(id: "ORE", quantity: 1)], output: Chemical(id: "B", quantity: 1)),
            Reaction(input: [Chemical(id: "A", quantity: 7), Chemical(id: "B", quantity: 1)], output: Chemical(id: "C", quantity: 1)),
            Reaction(input: [Chemical(id: "A", quantity: 7), Chemical(id: "C", quantity: 1)], output: Chemical(id: "D", quantity: 1)),
            Reaction(input: [Chemical(id: "A", quantity: 7), Chemical(id: "D", quantity: 1)], output: Chemical(id: "E", quantity: 1)),
            Reaction(input: [Chemical(id: "A", quantity: 7), Chemical(id: "E", quantity: 1)], output: Chemical(id: "FUEL", quantity: 1)),
        ]

        XCTAssertEqual(sut.solvePartOne(reactions: reactions), 31)
    }

    func testSecondExample() {
        let sut = SpaceStoichiometry()
        let reactions = [
            Reaction(input: [Chemical(id: "ORE", quantity: 9)], output: Chemical(id: "A", quantity: 2)),
            Reaction(input: [Chemical(id: "ORE", quantity: 8)], output: Chemical(id: "B", quantity: 3)),
            Reaction(input: [Chemical(id: "ORE", quantity: 7)], output: Chemical(id: "C", quantity: 5)),
            Reaction(input: [Chemical(id: "A", quantity: 3), Chemical(id: "B", quantity: 4)], output: Chemical(id: "AB", quantity: 1)),
            Reaction(input: [Chemical(id: "B", quantity: 5), Chemical(id: "C", quantity: 7)], output: Chemical(id: "BC", quantity: 1)),
            Reaction(input: [Chemical(id: "C", quantity: 4), Chemical(id: "A", quantity: 1)], output: Chemical(id: "CA", quantity: 1)),
            Reaction(input: [Chemical(id: "AB", quantity: 2), Chemical(id: "BC", quantity: 3),  Chemical(id: "CA", quantity: 4)], output: Chemical(id: "FUEL", quantity: 1)),
        ]

        XCTAssertEqual(sut.solvePartOne(reactions: reactions), 165)
    }

    func testPartOne() {
        let characterSet = CharacterSet(charactersIn: " ,=>")
        let scanner = SingleValueScanner<Reaction>(testCaseName: "14", separator: characterSet)
        let reactions = scanner.parse()

        let sut = SpaceStoichiometry()
        XCTAssertEqual(sut.solvePartOne(reactions: reactions), 136771)
    }
}

extension SpaceStoichiometry.Reaction: Scannable {
    static func parse(scanner: Scanner) -> SpaceStoichiometry.Reaction? {
        let idCharacterSet = CharacterSet.uppercaseLetters
        var chemicals: [SpaceStoichiometry.Chemical] = []

        var identifier: NSString?
        var quantity: Int = 0

        while scanner.scanInt(&quantity), scanner.scanCharacters(from: idCharacterSet, into: &identifier), let id = identifier as String? {
            chemicals.append(SpaceStoichiometry.Chemical(id: id, quantity: quantity))
        }
        scanner.scanCharacters(from: .newlines, into: nil)

        guard let result = chemicals.popLast() else {
            return nil
        }

        return SpaceStoichiometry.Reaction(input: chemicals, output: result)
    }
}
