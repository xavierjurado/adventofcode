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
}
