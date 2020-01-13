import Foundation

class SpaceStoichiometry {

    static let ore = "ORE"
    static let fuel = "FUEL"

    struct Chemical: Hashable {
        let id: String
        let quantity: Int

        func times(_ factor: Int) -> Chemical {
            return Chemical(id: id, quantity: quantity * factor)
        }
    }

    struct Reaction: Hashable {
        let input: [Chemical]
        let output: Chemical
    }

    func solvePartOne(reactions: [Reaction]) -> Int {

        var reactionsByOutput: [String: Reaction] = [:]
        for r in reactions {
            reactionsByOutput[r.output.id] = r
        }

        let fuel = reactionsByOutput[SpaceStoichiometry.fuel]!
        var materials: [String: Int] = Dictionary(grouping: fuel.input, by: { $0.id }).mapValues { $0.count }
        var ores: Int = 0

        while !materials.isEmpty {
            let wantedChemical = materials.first!
            let wantedId = wantedChemical.key
            let wantedQuantity = wantedChemical.value

            defer {
                materials.removeValue(forKey: wantedId)
            }

            guard wantedId != SpaceStoichiometry.ore else {
                ores += wantedQuantity
                continue
            }
            let neededReaction = reactionsByOutput[wantedId]!

            let neededReactionChemicals: [Chemical]
            if neededReaction.output.quantity >= wantedQuantity {
                neededReactionChemicals = neededReaction.input
            } else {
                let (q, r) = wantedQuantity.quotientAndRemainder(dividingBy: neededReaction.output.quantity)
                let factor = q + (r > 0 ? 1 : 0)
                neededReactionChemicals = neededReaction.input.map { $0.times(factor) }
            }

            for c in neededReactionChemicals {
                materials[c.id, default: 0] += c.quantity
            }

        }

        return ores
    }

}
