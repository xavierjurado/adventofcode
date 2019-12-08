import Foundation

private extension Array where Element == CrossedWires.Path {

    typealias Point = CrossedWires.Point
    typealias Segment = CrossedWires.Segment

    func toLine() -> [Segment] {
        return reduce([]) { (acc, path) -> [Segment] in
            let distance = (acc.last?.distance ?? 0) + path.l
            let origin = acc.last?.point2 ?? .zero
            let newSegment: Segment
            switch path.d {
            case .up:
                newSegment = Segment(point1: origin, point2: Point(x: origin.x, y: origin.y + path.l), distance: distance)
            case .down:
                newSegment = Segment(point1: origin, point2: Point(x: origin.x, y: origin.y - path.l), distance: distance)
            case .left:
                newSegment = Segment(point1: origin, point2: Point(x: origin.x - path.l, y: origin.y), distance: distance)
            case .right:
                newSegment = Segment(point1: origin, point2: Point(x: origin.x + path.l, y: origin.y), distance: distance)
            }

            return acc + [newSegment]
        }
    }
}

class CrossedWires {

    enum Direction {
        case up
        case down
        case left
        case right
    }

    struct Path {
        let d: Direction
        let l: Int
    }

    struct Point {
        let x: Int
        let y: Int

        static var zero: Point = Point(x: 0, y: 0)

        func manhattanDistance(_ other: Point) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
    }

    struct Segment {
        let point1: Point
        let point2: Point
        let distance: Int

        var dx: ClosedRange<Int> {
            min(point1.x, point2.x)...max(point1.x, point2.x)
        }

        var dy: ClosedRange<Int> {
            min(point1.y, point2.y)...max(point1.y, point2.y)
        }

        func intersection(_ other: Segment) -> Point? {
            if point1.x == point2.x, other.dx ~= point1.x, dy ~= other.point1.y  {
                return Point(x: point1.x, y: other.point1.y)
            } else if point1.y == point2.y, other.dy ~= point1.y, dx ~= other.point1.x {
                return Point(x: other.point1.x, y: point1.y)
            }
            return nil
        }

        func distanceToIntersection( _ other: Segment) -> Int? {
            guard let x = intersection(other) else { return nil }
            return distanceToIntersectionPoint(x) + other.distanceToIntersectionPoint(x)
        }

        private func distanceToIntersectionPoint(_ point: Point) -> Int {
            // one of the abs() will always be zero
            distance - abs(point2.x - point.x) - abs(point2.y - point.y)
        }
    }

    func solve(firstWire: [Path], secondWire: [Path]) -> Int {
        let firstLine = firstWire.toLine()
        let secondLine = secondWire.toLine()

        // N^2 time, could be optimized to NlogN
        let candidates = firstLine.flatMap { segment1 -> [Point] in
            secondLine.compactMap { segment2 -> Point? in
                segment2.intersection(segment1)
            }
        }.sorted(by: { (point1, point2) -> Bool in
            return point1.manhattanDistance(.zero) < point2.manhattanDistance(.zero)
        }).dropFirst()

        return candidates.first!.manhattanDistance(.zero)
    }
}

extension CrossedWires {

    func solvePartTwo(firstWire: [Path], secondWire: [Path]) -> Int {
        let firstLine = firstWire.toLine()
        let secondLine = secondWire.toLine()

        let candidates = firstLine.flatMap { segment1 -> [Int] in
            secondLine.compactMap { segment2 -> Int? in
                segment2.distanceToIntersection(segment1)
            }
        }.sorted().dropFirst()

        return candidates.first!
    }
}
