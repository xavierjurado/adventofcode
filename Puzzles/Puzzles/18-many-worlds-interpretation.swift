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

        let origin: XY
        let allKeys: Set<Character>

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
            self.allKeys = Set(keys.keys)
            self.origin = origin!
        }

        subscript(pos: XY) -> Content {
            return matrix[pos.y][pos.x]
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
    }

    /// Pathways graph

    func solvePartOne(maze: String) -> Int {
        // Parse maze
        let map = Map(raw: maze)

        // Dijkstra
        struct Node: Hashable {
            var position: XY
            var availableKeys: Set<Character>
        }

        let origin = Node(position: map.origin, availableKeys: [])
        var distTo: [Node: Int] = [origin: 0]
        var queue: [Node] = [origin]

        while !queue.isEmpty {
            let v = queue.removeFirst() // TODO: mindist
            let r = routes(from: v.position, keys: v.availableKeys, map: map)
            for n in r {
                let d = distTo[v]! + n.value
                let node = Node(position: n.key.position, availableKeys: v.availableKeys.union([n.key.key]))
                if d < distTo[node, default: Int.max] {
                    distTo[node] = d
                    queue.append(node)
                }
            }
        }

        return distTo
            .filter { d -> Bool in
                    d.key.availableKeys == map.allKeys
            }
            .sorted { (d1, d2) -> Bool in
                d1.value < d2.value
            }
            .first!.value
    }

    struct KeyPosition: Hashable {
        var position: XY
        var key: Character
    }

    private func routes(from origin: XY, keys: Set<Character>, map: Map) -> [KeyPosition: Int] {
        // BFS
        var queue: [XY]  = [origin]
        var discovered: Set<XY> = [origin]
        var distTo: [XY: Int] = [origin: 0]
        var routesToKeys: [KeyPosition: Int] = [:]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            for n in map.neightbours(v) {
                guard !discovered.contains(n) else { continue }
                discovered.insert(n)
                distTo[n] = distTo[v]! + 1

                switch map[n] {
                case .wall:
                    continue
                case .door(let d):
                    let haveTheKey = keys.contains(d.lowercased().first!)
                    if haveTheKey {
                        queue.append(n)
                    }
                case .key(let k):
                    let haveTheKey = keys.contains(k)
                    if !haveTheKey {
                        routesToKeys[KeyPosition(position: n, key: k)] = distTo[n]!
                    } else {
                        queue.append(n)
                    }
                case .empty:
                    queue.append(n)
                }
            }
        }

        return routesToKeys
    }

//    private func foo(from origin: XY, map: Map) {
//
//        struct Cost {
//            var value: Int = 0
//            var keys: Set<Character> = []
//        }
//
//        var queue: [XY]  = [origin]
//        var discovered: Set<XY> = [origin]
//        var distTo: [XY: Cost] = [origin: Cost()]
//        var distToKey: [KeyPosition: Int] = [:]
//
//        while !queue.isEmpty {
//            let v = queue.removeFirst()
//            for n in map.neightbours(v) {
//                guard !discovered.contains(n) else { continue }
//                discovered.insert(n)
//                distTo[n, default: Cost()].value = distTo[v]!.value + 1
//
//                switch map[n] {
//                case .wall:
//                    continue
//                case .door(let d):
//                    distTo[n]!.keys.insert(d)
//                    queue.append(n)
//                case .key(let k):
//                    let haveTheKey = keys.contains(k)
//                    if !haveTheKey {
//                        routesToKeys[KeyPosition(position: n, key: k)] = distTo[n]!
//                    } else {
//                        queue.append(n)
//                    }
//                case .empty:
//                    queue.append(n)
//                }
//            }
//        }
//
//    }
}
