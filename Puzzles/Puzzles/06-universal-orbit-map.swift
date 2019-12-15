import Foundation

class UniversalOrbitMap {
    struct OrbitalRelationship {
        let object: String
        let center: String
    }

    func solvePartOne(map: [OrbitalRelationship]) -> Int {
        var graph: [String: [String]] = [:]
        for r in map {
            let center = r.center
            let object = r.object
            graph[center, default: []].append(object)
        }

        var queue = ["COM"]
        var depth: [String: Int] = ["COM": 0]
        var checksum = 0

        while !queue.isEmpty {
            let node = queue.removeFirst()
            let nodeDepth = depth[node]!
            checksum += nodeDepth
            let edges = graph[node] ?? []
            for e in edges {
                queue.append(e)
                depth[e] = nodeDepth + 1
            }
        }

        return checksum
    }

    func solvePartTwo(map: [OrbitalRelationship]) -> Int {
        var graph: [String: [String]] = [:]
        for r in map {
            let center = r.center
            let object = r.object
            graph[center, default: []].append(object)
            graph[object, default: []].append(center)
        }

        var marked: [String: Bool] = [:]
        var distTo: [String: Int] = ["YOU": 0]
        var queue = ["YOU"]
        let destination = "SAN"

        while !queue.isEmpty {
            let v = queue.removeFirst()
            // early return
            if v == destination {
                break
            }

            let d = distTo[v]!

            for n in graph[v, default: []] where !marked[n, default: false] {
                distTo[n] = d + 1
                queue.append(n)
            }

            marked[v] = true

        }

        return distTo[destination]! - 2
    }
}
