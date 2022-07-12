import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var gameModel: SetGameModel

    init(deckBuilder: DeckBuilder) {
        gameModel = SetGameModel(deckOfCards: deckBuilder.createDeckOfCards())
        // added print to make sure that 81 cards were created
        print(gameModel.cards.count)
    }
}
