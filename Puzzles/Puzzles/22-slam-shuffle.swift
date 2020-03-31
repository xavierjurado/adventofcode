import Foundation

extension BinaryInteger {
  @inlinable
  public func modInv(_ mod: Self) -> Self {
    var (m, n) = (mod, self)
    var (x, y) = (Self(0), Self(1))

    while n != 0 {
      (x, y) = (y, x - (m / n) * y)
      (m, n) = (n, m % n)
    }

    while x < 0 {
      x += mod
    }

    return x
  }
}

func modPow<T: BinaryInteger>(_ n: T, _ e: T, _ m: T) -> T {
  guard e != 0 else {
    return 1
  }

  var res = T(1)
  var base = n % m
  var exp = e

  while true {
    if exp & 1 == 1 {
        res = mulmod(res, base, m)
    }

    if exp == 1 {
      return res
    }

    exp /= 2
    base = mulmod(base, base, m)
  }
}

func mulmod<T: BinaryInteger>(_ n: T, _ e: T, _ m: T) -> T {
    var res = T(0)
    var a = n % m
    var b = e
    while b > 0 {
        if b & 1 == 1 {
            res = res + a
            res = res % m
        }
        a = a * 2
        a = a % m

        b = b / 2
    }
    return res
}

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

        func inputIndex(deckSize: Int, outputIndex: Int) -> Int {
            switch self {
            case .dealIntoNewStack:
                return deckSize - 1 - outputIndex
            case .cutCards(let n):
                return (outputIndex + n + deckSize) % deckSize
            case .dealWithIncrement(let n):
                return (outputIndex * n.modInv(deckSize)) % deckSize
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

    func solvePartTwo(input: [Command]) -> Int {
//        let outputIndex = 2020
//        let deckSize = 119_315_717_514_047
//        let shuffle =  101_741_582_076_661

        // TODO: compute affine input transformation (offset_diff, increment_mul)
        // TODO: geometric series
        return 0
    }
}
