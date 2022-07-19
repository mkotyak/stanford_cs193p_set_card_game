import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var gameModel: GameModel
    
    var cardsOnScreen: [CardModel] {
        gameModel.cardsOnTheScreen
    }
    
    var deck: [CardModel] {
        gameModel.deck
    }
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    var isMoreCardAvailable: Bool {
        return deck.isEmpty
    }
    
    var moreCardsButtonColor: Color {
        isMoreCardAvailable ? .gray : .black
    }
    
    // MARK: - Inents
    
    func dealThreeMoreCards() {
        gameModel.dealThreeMoreCards()
    }
    
    func startNewGame() {
        gameModel.startNewGame()
    }
        
    func select(_ card: CardModel) {
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
            return
        }
        gameModel.toggleCard(by: chousenCard.id)
    }
}
