import Foundation
@testable import Puzzles

class TestInput: InputBuffer {
    var values: [Int] = []

    init(values: [Int]) {
        self.values = values
    }

    func read() -> Int {
        values.removeFirst()
    }

    func hasData() -> Bool {
        return !values.isEmpty
    }
}

class TestOutput: OutputBuffer {

    var values: [Int] = []

    func write(value: Int) {
        values.append(value)
    }
}

class PassthroughOutput: OutputBuffer {
    var lastValue: Int?
    var destination: OutputBuffer

    init(destination: OutputBuffer) {
        self.destination = destination
    }

    func write(value: Int) {
        lastValue = value
        destination.write(value: value)
    }
}
