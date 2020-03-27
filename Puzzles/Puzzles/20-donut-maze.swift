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
        var portalByPosition: [XY: Portal] = [:]
        var outerPortalByName: [String: Portal] = [:]
        var innerPortalByName: [String: Portal] = [:]

        var entrance: Portal {
            outerPortalByName["AA"]!
        }

        var exit: Portal {
            outerPortalByName["ZZ"]!
        }

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

            // Horizontal outer portals
            for x in outerTopLeft.x...outerBottomRight.x {
                let topPosition = XY(x: x, y: outerTopLeft.y)
                if self[topPosition] == "." {
                    let c1 = self[topPosition.up.up]
                    let c2 = self[topPosition.up]
                    let portal = Portal(position: topPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    outerPortalByName[portal.name] = portal
                }

                let bottomPosition = XY(x: x, y: outerBottomRight.y)
                if self[bottomPosition] == "." {
                    let c1 = self[bottomPosition.down]
                    let c2 = self[bottomPosition.down.down]
                    let portal = Portal(position: bottomPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    outerPortalByName[portal.name] = portal
                }
            }

            // Vertical outer portals
            for y in outerTopLeft.y...outerBottomRight.y {
                let leftPosition = XY(x: outerTopLeft.x, y: y)
                if self[leftPosition] == "." {
                    let c1 = self[leftPosition.left.left]
                    let c2 = self[leftPosition.left]
                    let portal = Portal(position: leftPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    outerPortalByName[portal.name] = portal
                }

                let rightPosition = XY(x: outerBottomRight.x, y: y)
                if self[rightPosition] == "." {
                    let c1 = self[rightPosition.right]
                    let c2 = self[rightPosition.right.right]
                    let portal = Portal(position: rightPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    outerPortalByName[portal.name] = portal
                }
            }

            // Horizontal inner portals
            for x in innerTopLeft.x...innerBottomRight.x {
                let topPosition = XY(x: x, y: innerTopLeft.y)
                if self[topPosition] == "." {
                    let c1 = self[topPosition.down]
                    let c2 = self[topPosition.down.down]
                    let portal = Portal(position: topPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    innerPortalByName[portal.name] = portal
                }

                let bottomPosition = XY(x: x, y: innerBottomRight.y)
                if self[bottomPosition] == "." {
                    let c1 = self[bottomPosition.up.up]
                    let c2 = self[bottomPosition.up]
                    let portal = Portal(position: bottomPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    innerPortalByName[portal.name] = portal
                }
            }

            // Vertical inner portals
            for y in innerTopLeft.y...innerBottomRight.y {
                let leftPosition = XY(x: innerTopLeft.x, y: y)
                if self[leftPosition] == "." {
                    let c1 = self[leftPosition.right]
                    let c2 = self[leftPosition.right.right]
                    let portal = Portal(position: leftPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    innerPortalByName[portal.name] = portal
                }

                let rightPosition = XY(x: innerBottomRight.x, y: y)
                if self[rightPosition] == "." {
                    let c1 = self[rightPosition.left.left]
                    let c2 = self[rightPosition.left]
                    let portal = Portal(position: rightPosition, name: "\(c1)\(c2)")
                    portalByPosition[portal.position] = portal
                    innerPortalByName[portal.name] = portal
                }
            }

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

        // BFS
        let origin = maze.entrance
        var visited: [XY: Bool] = [origin.position: true]
        var queue: [XY] = [origin.position]
        var distTo: [XY: Int] = [origin.position : 0]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            if let portal = maze.portalByPosition[v], portal == maze.exit {
                return distTo[v]!
            }

            let neightbours = [v.up, v.right, v.down, v.left].filter { maze[$0] == "." }.filter { visited[$0, default: false] == false }

            for n in neightbours {
                visited[n] = true
                distTo[n] = distTo[v]! + 1
                queue.append(n)
            }

            if let portal = maze.portalByPosition[v], neightbours.isEmpty {
                if maze.innerPortalByName[portal.name] == portal, let outerPortal = maze.outerPortalByName[portal.name] {
                    visited[outerPortal.position] = true
                    distTo[outerPortal.position] = distTo[v]! + 1
                    queue.append(outerPortal.position)
                } else {
                    let innerPortal = maze.innerPortalByName[portal.name]!
                    visited[innerPortal.position] = true
                    distTo[innerPortal.position] = distTo[v]! + 1
                    queue.append(innerPortal.position)
                }

            }
        }

        fatalError()
    }

    struct XYZ: Hashable {
        var x: Int
        var y: Int
        var z: Int

        init(x: Int, y: Int, z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }

        init(_ p: XY, z: Int) {
            x = p.x
            y = p.y
            self.z = z
        }

        var left: XYZ {
            return XYZ(x: x - 1, y: y, z: z)
        }

        var right: XYZ {
            return XYZ(x: x + 1, y: y, z: z)
        }

        var up: XYZ {
            return XYZ(x: x, y: y - 1, z: z)
        }

        var down: XYZ {
            return XYZ(x: x, y: y + 1, z: z)
        }

        var toXY: XY {
            return XY(x: x, y: y)
        }
    }

    func solvePartTwo(input: String) -> Int {
        let maze = Maze(raw: input)

        let origin = maze.entrance
        let level0position = XYZ(origin.position, z: 0)
        var visited: [XYZ: Bool] = [level0position: true]
        var queue: [XYZ] = [level0position]
        var distTo: [XYZ: Int] = [level0position : 0]

        while !queue.isEmpty {
            let v = queue.removeFirst()
            if let portal = maze.portalByPosition[v.toXY], portal == maze.exit, v.z == 0 {
                return distTo[v]!
            }

            let neightbours = [v.up, v.right, v.down, v.left].filter { maze[$0.toXY] == "." }.filter { visited[$0, default: false] == false }

            for n in neightbours {
                visited[n] = true
                distTo[n] = distTo[v]! + 1
                queue.append(n)
            }

            if let portal = maze.portalByPosition[v.toXY], neightbours.isEmpty, portal != maze.entrance, portal != maze.exit {
                if maze.innerPortalByName[portal.name] == portal, let outerPortal = maze.outerPortalByName[portal.name] {
                    let deeperLevelPosition = XYZ(outerPortal.position, z: v.z + 1)
                    visited[deeperLevelPosition] = true
                    distTo[deeperLevelPosition] = distTo[v]! + 1
                    queue.append(deeperLevelPosition)
                } else if v.z > 0 {
                    // when at the outermost level, only the outer labels AA and ZZ function; all other outer labeled tiles are effectively walls
                    let innerPortal = maze.innerPortalByName[portal.name]!
                    let shallowerLevelPosition = XYZ(innerPortal.position, z: v.z - 1)
                    visited[shallowerLevelPosition] = true
                    distTo[shallowerLevelPosition] = distTo[v]! + 1
                    queue.append(shallowerLevelPosition)
                }
            }
        }

        fatalError()
    }
}
