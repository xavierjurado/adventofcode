import Foundation

class NBodyProblem {
    struct XYZ: Equatable {
        var x: Int
        var y: Int
        var z: Int

        static var zero: XYZ {
            return XYZ(x: 0, y: 0, z: 0)
        }
    }

    struct Body {
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
}
