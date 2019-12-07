import Foundation
@testable import Puzzles

protocol Scannable {
    static func parse(scanner: Scanner) -> Self?
}

extension Array: Scannable where Element: Scannable {
    static func parse(scanner: Scanner) -> Array<Element>? {
        var result: [Element] = []
        while let v = Element.parse(scanner: scanner) {
            result.append(v)
        }
        scanner.scanCharacters(from: .newlines, into: nil)
        return result.isEmpty ? nil : result
    }
}

extension Int: Scannable {
    static func parse(scanner: Scanner) -> Int? {
        var x: Int = 0
        return scanner.scanInt(&x) ? x : nil
    }
}

extension CrossedWires.Path: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let d = CrossedWires.Direction(rawValue: String(description.first!)),
            let l = Int(description.dropFirst()) else { return nil }
        self.init(d: d, l: l)
    }

    public var description: String {
        return "\(d.rawValue)\(l)"
    }
}

extension CrossedWires.Direction: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .up: return "U"
        case .down: return "D"
        case .left: return "L"
        case .right: return "R"
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
        case "U":
            self = .up
        case "D":
            self = .down
        case "L":
            self = .left
        case "R":
            self = .right
        default:
            return nil
        }
    }

}

extension CrossedWires.Path: Scannable {
    static func parse(scanner: Scanner) -> CrossedWires.Path? {
        var c: NSString?
        var l: Int = 0
        if scanner.scanCharacters(from: CharacterSet(charactersIn: "UDLR"), into: &c), scanner.scanInt(&l) {
            let d = CrossedWires.Direction(rawValue: c! as String)!
            return CrossedWires.Path(d: d, l: l)
        } else {
            return nil
        }
    }
}

class SingleValueScanner<T: Scannable> {

    let testCaseName: String
    let separator: CharacterSet
    init(testCaseName: String, separator: CharacterSet = .whitespacesAndNewlines) {
        self.testCaseName = testCaseName
        self.separator = separator
    }

    func parse() -> [T] {
        guard let inputFile = Bundle.current.url(forResource: testCaseName, withExtension: "txt"),
            let inputData = try? Data(contentsOf: inputFile),
            let inputString = String(data: inputData, encoding: .utf8) else {
            fatalError("Could not read test case")
        }

        let scanner = Scanner(string: inputString)
        scanner.charactersToBeSkipped = separator
        var result: [T] = []
        while let v = T.parse(scanner: scanner) {
            result.append(v)
        }

        return result
    }
}
