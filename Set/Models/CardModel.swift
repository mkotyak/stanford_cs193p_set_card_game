import Foundation

struct CardModel: Hashable, Identifiable {
    let id = UUID()
    let content: CardContentModel
    var state: CardState
    var isCardFaceUp: Bool = false
    var isHinted: Bool = false

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
    
    mutating func set(isHinted: Bool) {
        self.isHinted = isHinted
    }
}
