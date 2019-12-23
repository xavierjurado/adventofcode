import Foundation

class SpaceImage {
    func solve(data: [Int], wide: Int = 25, tall: Int = 6) -> Int {
        let layerDigits = wide * tall
        var i = 0
        var layerIndex = 0
        var lessNumberOfZeroes = Int.max
        while i < data.count {
            let layer = data[i..<(i + layerDigits)]
            let numberOfZeroes = layer.filter { $0 == 0 }.count
            if numberOfZeroes < lessNumberOfZeroes {
                lessNumberOfZeroes = numberOfZeroes
                layerIndex = i
            }
            i += layerDigits
        }

        let layer = data[layerIndex..<(layerIndex + layerDigits)]
        let numberOfOnes = layer.filter { $0 == 1 }.count
        let numberOfTwoes = layer.filter { $0 == 2 }.count
        let checksum = numberOfOnes * numberOfTwoes

        return checksum
    }

    enum PixelColor: Int {
        case black = 0
        case white = 1
        case transparent = 2
    }

    func solvePartTwo(data: [Int], wide: Int = 25, tall: Int = 6) {
        let layerDigits = wide * tall
        var composedLayer = Array(repeating: PixelColor.transparent.rawValue, count: layerDigits)
        var i = 0
        while i < data.count {
            let indexInLayer = i % layerDigits
            let pixel = data[i]
            if composedLayer[indexInLayer] == PixelColor.transparent.rawValue {
                composedLayer[indexInLayer] = pixel
            }
            i += 1
        }
        printLayer(data: composedLayer, wide: wide)
    }

    private func printLayer(data: [Int], wide: Int) {
        var i = 0
        while i < data.count {
            let row = data[i..<(i + wide)]
            let rowString = row.map { "\($0)" }.joined()
            print(rowString)
            i += wide
        }
    }
}
