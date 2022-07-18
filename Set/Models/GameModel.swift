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
    
    mutating func checkASet(setOfCards: [CardModel]) {
        print("checkASet func is called")
        for card in setOfCards {
            print("checked")
        }
    }
    
    
    mutating func toggle(cardId: UUID) {
        guard let chousenIndex = cardsOnTheScreen.firstIndex(where: {$0.id == cardId}) else {
            return
        }
        cardsOnTheScreen[chousenIndex].isActive.toggle()
    }
}
