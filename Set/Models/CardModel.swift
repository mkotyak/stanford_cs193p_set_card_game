import Foundation

struct CardModel: Hashable, Identifiable {
    let id = UUID()
    let content: CardContentModel
    var isSelected = false // true when user tap on a card
    var isMatched = false // true when user found a set

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
