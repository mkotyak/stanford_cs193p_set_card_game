import Foundation

struct SetGameModel {
    struct Card {
        var content: CardContentModel
        var isActive = false // true when user tap on a card
        // I'm not sure about naming
        var isSelected = false // true when user found a set
    }
    
    var cards: [Card]
    
    init() {
        cards = []
    }
}
