import Foundation

struct GameModel {
    var deck: [CardModel] = []
    var cardsOnTheScreen: [CardModel] = []
    var playerCards: [CardModel] = []
    var playedCards: [CardModel] = []
    var deckBuilder: DeckBuilder
    
    init(deckBuilder: DeckBuilder) {
        self.deckBuilder = deckBuilder
        startNewGame()
    }
    
    mutating func dealThreeMoreCards() {
        guard !deck.isEmpty else {
            return
        }

        for _ in 0 ..< min(3, deck.count) {
            let removedCard = deck.removeFirst()
            cardsOnTheScreen.append(removedCard)
        }
    }
    
    mutating func startNewGame() {
        if !cardsOnTheScreen.isEmpty {
            resetGame()
        }
        var deck = deckBuilder.createDeck()
        var cardsOnTheScreen: [CardModel] = []
        for _ in 1 ... 12 {
            let removedCard = deck.removeFirst()
            cardsOnTheScreen.append(removedCard)
        }
        
        self.deck = deck
        self.cardsOnTheScreen = cardsOnTheScreen
        playerCards = []
        playedCards = []
    }
    
    private mutating func resetGame() {
        deck = []
        cardsOnTheScreen = []
        playerCards = []
        playedCards = []
    }
    
    private func checkASet(for setOfCards: [CardModel]) -> Bool {
        print("checkASet func is called")
        return true
    }

    mutating func toggleCard(by cardId: UUID) {
        guard let chousenIndex = cardsOnTheScreen.firstIndex(where: { $0.id == cardId }) else {
            return
        }
        
        cardsOnTheScreen[chousenIndex].isSelected.toggle()
        let selectedCards = cardsOnTheScreen.filter { $0.isSelected == true }
                
        guard selectedCards.count >= 3 else {
            return
        }
        
        guard selectedCards.count == 3 else {
            for _ in 0 ..< selectedCards.count {
                var cardToReset = cardsOnTheScreen.filter { $0.isSelected == true }.first
                cardToReset?.isSelected.toggle()
            }
            return
        }
        
        if checkASet(for: selectedCards) {
            submitASet(for: selectedCards)
        }
    }
    
    private mutating func submitASet(for cards: [CardModel]) {
        print("Make cards green")
        print("add delay")
        print("Move cards to appropriate arrays")
        print("And deal 3 more cards")
    }
}
