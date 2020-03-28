import Foundation

class SpringDroidAdventure {

    class ASCIInterface: OutputBuffer, InputBuffer {

        struct XY: Hashable {
            var x: Int
            var y: Int

            static var zero: XY {
                return XY(x: 0, y: 0)
            }

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

        private var returnInstructions: [Int]
        private var cursorPosition: XY
        private var rawMap: String
        private(set) var hullDamage: Int

        init(instructions: String) {
            cursorPosition = .zero
            rawMap = ""
            hullDamage = 0

            func encodeFunctionList(_ text: String) -> [Int] {
                text.compactMap { $0.asciiValue }.map { Int($0) }
            }

            returnInstructions = encodeFunctionList(instructions.appending("\n"))
        }

        func write(value: Int) {
            guard let scalar = UnicodeScalar(value) else {
                hullDamage = value
                return
            }

            let c = Character(scalar)
            rawMap.append(c)
        }

        func printMap() {
            print(rawMap)
        }

        func read() -> Int {
            return returnInstructions.removeFirst()
        }

        func hasData() -> Bool {
            !returnInstructions.isEmpty
        }
    }

    func solvePartOne(memory: [Int]) -> Int {
        /*
         ...@.............
         #####..##########

         ...@.............
         ####.############

         ...@.............  ...@.............
         ######.#..#######  #####.##.########
         */

        let text = """
        NOT B T
        NOT C J
        AND T J
        AND D J
        NOT A T
        OR T J
        NOT C T
        AND D T
        OR T J
        WALK
        """

        let computer = Intcode(memory: memory)
        let interface = ASCIInterface(instructions: text)
        computer.input = interface
        computer.output = interface
        try! computer.execute()
        interface.printMap()
        return interface.hullDamage
    }

    func solvePartTwo(memory: [Int]) -> Int {
        /*
         ...@...@.........
         #####..##########
         ######.##.#######
         #####..##.##.####
         ####.#.#..##.####
         ######.#..###
         #.####.#..###
         #####..#.########
         #####..#.#.#..###
         ######.#...#.#.###
         #####..#..#######
             ABCDEFGHI
               .#   #

           @   @
         ####.##.##.#.###
            ABCDEFGHI
             . #

         ...@.............
         ####.############
             ABCD
             .
         */

        let text = """
        NOT C J
        AND D J
        AND H J
        NOT B T
        AND D T
        OR T J
        NOT A T
        OR T J
        RUN
        """

        let computer = Intcode(memory: memory)
        let interface = ASCIInterface(instructions: text)
        computer.input = interface
        computer.output = interface
        try! computer.execute()
        interface.printMap()
        return interface.hullDamage
    }
}
