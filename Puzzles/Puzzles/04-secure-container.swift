import Foundation

extension Int {
    func digits() -> [Int] {
        var result: [Int] = []
        var x = self
        while x > 0 {
            result.append(x % 10)
            x = x / 10
        }
        return result.reversed()
    }
}

class SecureContainer {
    func solve() -> Int {
        let low = 272091
        let high = 815432

        var candidates: [Int] = []
        var i = low
        while i <= high {
            if meetsCriteria(i) {
                candidates.append(i)
            }
            i += 1
        }

        return candidates.count
    }

    func meetsCriteria(_ x: Int) -> Bool {
        hasTwoAdgacentDigits(x) && hasNonDecreaseOrder(x)
    }

    func hasTwoAdgacentDigits(_ x: Int) -> Bool {
        var passed = false
        var lastDigit: Int?
        var x = x
        while x > 0 && !passed {
            let d = x % 10
            passed = passed || d == lastDigit
            lastDigit = d
            x = x / 10
        }

        return passed
    }

    func hasNonDecreaseOrder(_ x: Int) -> Bool {
        let d = x.digits()
        return zip(d, d.dropFirst()).map(<=).reduce(true) { $0 && $1 }
    }
}

extension SecureContainer {
    func hasTwoAdgacentDigitsPartTwo(_ x: Int) -> Bool {
        var passed = false
        var lastDigit: Int?
        var adjacentDigits = 1
        var x = x
        while x > 0 {
            let d = x % 10
            if d == lastDigit {
                adjacentDigits += 1
            }
            else {
                if adjacentDigits == 2 {
                    passed = true
                }
                adjacentDigits = 1
            }
            lastDigit = d
            x = x / 10
        }

        return passed || adjacentDigits == 2
    }

    func solvePartTwo() -> Int {
        let low = 272091
        let high = 815432

        var candidates: [Int] = []
        var i = low
        while i <= high {
            if hasNonDecreaseOrder(i), hasTwoAdgacentDigitsPartTwo(i) {
                candidates.append(i)
            }
            i += 1
        }

        return candidates.count
    }
}
