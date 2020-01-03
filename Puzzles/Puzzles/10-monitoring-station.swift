import Foundation

class MonitoringStation {

    enum Content: Character {
        case empty = "."
        case asteroid = "#"
    }

    struct Map {
        private var matrix: [[Content]]

        var width: Int {
            return matrix[0].count
        }

        var height: Int {
            return matrix.count
        }

        init(matrix: [[Content]]) {
            self.matrix = matrix
        }

        init(raw: String) {
            let rows = raw.split(separator: "\n")
            self.matrix = rows.map { sub -> [Content] in
                sub.compactMap { (c) -> Content? in
                    Content(rawValue: c)
                }
            }
        }

        subscript(x: Int, y: Int) -> Content {
            return matrix[y][x]
        }
    }

    struct Coordinate: Hashable {
        let x: Int
        let y: Int

        func distance(to other: Coordinate) -> Double {
            let dx = (other.x - x)
            let dy = (other.y - y)
            return sqrt(Double(dx * dx + dy * dy))
        }

        func angle(to other: Coordinate) -> Degree {
            let dx = other.x - x
            let dy = other.y - y
            return Degree(dx: dx, dy: dy)
        }
    }

    struct Degree: Hashable {
        let d: Double

        init(d: Double) {
            self.d = d
        }

        init(dx: Int, dy: Int) {
            guard dx != 0 else {
                self.d = dy > 0 ? Double.pi / 2 : 3 * Double.pi / 2
                return
            }
            guard dy != 0 else {
                self.d = dx > 0 ? 0 : Double.pi
                return
            }
            let m = Double(dy)/Double(dx)
            let t = atan(m)

            switch (dx > 0, dy > 0) {
            case (true, true):   // 1Q, t > 0
                self.d = t
            case (false, true):  // 2Q, t < 0
                self.d = t + Double.pi
            case (false, false): // 3Q, t > 0
                self.d = t + Double.pi // 3 * Double.pi / 2 - t
            case (true, false):  // 4Q, t < 0
                self.d = t + 2 * Double.pi
            }
        }

        func clockwiseValue() -> Double {
            var value = d + Double.pi / 2
            if value < 0 {
                value += 2 * Double.pi
            }
            if value >= 2 * Double.pi {
                value -= 2 * Double.pi
            }
            return value
        }
    }

    struct Solution: Equatable {
        let coordinate: Coordinate
        let asteroids: Int
    }

    func solvePartOne(asteroidsMap: Map, debug: Bool = false) -> Solution {
        // Gather asteroids
        var asteroids: [Coordinate] = []
        for y in 0..<asteroidsMap.height {
            for x in 0..<asteroidsMap.width {
                if asteroidsMap[x, y] == .asteroid {
                    asteroids.append(Coordinate(x: x, y: y))
                }
            }
        }

        var bestCandidate = asteroids[0]
        var bestCandidateDetectedAsteroids = 0
        var debugMessage = Array(repeating: Array(repeating: ".", count: asteroidsMap.width), count: asteroidsMap.height)
        for candidate in asteroids {
            var hiddenDegrees: Set<Degree> = []
            var detectedAsteroids: [Coordinate] = []

            for a in asteroids.filter({ $0 != candidate }) {
                let d = candidate.angle(to: a)
                if hiddenDegrees.contains(d) {
                    continue
                } else {
                    detectedAsteroids.append(a)
                    hiddenDegrees.insert(d)
                }
            }

            if detectedAsteroids.count > bestCandidateDetectedAsteroids {
                bestCandidateDetectedAsteroids = detectedAsteroids.count
                bestCandidate = candidate
            }

            debugMessage[candidate.y][candidate.x] = "\(detectedAsteroids.count)"
        }

        if debug {
            debugMessage.forEach { print($0) }
        }

        return Solution(coordinate: bestCandidate, asteroids: bestCandidateDetectedAsteroids)
    }

    func solvePartTwo(asteroidsMap: Map, station: Coordinate, destroyedIndex: Int) -> Coordinate {
        var asteroids: [Coordinate] = []
        for y in 0..<asteroidsMap.height {
            for x in 0..<asteroidsMap.width {
                if asteroidsMap[x, y] == .asteroid {
                    asteroids.append(Coordinate(x: x, y: y))
                }
            }
        }

        var destroyedAsteroids: [Coordinate] = []

        while asteroids.count > 1 {
            var hiddenDegrees: Set<Degree> = []
            var detectedAsteroids: [Coordinate] = []
            let sortedAsteroids = asteroids.sorted(by: { station.distance(to: $0) < station.distance(to: $1) }).dropFirst()
            for a in sortedAsteroids {
                let d = station.angle(to: a)
                if hiddenDegrees.contains(d) {
                    continue
                } else {
                    detectedAsteroids.append(a)
                    hiddenDegrees.insert(d)
                    asteroids.removeAll { $0 == a }
                }
            }

            let asteroidsToBeDestroyed = detectedAsteroids.sorted { (c1, c2) -> Bool in
                let a1 = station.angle(to: c1)
                let a2 = station.angle(to: c2)
                return a1.clockwiseValue() < a2.clockwiseValue()
            }

            destroyedAsteroids.append(contentsOf: asteroidsToBeDestroyed)
        }

        return destroyedAsteroids[destroyedIndex - 1]
    }
}
