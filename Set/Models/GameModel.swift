import Foundation

struct GameModel {
    var deck: [CardModel] = []
    var cardsOnTheScreen: [CardModel] = []
    var playerCards: [CardModel] = []
    var playedCards: [CardModel] = []
    var deckBuilder: DeckBuilder
    var score = 0
    
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
        
//        // test code to decrease deck >>>>>>>>>>>>>>>>>>>>>>
//        for _ in 1 ... 54 {
//            deck.removeLast()
//        }
//        // END: test code decrease deck >>>>>>>>>>>>>>>>>>>>
        
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
            mark(selectedCards, as: .isMatchedSuccessfully)
            return .successfulMatch
        } else {
            mark(selectedCards, as: .isMatchedUnsuccessfully)
            return .unsuccessfulMatch
        }
    }
    
    private func checkASet(for setOfCards: [CardModel]) -> Bool {
        let shapes = setOfCards.map(\.content.shape.rawValue)
        let colors = setOfCards.map(\.content.color.rawValue)
        let numOfShapes = setOfCards.map(\.content.numOfShapes.rawValue)
        let shadings = setOfCards.map(\.content.shading.rawValue)
        
        return isValidMatch(shapes) && isValidMatch(colors) && isValidMatch(numOfShapes) && isValidMatch(shadings)
    }
    
    private func isValidMatch(_ contentRawValues: [Int]) -> Bool {
        if Set(contentRawValues).count == 3 || Set(contentRawValues).count == 1 {
            return true
        }
        return false
    }
    
    private mutating func resetCardsState() {
        for index in cardsOnTheScreen.indices {
            cardsOnTheScreen[index].state = .isNotSelected
        }
    }
    
    private mutating func mark(_ cards: [CardModel], as state: CardState) {
        for card in cards {
            let indecesOfSelectedCard = cardsOnTheScreen.firstIndex(of: card)
            if let index = indecesOfSelectedCard {
                cardsOnTheScreen[index].state = state
            }
        }
    }

    mutating func finishTurn(for matchStatus: MatchSuccessStatus) {
        if matchStatus == .successfulMatch {
            score += 1
            for _ in cardsOnTheScreen {
                let index = cardsOnTheScreen.firstIndex(where: { $0.state == .isMatchedSuccessfully })
                if let index = index {
                    playerCards.append(cardsOnTheScreen.remove(at: index))
                    replaceMatchedCards(at: index)
                }
            }
        } else if matchStatus == .unsuccessfulMatch {
            if score != 0 {
                score -= 1
            }
            resetCardsState()
            if !playerCards.isEmpty, playerCards.count >= 3 {
                for _ in 1 ..< 3 {
                    playedCards.append(playerCards.remove(at: 0))
                }
            }
        }
    }
    
    private mutating func replaceMatchedCards(at index: Int) {
        guard !deck.isEmpty else {
            return
        }
        
        guard cardsOnTheScreen.count < 12 else {
            return
        }
        
        let removedCard = deck.removeFirst()
        cardsOnTheScreen.insert(removedCard, at: index)
    }
}
