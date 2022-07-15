import Foundation

struct GameModel {
    var deck: [CardModel]
    var cardsOnTheScreen: [CardModel]
    var playerCards: [CardModel]
    var playedCards: [CardModel]
    
    init(_ deck: [CardModel]) {
        var deck = deck
        var cardsOnTheScreen: [CardModel] = []
        for _ in 1...8 {
            let removedCard = deck.removeFirst()
            cardsOnTheScreen.append(removedCard)
        }
        
        self.deck = deck
        self.cardsOnTheScreen = cardsOnTheScreen
        playerCards = []
        playedCards = []
    }
    
    mutating func dealThreeMoreCards() {
        guard !deck.isEmpty else { return }
        
        if deck.count >= 3 {
            for _ in 1...3 {
                let removedCard = deck.removeFirst()
                cardsOnTheScreen.append(removedCard)
            }
        } else if deck.count < 3 {
            for _ in 1...deck.count {
                let removedCard = deck.removeFirst()
                cardsOnTheScreen.append(removedCard)
            }
        }
    }
    
//    func createNewGame() -> GameModel {
//
//    }
}
