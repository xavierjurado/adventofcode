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
}
