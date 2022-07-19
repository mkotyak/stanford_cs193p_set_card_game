import Foundation

struct CardModel: Hashable, Identifiable {
    let id = UUID()
    let content: CardContentModel
    var state: CardState

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
