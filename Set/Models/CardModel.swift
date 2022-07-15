import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    let content: CardContentModel
    var isActive = false // true when user tap on a card
    var isSelected = false // true when user found a set
}
