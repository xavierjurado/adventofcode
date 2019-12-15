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
}
