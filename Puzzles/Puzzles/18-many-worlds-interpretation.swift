import Foundation

class ManyWorldInterpretation {

    /// Map

    enum Content: Equatable {
        case wall
        case key(Character)
        case door(Character)
        case empty
    }

    struct XY: Hashable {
        var x: Int
        var y: Int

        var left: XY {
            return XY(x: x - 1, y: y)
        }

        var right: XY {
            return XY(x: x + 1, y: y)
        }

        var up: XY {
            return XY(x: x, y: y - 1)
        }

        var down: XY {
            return XY(x: x, y: y + 1)
        }
    }

    struct Map {
        private var matrix: [[Content]]

        var width: Int {
            return matrix[0].count
        }

        var height: Int {
            return matrix.count
        }

        private(set) var allKeys: [Character: XY]
        private(set) var entrances: Set<XY>

        init(raw: String) {
            let rows = raw.split(separator: "\n")
            var keys: [Character: XY] = [:]
            var y = 0
            var origin: XY?
            self.matrix = rows.map { sub -> [Content] in
                defer { y += 1 }
                var x = 0
                return sub.compactMap { (c) -> Content? in
                    defer { x += 1}
                    if c == "#" {
                        return .wall
                    } else if CharacterSet.uppercaseLetters.contains(c.unicodeScalars.first!) {
                        return .door(c)
                    } else if CharacterSet.lowercaseLetters.contains(c.unicodeScalars.first!) {
                        keys[c] = XY(x: x, y: y)
                        return .key(c)
                    } else if c == "." {
                        return .empty
                    } else if c == "@" {
                        origin = XY(x: x, y: y)
                        return .empty
                    }
                    return nil
                }
            }
            self.allKeys = keys
            self.entrances = [origin!]
        }

        subscript(pos: XY) -> Content {
            get {
                return matrix[pos.y][pos.x]
            }
            set {
                matrix[pos.y][pos.x] = newValue
            }
        }

        func neightbours(_ position: XY) -> [XY] {
            var n: [XY] = []
            if position.x > 0 {
                n.append(position.left)
            }
            if position.x < width - 1 {
                n.append(position.right)
            }
            if position.y > 0 {
                n.append(position.up)
            }
            if position.y < height - 1 {
                n.append(position.down)
            }
            return n
        }

        mutating func split() {
            guard let entrance = entrances.first, entrances.count == 1 else { fatalError() }
            self[entrance] = .wall
            self[entrance.up] = .wall
            self[entrance.down] = .wall
            self[entrance.left] = .wall
            self[entrance.right] = .wall

            entrances = [entrance.up.left, entrance.up.right, entrance.down.left, entrance.down.right]
        }
    }

    /// Pathways graph

    func solvePartOne(maze: String) -> Int {
        // Parse maze
        let map = Map(raw: maze)
        let adj = preprocessRoutes(map: map)

        // Dijkstra
        struct Node: Hashable {
            var key: Character
            var availableKeys: Set<Character>
        }

        let origin = Node(key: "1", availableKeys: [])
        var distTo: [Node: Int] = [origin: 0]
        var queue: [Node] = [origin]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            let edges = adj[v.key]!
            let r = edges.filter { $1.keys.isSubset(of: v.availableKeys) }
            for (key, cost) in r {
                let d = distTo[v]! + cost.value
                let node = Node(key: key, availableKeys: v.availableKeys.union([key]))
                if d < distTo[node, default: Int.max] {
                    distTo[node] = d
                    queue.append(node)
                }
            }
        }

        return distTo
            .filter { d -> Bool in
                d.key.availableKeys == Set(map.allKeys.keys)
            }
            .sorted { (d1, d2) -> Bool in
                d1.value < d2.value
            }
            .first!.value
    }

    struct Cost: Hashable {
        var value: Int = 0
        var keys: Set<Character> = []
    }

    private func preprocessRoutes(map: Map) -> [Character: [Character: Cost]] {

        var adj: [Character: [Character: Cost]] = [:]
        let entranceKeys: [Character] = ["1", "2", "3", "4"]

        for (entrance, entranceKey) in zip(map.entrances, entranceKeys) {
            var pointsOfInterest = map.allKeys
            pointsOfInterest[entranceKey] = entrance

            for (key, origin) in pointsOfInterest {
                var queue: [XY]  = [origin]
                var discovered: Set<XY> = [origin]
                var distTo: [XY: Cost] = [origin: Cost()]

                while !queue.isEmpty {
                    let v = queue.removeFirst()
                    for n in map.neightbours(v) {
                        guard !discovered.contains(n) else { continue }
                        discovered.insert(n)
                        var nCost = distTo[v]!
                        nCost.value += 1

                        switch map[n] {
                        case .wall:
                            continue
                        case .door(let d):
                            let key  = d.lowercased().first!
                            nCost.keys.insert(key)
                            queue.append(n)
                        case .key(let k):
                            adj[key, default: [:]][k] = nCost
                        case .empty:
                            queue.append(n)
                        }

                        distTo[n] = nCost
                    }
                }
            }
        }

        return adj
    }

    func solvePartTwo(maze: String) -> Int {
        // Parse maze
        var map = Map(raw: maze)
        map.split()
        let adj = preprocessRoutes(map: map)

        // Dijkstra
        struct Node: Hashable {
            var droneLocations: [Character]
            var availableKeys: Set<Character>
        }

        let origin = Node(droneLocations: ["1", "2", "3", "4"] , availableKeys: [])
        var distTo: [Node: Int] = [origin: 0]
        var queue: [Node] = [origin]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            for (i, drone) in v.droneLocations.enumerated() {
                guard let r = adj[drone]?.filter ({ $1.keys.isSubset(of: v.availableKeys) }) else { continue }
                for (key, cost) in r {
                    let d = distTo[v]! + cost.value
                    var droneLocations = v.droneLocations
                    droneLocations[i] = key
                    let node = Node(droneLocations: droneLocations, availableKeys: v.availableKeys.union([key]))
                    if d < distTo[node, default: Int.max] {
                        distTo[node] = d
                        queue.append(node)
                    }
                }
            }
        }

        return distTo
            .filter { d -> Bool in
                d.key.availableKeys == Set(map.allKeys.keys)
            }
            .sorted { (d1, d2) -> Bool in
                d1.value < d2.value
            }
            .first!.value
    }
}
