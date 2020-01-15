import Foundation

class SpaceStoichiometry {

    static let ore = "ORE"
    static let fuel = "FUEL"

    struct Chemical: Hashable, CustomStringConvertible {
        let id: String
        let quantity: Int

        var description: String {
            return "\(quantity) \(id)"
        }
    }

    struct Reaction: Hashable {
        let input: [Chemical]
        let output: Chemical
    }

    func solvePartOne(reactions: [Reaction], fuel: Int = 1) -> Int {

        var noIncomingEdges: Set<String> = [SpaceStoichiometry.fuel]
        var materials: [String: Int] = [SpaceStoichiometry.fuel: fuel]
        var reactionsByOutput: [String: Reaction] = [:]
        var reactionsUsingChemical: [String: Int] = [:]
        for r in reactions {
            reactionsByOutput[r.output.id] = r
            for i in r.input {
                reactionsUsingChemical[i.id, default: 0] += 1
            }
        }

        while !noIncomingEdges.isEmpty {
            let id = noIncomingEdges.removeFirst()
            if id == SpaceStoichiometry.ore {
                break
            }
            let reaction = reactionsByOutput[id]!
            let wantedQuantity = materials[id]!

            let (q, r) = wantedQuantity.quotientAndRemainder(dividingBy: reaction.output.quantity)
            let factor = q + (r > 0 ? 1 : 0)

            for input in reaction.input {
                // perform the reaction
                materials[input.id, default: 0] += input.quantity * factor

                // seek other chemicals to be processed
                reactionsUsingChemical[input.id, default: 0] -= 1
                if reactionsUsingChemical[input.id] == 0 {
                    noIncomingEdges.insert(input.id)
                }
            }
        }

        return materials[SpaceStoichiometry.ore]!
    }

    func solvePartTwo(reactions: [Reaction]) -> Int {
        let targetOre = 1000000000000 // 1 trillion
        let orePerOneFuel = 136771
        var lowerBound = targetOre/orePerOneFuel
        var upperBound = lowerBound * 2

        // "brute force" b-search
        while lowerBound < upperBound {
            let mid = lowerBound + (upperBound - lowerBound) / 2
            let ore = solvePartOne(reactions: reactions, fuel: mid)
            if ore < targetOre {
                lowerBound = mid
            } else {
                upperBound = mid - 1
            }
        }

        return lowerBound
    }
}
