import Foundation

struct GameModel {
    private enum Constants {
        static let defaultBonus: Int = 1
        static let defaultPenalty: Int = 1
        static let cardsToDealCount: Int = 3
        static let defaultCardsOnScreenCount: Int = 12
        static let cardsInSetCount: Int = 3
    }
    
    var deck: [CardModel] = []
    var cardsOnTheScreen: [CardModel] = []
    let deckBuilder: DeckBuilder
    var firstPlayer: Player
    var secondPlayer: Player
    var startGameDate: Date
    var previousSuccesfullMatchDate: Date?
    var previousTurnDuration: TimeInterval?
    
    init(
        deckBuilder: DeckBuilder,
        firstPlayer: Player,
        secondPlayer: Player
    ) {
        self.deckBuilder = deckBuilder
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        self.startGameDate = .now
        startNewGame()
    }
    
    mutating func dealThreeMoreCards() {
        guard !deck.isEmpty else {
            return
        }
        
//        if isMoreSetAvailable() {
//            // penalize both players if there are more sets
//            if score != 0 {
//                score -= 1
//            }
//        }

        for _ in 0 ..< min(Constants.cardsToDealCount, deck.count) {
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
        for _ in 1 ... Constants.defaultCardsOnScreenCount {
            // test code to decrease deck >>>>>>>>>>>>>>>>>>>>>>
//            for _ in 1 ... 6 {
            // END: test code decrease deck >>>>>>>>>>>>>>>>>>>>
            let removedCard = deck.removeFirst()
            cardsOnTheScreen.append(removedCard)
        }
        
        self.deck = deck
        self.cardsOnTheScreen = cardsOnTheScreen
    }

    mutating func makeTurn(for cardId: UUID, player: Player) -> MatchSuccessStatus {
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
                
        guard selectedCards.count >= Constants.cardsInSetCount else {
            return .noMatch
        }
        
        guard selectedCards.count == Constants.cardsInSetCount else {
            resetCardsState()
            return .noMatch
        }
        
        if checkASet(for: selectedCards) {
            let currentSuccesfullMatchDate: Date = .now
            let currentTurnDuration: TimeInterval = currentTurnDuration(for: currentSuccesfullMatchDate)
            
            mark(selectedCards, as: .isMatchedSuccessfully)
            
            // I can move this logic to a method, but I don't know how to call it
            if player.id == firstPlayer.id {
                firstPlayer.increaseScore(by: calculateBonus(for: currentTurnDuration))
            } else if player.id == secondPlayer.id {
                secondPlayer.increaseScore(by: calculateBonus(for: currentTurnDuration))
            }
            // ------------------------------------------------------------------
            
            previousSuccesfullMatchDate = currentSuccesfullMatchDate
            previousTurnDuration = currentTurnDuration
            
            return .successfulMatch
        } else {
            mark(selectedCards, as: .isMatchedUnsuccessfully)
            
            // I can move this logic to a method, but I don't know how to call it
            if player.id == firstPlayer.id, firstPlayer.score != 0 {
                firstPlayer.decreaseScore(by: Constants.defaultPenalty)
            } else if player.id == secondPlayer.id, secondPlayer.score != 0 {
                secondPlayer.decreaseScore(by: Constants.defaultPenalty)
            }
            // ------------------------------------------------------------------
            
            return .unsuccessfulMatch
        }
    }
    
    mutating func finishTurn(for matchStatus: MatchSuccessStatus) {
        if matchStatus == .successfulMatch {
            sortOutMatchedCards()
        } else if matchStatus == .unsuccessfulMatch {
            resetCardsState()
        }
    }
    
    private mutating func sortOutMatchedCards() {
        for _ in cardsOnTheScreen {
            let index = cardsOnTheScreen.firstIndex(where: { $0.state == .isMatchedSuccessfully })
            if let index = index {
                cardsOnTheScreen.remove(at: index)
                replaceMatchedCards(at: index)
            }
        }
    }
    
    private func currentTurnDuration(for turnDate: Date) -> TimeInterval {
        return turnDate.timeIntervalSince(previousSuccesfullMatchDate ?? startGameDate)
    }
    
    private func calculateBonus(for timeDuration: TimeInterval) -> Int {
        var bonus: Int = 0
        
        if let previousTurnDuration = previousTurnDuration {
            if timeDuration < previousTurnDuration {
                bonus = Constants.defaultBonus + 1
            } else {
                bonus = Constants.defaultBonus
            }
        } else {
            bonus = Constants.defaultBonus
        }
        return bonus
    }
    
    private mutating func resetGame() {
        deck = []
        cardsOnTheScreen = []
        firstPlayer.score = 0
        secondPlayer.score = 0
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
    
    private mutating func replaceMatchedCards(at index: Int) {
        guard !deck.isEmpty else {
            return
        }
        
        guard cardsOnTheScreen.count < Constants.defaultCardsOnScreenCount else {
            return
        }
        
        let removedCard = deck.removeFirst()
        cardsOnTheScreen.insert(removedCard, at: index)
    }
    
//        private func isMoreSetAvailable() -> Bool {
//            return true
//        }
}
