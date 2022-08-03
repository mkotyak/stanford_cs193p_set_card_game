import Foundation

struct CardModel: Hashable, Identifiable {
    let id = UUID()
    let content: CardContentModel
    var state: CardState
    var isFaceUp: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
    
    mutating func toggleState() {
        if state == .isSelected {
            state = .isNotSelected
        } else if state == .isNotSelected {
            state = .isSelected
        }
    }
}
