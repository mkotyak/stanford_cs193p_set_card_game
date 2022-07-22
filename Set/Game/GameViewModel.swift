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
    
    var player1: Player {
        gameModel.player1
    }
    
    var player2: Player {
        gameModel.player2
    }
    
    var whoseTurn: Player? = nil
        
    // MARK: - Inents
    
    func dealThreeMoreCards() {
        gameModel.dealThreeMoreCards()
    }
    
    func startNewGame() {
        whoseTurn = nil
        gameModel.startNewGame()
    }
        
    func select(_ card: CardModel, _ player: Player) {
        print("Select method: \(player.name)")
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
            return
        }
        
        let matchStatus = gameModel.toggleCard(by: chousenCard.id)
        if matchStatus == .successfulMatch || matchStatus == .unsuccessfulMatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.gameModel.finishTurn(for: matchStatus, player: player)
            }
            whoseTurn = nil
        }
    }
}
