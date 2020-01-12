import Foundation

class NBodyProblem {
    struct XYZ: Hashable {
        var x: Int
        var y: Int
        var z: Int

        static var zero: XYZ {
            return XYZ(x: 0, y: 0, z: 0)
        }
    }

    struct Body: Hashable, CustomStringConvertible {
        var position: XYZ
        var velocity: XYZ

        mutating func applyGravity(from: Body) {
            let dx = position.x - from.position.x
            let dy = position.y - from.position.y
            let dz = position.z - from.position.z

            if dx < 0 { velocity.x += 1 }
            if dx > 0 { velocity.x -= 1 }
            if dy < 0 { velocity.y += 1 }
            if dy > 0 { velocity.y -= 1 }
            if dz < 0 { velocity.z += 1 }
            if dz > 0 { velocity.z -= 1 }
        }

        mutating func applyVelocity() {
            position.x += velocity.x
            position.y += velocity.y
            position.z += velocity.z
        }

        var potentialEnergy: Int {
            abs(position.x) + abs(position.y) + abs(position.z)
        }

        var kineticEnergy: Int {
            abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
        }

        var energy: Int {
            potentialEnergy * kineticEnergy
        }

        var description: String {
            return "pos=<x= \(position.x), y= \(position.y), z= \(position.z)>, vel=<x= \(velocity.x), y= \(velocity.y), z= \(velocity.z)>"
        }
    }

    func updateVelocity(bodies: [Body]) -> [Body] {
        guard bodies.count >= 2 else { return bodies }
        var bodies = bodies
        var first = bodies.removeFirst()
        for i in 0..<bodies.count {
            first.applyGravity(from: bodies[i])
            bodies[i].applyGravity(from: first)
        }

        return [first] + updateVelocity(bodies: bodies)
    }

    func updatePosition(bodies: [Body]) -> [Body] {
        var bodies = bodies
        for i in 0..<bodies.count {
            bodies[i].applyVelocity()
        }
        return bodies
    }

    func step(bodies: [Body]) -> [Body] {
        var bodies = bodies
        bodies = updateVelocity(bodies: bodies)
        bodies = updatePosition(bodies: bodies)
        return bodies
    }

    func solve(bodies: [Body]) -> Int {

        var bodies = bodies
        for _ in 0..<1000 {
            bodies = step(bodies: bodies)
        }

        let totalEnergy = bodies.map { $0.energy }.reduce(0, +)

        return totalEnergy
    }

    func solvePartTwo(bodies: [Body]) -> Int {
        var xSnapshots: Set<[Int]> = []
        var ySnapshots: Set<[Int]> = []
        var zSnapshots: Set<[Int]> = []
        var xPeriod: Int?
        var yPeriod: Int?
        var zPeriod: Int?

        var bodies = bodies
        var stepCount = 0
        while xPeriod == nil || yPeriod == nil || zPeriod == nil {
            if xPeriod == nil {
                let xSnapshot = bodies.xSnapshot()
                if xSnapshots.contains(xSnapshot) {
                    xPeriod = stepCount
                } else {
                    xSnapshots.insert(xSnapshot)
                }
            }

            if yPeriod == nil {
                let ySnapshot = bodies.ySnapshot()
                if ySnapshots.contains(ySnapshot) {
                    yPeriod = stepCount
                } else {
                    ySnapshots.insert(ySnapshot)
                }
            }

            if zPeriod == nil {
                let zSnapshot = bodies.zSnapshot()
                if zSnapshots.contains(zSnapshot) {
                    zPeriod = stepCount
                } else {
                    zSnapshots.insert(zSnapshot)
                }
            }

            bodies = step(bodies: bodies)
            stepCount += 1
        }

        return lcm(of: [xPeriod!, yPeriod!, zPeriod!])
    }

    func gcd<C: Collection>(of values: C) -> Int where C.Element == Int {
        let first = values.first!
        let other = values.dropFirst()

        if other.count == 1 {
            return gcd(first, other.first!)
        } else {
            return gcd(first, gcd(of: other))
        }
    }

    func lcm<C: Collection>(of values: C) -> Int where C.Element == Int {
        let first = values.first!
        let other = values.dropFirst()

        return other.reduce(first) { (result, value) -> Int in
            lcm(result, value)
        }
    }

    func gcd(_ m: Int, _ n: Int) -> Int {
        var a = max(m, n)
        var b = min(m, n)

        while b != 0 {
            let r = a % b
            a = b
            b = r
        }

        return a
    }

    func lcm(_ m: Int, _ n: Int) -> Int {
        return (m * n) / gcd(m, n)
    }
}

extension Array where Element == NBodyProblem.Body {
    func xSnapshot() -> [Int] {
        return flatMap { [$0.position.x, $0.velocity.x] }
    }

    func ySnapshot() -> [Int] {
        return flatMap { [$0.position.y, $0.velocity.y] }
    }

    func zSnapshot() -> [Int] {
        return flatMap { [$0.position.z, $0.velocity.z] }
    }
}
