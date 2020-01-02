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

            struct Degree: Hashable {
                let d: Double

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
                    case (true, true):
                        self.d = t
                    case (true, false):
                        self.d = t + 2 * Double.pi
                    case (false, true):
                        self.d = t + Double.pi
                    case (false, false):
                        self.d = 3 * Double.pi / 2 - t
                    }
                }
            }

            var hiddenDegrees: Set<Degree> = []
            var detectedAsteroids: [Coordinate] = []

            for a in asteroids.filter({ $0 != candidate }) {
                let dx = a.x - candidate.x
                let dy = a.y - candidate.y
                let d = Degree(dx: dx, dy: dy)
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
}
