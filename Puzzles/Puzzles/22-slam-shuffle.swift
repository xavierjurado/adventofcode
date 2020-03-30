import Foundation

class SlamShuffle {

    enum Command {
        case dealIntoNewStack
        case cutCards(Int)
        case dealWithIncrement(Int)

        func apply(_ deck: [Int]) -> [Int] {
            switch self {
            case .dealIntoNewStack:
                return dealIntoNewStack(input: deck)
            case .cutCards(let n):
                return cutCards(input: deck, n: n)
            case .dealWithIncrement(let n):
                return dealWithIncrement(input: deck, n: n)
            }
        }

        private func dealIntoNewStack(input: [Int]) -> [Int] {
            var input = input
            var start = 0
            var end = input.count - 1
            while start < end {
                input.swapAt(start, end)
                start += 1
                end -= 1
            }

            return input
        }

        private func cutCards(input: [Int], n: Int) -> [Int] {
            guard n != 0 else { return input }
            if n > 0 {
                let top = input.prefix(n)
                let rest = input.dropFirst(n)
                return Array(rest + top)
            } else {
                let positiveN = abs(n)
                let bottom = input.suffix(positiveN)
                let rest = input.dropLast(positiveN)
                return Array(bottom + rest)
            }
        }

        private func dealWithIncrement(input: [Int], n: Int) -> [Int] {
            guard n > 0 else { fatalError() }
            var output = Array(repeating: 0, count: input.count)
            var x = 0
            while x < input.count {
                output[(x * n) % input.count] = input[x]
                x += 1
            }
            return output
        }
    }

    func solvePartOne(input: [Command]) -> Int {
        var deck = Array(0..<10_007)
        for c in input {
            deck = c.apply(deck)
        }

        return deck.firstIndex(of: 2019)!
    }
}
