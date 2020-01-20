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
            var output = Array(repeating: 0, count: input.count)
            for i in 0..<input.count {
                let pattern = computerPattern(at: i)
                let patternLength = pattern.count
                output[i] = input.enumerated().map { $0.element * pattern[$0.offset % patternLength] }.reduce(0, +) % 10
                output[i] = abs(output[i])
            }
            input = output
        }
        return input
    }

    func computerPattern(at index: Int) -> [Int] {
        let basePattern = [0, 1, 0, -1]
        var pattern = basePattern.flatMap{ Array(repeating: $0, count: index + 1) }
        pattern.append(pattern[0])
        pattern.removeFirst()
        return pattern
    }
}
