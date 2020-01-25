import Foundation

private extension ArraySlice {
    func toArray() -> Array<Element> {
        return Array(self)
    }
}

class FlawedFrequencyTransmission {

    func solvePartOne(list: [Int], phases: Int = 1) -> [Int] {
        var input = list
        for _ in 0..<phases {
            var output = input
            var i = input.count - 1
            while i >= 0 {
                let slice = input[i+1..<input.count]
                output[i] = input[i] + zip(slice, slice.indices).map { $0.0 * computerPattern(for: i, index: $0.1) }.reduce(0, +)
                output[i] = output[i] % 10
                output[i] = abs(output[i])
                i -= 1
            }
            swap(&input, &output)
        }
        return input
    }

    // hint: value(digit, phase) = value(digit + 1, phase) + value(digit, phase - 1)
    func solvePartTwo(list: [Int]) -> [Int] {
        let phases = 100
        let offset = zip(0..<7, list.prefix(7).reversed()).reduce(0) { acc, tuple -> Int in acc + Int(pow(10, Double(tuple.0))) * tuple.1 }
        var input = Array(Array(repeating: list, count: 10_000).flatMap { $0 }.dropFirst(offset))
        var output = Array(repeating: 0, count: input.count)
        for _ in 0..<phases {
            var i = input.count - 1
            var partialSum = 0
            while i >= 0 {
                output[i] = input[i] + partialSum
                output[i] = output[i] % 10
                partialSum = output[i]
                i -= 1
            }
            swap(&input, &output)
        }
        return Array(input.prefix(8))
    }

    func computerPattern(for output: Int, index: Int) -> Int {
        let correctedOutput = output + 1
        let correctedIndex = (index + 1) % (correctedOutput * 4)
        if correctedIndex < correctedOutput {
            return 0
        } else if correctedIndex < 2 * correctedOutput {
            return 1
        } else if correctedIndex < 3 * correctedOutput {
            return 0
        } else {
            return -1
        }
    }

    func computerPattern(at index: Int) -> [Int] {
        let basePattern = [0, 1, 0, -1]
        var pattern = basePattern.flatMap{ Array(repeating: $0, count: index + 1) }
        pattern.append(pattern[0])
        pattern.removeFirst()
        return pattern
    }
}
