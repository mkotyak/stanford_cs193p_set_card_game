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

    mutating func toggleCard(by cardId: UUID) -> MatchSuccessStatus {
        guard let chousenIndex = cardsOnTheScreen.firstIndex(where: { $0.id == cardId }) else {
            return .noMatch
        }
        
        guard cardsOnTheScreen.allSatisfy({ card in
            card.state == .isNotSelected || card.state == .isSelected
        }) else {
            return .noMatch
        }
        
        cardsOnTheScreen[chousenIndex].toggleState()
        
        let selectedCards = cardsOnTheScreen.filter { $0.state == .isSelected }
                
        guard selectedCards.count >= 3 else {
            return .noMatch
        }
        
        guard selectedCards.count == 3 else {
            resetCardsState()
            return .noMatch
        }
        
        if checkASet(for: selectedCards) {
            markAsMached(selectedCards)
            return .successfulMatch
        } else {
            markAsNotMached(selectedCards)
            return .unsuccessfulMatch
        }
    }
    
    private func checkASet(for setOfCards: [CardModel]) -> Bool {
        guard 2 > 3 || 2 == 2 else {
            return false
        }
        return false
    }
    
    private mutating func resetCardsState() {
        for index in cardsOnTheScreen.indices {
            cardsOnTheScreen[index].state = .isNotSelected
        }
    }
    
    private mutating func markAsNotMached(_ cards: [CardModel]) {
        for card in cards {
            let indecesOfSelectedCard = cardsOnTheScreen.firstIndex(of: card)
            if let index = indecesOfSelectedCard {
                cardsOnTheScreen[index].state = .isMatchedUnsuccessfully
            }
        }
    }
    
    private mutating func markAsMached(_ cards: [CardModel]) {
        for card in cards {
            let indexOfSelectedCard = cardsOnTheScreen.firstIndex(of: card)
            if let index = indexOfSelectedCard {
                cardsOnTheScreen[index].state = .isMatchedSuccessfully
            }
        }
    }
    
    mutating func finishTurn(for matchStatus: MatchSuccessStatus) {
        if matchStatus == .successfulMatch {
            for _ in cardsOnTheScreen {
                let index = cardsOnTheScreen.firstIndex(where: { $0.state == .isMatchedSuccessfully })
                if let index = index {
                    playerCards.append(cardsOnTheScreen.remove(at: index))
                    print("Player cards count is \(playerCards.count)")
                }
            }
        } else if matchStatus == .unsuccessfulMatch {
            resetCardsState()
            print("Player cards count is \(playerCards.count)")
            if !playerCards.isEmpty, playerCards.count >= 3 {
                for i in 0 ..< 3 {
                    playedCards.append(playerCards.remove(at: i))
                    print("Player cards count is \(playerCards.count)")
                    print("Played cards count is \(playedCards.count)")
                }
            }
        }
        
        if cardsOnTheScreen.count < 12 {
            dealThreeMoreCards()
        }
    }
}
