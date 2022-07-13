import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var gameModel: SetGameModel
    
    var fullDeck: [SetGameModel.Card] {
        gameModel.fullDeck
    }
    
    var firstSetOfCards: [SetGameModel.Card] = []
    

    init(deckBuilder: DeckBuilder) {
        gameModel = SetGameModel(deckBuilder.createDeckOfCards())
        for card in fullDeck[0..<8] {
            firstSetOfCards.append(card)
            // I know that solution on the 19th line is incorrect, but I don't have an idea how to change it
            var card = card
            card.isUsed = true
        }
    }
}
