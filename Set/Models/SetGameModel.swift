import Foundation

struct SetGameModel {
    struct Card: Identifiable {
        let id = UUID()
        let content: CardContentModel
        var isActive = false // true when user tap on a card
        // I'm not sure about naming
        var isSelected = false // true when user found a set
        var isUsed = false // true when card has been displayed on the screen
    }
    
    var fullDeck: [Card]
    
    init(_ deckOfCards: [SetGameModel.Card]) {
        fullDeck = deckOfCards
    }
}
