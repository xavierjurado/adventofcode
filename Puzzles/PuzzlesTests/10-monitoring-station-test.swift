import XCTest
@testable import Puzzles

extension MonitoringStation.Solution {
    init(x: Int, y: Int, n: Int) {
        let c = MonitoringStation.Coordinate(x: x, y: y)
        self.init(coordinate: c, asteroids: n)
    }
}

fileprivate func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}

fileprivate func rad2deg(_ number: Double) -> Double {
    return number * 180 / .pi
}

class MonitoringStationTest: XCTestCase {

    func testAngles() {
        XCTAssertEqual(MonitoringStation.Degree(dx:  1, dy:  1).d, Double.pi / 4)
        XCTAssertEqual(MonitoringStation.Degree(dx: -1, dy:  1).d, 3 * Double.pi / 4)
        XCTAssertEqual(MonitoringStation.Degree(dx: -1, dy: -1).d, 5 * Double.pi / 4)
        XCTAssertEqual(MonitoringStation.Degree(dx:  1, dy: -1).d, 7 * Double.pi / 4)
    }

    func testClockwiseAngle() {
        XCTAssertEqual(MonitoringStation.Degree(dx:  0, dy:  1).clockwiseValue(), Double.pi)
        XCTAssertEqual(MonitoringStation.Degree(dx:  1, dy:  0).clockwiseValue(), Double.pi / 2)
        XCTAssertEqual(MonitoringStation.Degree(dx:  0, dy: -1).clockwiseValue(), 0)
        XCTAssertEqual(MonitoringStation.Degree(dx: -1, dy:  0).clockwiseValue(), 3 * Double.pi / 2)
    }

    func testSortedClockwiseAngles() {
        let angles: [Double] = [270, 290, 359, 0, 20, 45, 80, 90, 110, 135, 170, 180, 190, 225, 260]
        let sortedAngles = angles.map(deg2rad).sorted { (c1, c2) -> Bool in
            let a1 = MonitoringStation.Degree(d: c1)
            let a2 = MonitoringStation.Degree(d: c2)
            return a1.clockwiseValue() < a2.clockwiseValue()
        }
        XCTAssertEqual(angles, sortedAngles.map(rad2deg))
    }

    func testSmallExample() {
        let rawMap =
        """
            .#..#
            .....
            #####
            ....#
            ...##
        """
        let map = MonitoringStation.Map(raw: rawMap)
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: map), MonitoringStation.Solution(x: 3, y: 4, n: 8))
    }

    func testMediumExample() {
        let rawMap =
        """
            ......#.#.
            #..#.#....
            ..#######.
            .#.#.###..
            .#..#.....
            ..#....#.#
            #..#....#.
            .##.#..###
            ##...#..#.
            .#....####
        """
        let map = MonitoringStation.Map(raw: rawMap)
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: map), MonitoringStation.Solution(x: 5, y: 8, n: 33))
    }

    let bigMap = MonitoringStation.Map(raw: """
        .#..##.###...#######
        ##.############..##.
        .#.######.########.#
        .###.#######.####.#.
        #####.##.#.##.###.##
        ..#####..#.#########
        ####################
        #.####....###.#.#.##
        ##.#################
        #####.##.###..####..
        ..######..##.#######
        ####.##.####...##..#
        .#####..#.######.###
        ##...#.##########...
        #.##########.#######
        .####.#.###.###.#.##
        ....##.##.###..#####
        .#.#.###########.###
        #.#.#.#####.####.###
        ###.##.####.##.#..##
    """)

    func testBigExample() {
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: bigMap), MonitoringStation.Solution(x: 11, y: 13, n: 210))
    }

    func testPartOne() {
        guard let inputFile = Bundle.current.url(forResource: "10", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let map = MonitoringStation.Map(raw: inputString)
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: map), MonitoringStation.Solution(x: 29, y: 28, n: 256))
    }

    func testPartTwoWithBigExample() {
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartTwo(asteroidsMap: bigMap,
                                        station: MonitoringStation.Coordinate(x: 11, y: 13),
                                        destroyedIndex: 200),
                       MonitoringStation.Coordinate(x: 8, y: 2))
    }

    func testPartTwo() {
        guard let inputFile = Bundle.current.url(forResource: "10", withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let map = MonitoringStation.Map(raw: inputString)
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartTwo(asteroidsMap: map,
                                        station: MonitoringStation.Coordinate(x: 29, y: 28),
                                        destroyedIndex: 200),
                       MonitoringStation.Coordinate(x: 17, y: 7))
    }

}
