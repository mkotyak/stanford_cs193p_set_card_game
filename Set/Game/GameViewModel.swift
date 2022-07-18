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
        isMoreCardAvailable ? .gray : .blue
    }
    
    // MARK: - Inents
    
    func dealThreeMoreCards() {
        gameModel.dealThreeMoreCards()
    }
    
    func startNewGame() {
        gameModel.startNewGame()
    }
    
    var potentialSet: [CardModel] = []
    
    func selectCard(for card: CardModel) {
        guard let chousenCard = cardsOnScreen.filter({$0.id == card.id}).first else {
            debugPrint("Card is out of scope")
            return
        }
        
        if potentialSet.isEmpty {
            potentialSet.append(chousenCard)
        } else if !potentialSet.isEmpty && potentialSet.count <= 3 {
            if potentialSet.contains(where: {$0.id == chousenCard.id}) {
                potentialSet.removeAll(where: {$0.id == chousenCard.id})
            } else {
                potentialSet.append(chousenCard)
            }
        }
        gameModel.toggle(cardId: chousenCard.id)
        print(potentialSet.count)
            
        if potentialSet.count == 3 {
            print("Ready for matching")
            gameModel.checkASet(setOfCards: potentialSet)
            potentialSet.removeAll()
        }
    }
}
