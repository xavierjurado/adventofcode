import XCTest
@testable import Puzzles

class ManyWorldInterpretationTest: XCTestCase {

    func testSample1() {
        let maze = """
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
        """

        let sut = ManyWorldInterpretation()
        XCTAssertEqual(sut.solvePartOne(maze: maze), 86)
    }

    func testSample2() {
        let maze = """
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
        """

        let sut = ManyWorldInterpretation()
        XCTAssertEqual(sut.solvePartOne(maze: maze), 132)
    }

    func testSample3() {
        let maze = """
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
        """

        let sut = ManyWorldInterpretation()
        XCTAssertEqual(sut.solvePartOne(maze: maze), 136)
    }

    func testSample4() {
        let maze = """
        ########################
        #@..............ac.GI.b#
        ###d#e#f################
        ###A#B#C################
        ###g#h#i################
        ########################
        """

        let sut = ManyWorldInterpretation()
        XCTAssertEqual(sut.solvePartOne(maze: maze), 81)
    }

    func testPartOne() {
        guard let inputFile = Bundle.current.url(forResource: "18", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let maze = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let sut = ManyWorldInterpretation()
        XCTAssertEqual(sut.solvePartOne(maze: maze), 3962)
    }
}
