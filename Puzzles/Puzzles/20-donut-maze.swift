import Foundation

class DonutMaze {

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

        func up(times: Int) -> XY {
            return XY(x: x, y: y - times)
        }

        func down(times: Int) -> XY {
            return XY(x: x, y: y + times)
        }

        func left(times: Int) -> XY {
            return XY(x: x - times, y: y)
        }

        func right(times: Int) -> XY {
            return XY(x: x + times, y: y)
        }

    }

    struct Maze {

        private var matrix: [[UnicodeScalar]]

        let outerTopLeft: XY
        let outerBottomRight: XY
        let innerTopLeft: XY
        let innerBottomRight: XY

        init(raw: String) {
            matrix = raw.split(separator: "\n").map { Array($0.unicodeScalars) }
            let width = matrix[0].count
            let height = matrix.count
            let mazeCharacter = CharacterSet(charactersIn: "#.")

            guard let leftMargin = matrix[height/2].firstIndex(where: { mazeCharacter.contains($0) }),
                let topMargin = matrix.firstIndex(where: {  mazeCharacter.contains($0[width/2]) }),
                let innerLeftBorder = matrix[height/2].prefix(width/2).lastIndex(where: { mazeCharacter.contains($0) }),
                let innerTopBorder = matrix.prefix(height/2).lastIndex(where: { mazeCharacter.contains($0[width/2]) })
                else { fatalError() }

            outerTopLeft = XY(x: leftMargin, y: topMargin)
            outerBottomRight = XY(x: width - leftMargin - 1, y: height - topMargin - 1)
            innerTopLeft = XY(x: innerLeftBorder, y: innerTopBorder)
            innerBottomRight = XY(x: width - innerLeftBorder - 1, y: height - innerTopBorder - 1)
        }

        subscript(pos: XY) -> UnicodeScalar {
            get {
                return matrix[pos.y][pos.x]
            }
        }
    }

    struct Portal: Hashable {
        var position: XY
        var name: String
    }

    func solvePartOne(input: String) -> Int {
        let maze = Maze(raw: input)
        var portalByPosition: [XY: Portal] = [:]
        var outerPortalByName: [String: Portal] = [:]
        var innerPortalByName: [String: Portal] = [:]

        // Horizontal outer portals
        for x in maze.outerTopLeft.x...maze.outerBottomRight.x {
            let topPosition = XY(x: x, y: maze.outerTopLeft.y)
            if maze[topPosition] == "." {
                let c1 = maze[topPosition.up.up]
                let c2 = maze[topPosition.up]
                let portal = Portal(position: topPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                outerPortalByName[portal.name] = portal
            }

            let bottomPosition = XY(x: x, y: maze.outerBottomRight.y)
            if maze[bottomPosition] == "." {
                let c1 = maze[bottomPosition.down]
                let c2 = maze[bottomPosition.down.down]
                let portal = Portal(position: bottomPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                outerPortalByName[portal.name] = portal
            }
        }

        // Vertical outer portals
        for y in maze.outerTopLeft.y...maze.outerBottomRight.y {
            let leftPosition = XY(x: maze.outerTopLeft.x, y: y)
            if maze[leftPosition] == "." {
                let c1 = maze[leftPosition.left.left]
                let c2 = maze[leftPosition.left]
                let portal = Portal(position: leftPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                outerPortalByName[portal.name] = portal
            }

            let rightPosition = XY(x: maze.outerBottomRight.x, y: y)
            if maze[rightPosition] == "." {
                let c1 = maze[rightPosition.right]
                let c2 = maze[rightPosition.right.right]
                let portal = Portal(position: rightPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                outerPortalByName[portal.name] = portal
            }
        }

        // Horizontal inner portals
        for x in maze.innerTopLeft.x...maze.innerBottomRight.x {
            let topPosition = XY(x: x, y: maze.innerTopLeft.y)
            if maze[topPosition] == "." {
                let c1 = maze[topPosition.down]
                let c2 = maze[topPosition.down.down]
                let portal = Portal(position: topPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                innerPortalByName[portal.name] = portal
            }

            let bottomPosition = XY(x: x, y: maze.innerBottomRight.y)
            if maze[bottomPosition] == "." {
                let c1 = maze[bottomPosition.up.up]
                let c2 = maze[bottomPosition.up]
                let portal = Portal(position: bottomPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                innerPortalByName[portal.name] = portal
            }
        }

        // Vertical inner portals
        for y in maze.innerTopLeft.y...maze.innerBottomRight.y {
            let leftPosition = XY(x: maze.innerTopLeft.x, y: y)
            if maze[leftPosition] == "." {
                let c1 = maze[leftPosition.right]
                let c2 = maze[leftPosition.right.right]
                let portal = Portal(position: leftPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                innerPortalByName[portal.name] = portal
            }

            let rightPosition = XY(x: maze.innerBottomRight.x, y: y)
            if maze[rightPosition] == "." {
                let c1 = maze[rightPosition.left.left]
                let c2 = maze[rightPosition.left]
                let portal = Portal(position: rightPosition, name: "\(c1)\(c2)")
                portalByPosition[portal.position] = portal
                innerPortalByName[portal.name] = portal
            }
        }

        // BFS
        let origin = outerPortalByName["AA"]!
        var visited: [XY: Bool] = [origin.position: true]
        var queue: [XY] = [origin.position]
        var distTo: [XY: Int] = [origin.position : 0]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            if let portal = portalByPosition[v], portal.name == "ZZ" {
                return distTo[v]!
            }

            let neightbours = [v.up, v.right, v.down, v.left].filter { maze[$0] == "." }.filter { visited[$0, default: false] == false }

            for n in neightbours {
                visited[n] = true
                distTo[n] = distTo[v]! + 1
                queue.append(n)
            }

            if let portal = portalByPosition[v], neightbours.isEmpty {
                if innerPortalByName[portal.name] == portal, let outerPortal = outerPortalByName[portal.name] {
                    visited[outerPortal.position] = true
                    distTo[outerPortal.position] = distTo[v]! + 1
                    queue.append(outerPortal.position)
                } else {
                    let innerPortal = innerPortalByName[portal.name]!
                    visited[innerPortal.position] = true
                    distTo[innerPortal.position] = distTo[v]! + 1
                    queue.append(innerPortal.position)
                }

            }
        }

        fatalError()
    }
}
