import XCTest
@testable import Puzzles

extension MonitoringStation.Solution {
    init(x: Int, y: Int, n: Int) {
        let c = MonitoringStation.Coordinate(x: x, y: y)
        self.init(coordinate: c, asteroids: n)
    }
}

class MonitoringStationTest: XCTestCase {

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
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: map), MonitoringStation.Solution(x: 5, y: 8, n: 338))
    }

    func testBigExample() {
        let rawMap =
        """
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
        """
        let map = MonitoringStation.Map(raw: rawMap)
        let sut = MonitoringStation()
        XCTAssertEqual(sut.solvePartOne(asteroidsMap: map), MonitoringStation.Solution(x: 11, y: 13, n: 210))
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

}
