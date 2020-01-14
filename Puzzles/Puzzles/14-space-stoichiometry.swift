import Foundation

class SpaceStoichiometry {

    static let ore = "ORE"
    static let fuel = "FUEL"

    struct Chemical: Hashable, CustomStringConvertible {
        let id: String
        let quantity: Int

        func times(_ factor: Int) -> Chemical {
            return Chemical(id: id, quantity: quantity * factor)
        }

        var description: String {
            return "\(quantity) \(id)"
        }
    }

    struct Reaction: Hashable {
        let input: [Chemical]
        let output: Chemical
    }

    // this could be done also with a simple topological sort
    func solvePartOne(reactions: [Reaction]) -> Int {

        var reactionsByOutput: [String: Reaction] = [:]
        for r in reactions {
            reactionsByOutput[r.output.id] = r
        }

        let fuel = reactionsByOutput[SpaceStoichiometry.fuel]!
        var materials: [String: Int] = Dictionary(grouping: fuel.input, by: { $0.id }).mapValues { $0.reduce(0, { $0 + $1.quantity}) }
        var leftovers: [String: Int] = [:]
        var ores: Int = 0

        while !materials.isEmpty {
            let wantedChemical = materials.first!
            let wantedId = wantedChemical.key
            var wantedQuantity = wantedChemical.value

            defer {
                materials.removeValue(forKey: wantedId)
            }

            if let leftover = leftovers[wantedId], leftover > 0 {
                wantedQuantity -= leftover
                wantedQuantity = max(0, wantedQuantity)
                leftovers[wantedId] = leftover - (materials[wantedId]! - wantedQuantity)
                if wantedQuantity == 0 {
                    continue
                }
            }

            guard wantedId != SpaceStoichiometry.ore else {
                ores += wantedQuantity
                continue
            }
            let neededReaction = reactionsByOutput[wantedId]!

            let neededReactionChemicals: [Chemical]
            if neededReaction.output.quantity >= wantedQuantity {
                neededReactionChemicals = neededReaction.input
                leftovers[wantedId, default: 0] += neededReaction.output.quantity - wantedQuantity
            } else {
                let (q, r) = wantedQuantity.quotientAndRemainder(dividingBy: neededReaction.output.quantity)
                let factor = q + (r > 0 ? 1 : 0)
                neededReactionChemicals = neededReaction.input.map { $0.times(factor) }
                leftovers[wantedId, default: 0] += neededReaction.output.quantity * factor - wantedQuantity
            }

            for c in neededReactionChemicals {
                materials[c.id, default: 0] += c.quantity
            }
        }

        return ores
    }

}
