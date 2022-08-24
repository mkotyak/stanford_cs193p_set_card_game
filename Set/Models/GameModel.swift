import Foundation

struct GameModel {
    private enum Constants {
        static let defaultBonus: Int = 1
        static let defaultPenalty: Int = 1
        static let extraBonus: Int = 1
        static let cardsToDealCount: Int = 3
        static let defaultCardsOnScreenCount: Int = 12
        static let cardsInSetCount: Int = 3
    }
    
    var deck: [CardModel] = []
    var cardsOnTheScreen: [CardModel] = []
    var playedCards: [CardModel] = []
    var isMoreSetsOnScreenAvailable: Bool {
        return availableSetsOnScreen.isEmpty
    }

    var score: Int
    let deckBuilder: DeckBuilder
    var startGameDate: Date
    var previousSuccesfullMatchDate: Date?
    var previousTurnDuration: TimeInterval?
    var availableSetsOnScreen: [[CardModel]] = [] {
        didSet {
            updateHints()
        }
    }
    
    private mutating func updateHints() {
        let firstSetIDs = Set(availableSetsOnScreen.first?.map(\.id) ?? [])
        for i in cardsOnTheScreen.indices {
            cardsOnTheScreen[i].set(isHinted: firstSetIDs.contains(cardsOnTheScreen[i].id))
        }
    }
    
    init(
        deckBuilder: DeckBuilder
    ) {
        self.deckBuilder = deckBuilder
        startGameDate = .now
        score = 0
        startNewGame()
    }
    
    mutating func startNewGame() {
        if !cardsOnTheScreen.isEmpty {
            resetGame()
        }
        let deck = deckBuilder.createDeck()
        
//        // test code to decrease deck >>>>>>>>>>>>>>>>>>>>>>
//        for _ in 1 ... 54 {
//            deck.removeLast()
//        }
//        // END: test code decrease deck >>>>>>>>>>>>>>>>>>>>
        self.deck = deck
    }
    
    mutating func deal(card: CardModel) {
        
        guard !deck.isEmpty else {
            debugPrint("Deck is empty")
            return
        }
                
        let index = deck.firstIndex(where: { $0.id == card.id })
        if let index = index {
            deck[index].isCardFaceUp = true
            let cardToDeal = deck.remove(at: index)
            cardsOnTheScreen.append(cardToDeal)
        }
        recalculateAvailableSetsOnScreen()
    }
    
    mutating func makeTurn(for cardId: UUID) -> MatchSuccessStatus {
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
            let bonus: Int = calculateBonus(for: currentTurnDuration)
            
            mark(selectedCards, as: .isMatchedSuccessfully)
            increaseScore(value: bonus)
            previousSuccesfullMatchDate = currentSuccesfullMatchDate
            previousTurnDuration = currentTurnDuration
            
            return .successfulMatch
        } else {
            mark(selectedCards, as: .isMatchedUnsuccessfully)
            decreaseScore(value: Constants.defaultPenalty)
            
            return .unsuccessfulMatch
        }
    }
    
    mutating func finishTurn(for matchStatus: MatchSuccessStatus) {
        if matchStatus == .successfulMatch {
            sortOutMatchedCards()
            recalculateAvailableSetsOnScreen()
            
            if deck.isEmpty, !isMoreSetsOnScreenAvailable {
                print("No more sets")
                startNewGame()
            }
            
        } else if matchStatus == .unsuccessfulMatch {
            resetCardsState()
        }
    }
    
    private mutating func sortOutMatchedCards() {
        for _ in cardsOnTheScreen {
            let index = cardsOnTheScreen.firstIndex(where: { $0.state == .isMatchedSuccessfully })
            if let index = index {
                playedCards.append(cardsOnTheScreen.remove(at: index))
                print("played cards count: \(playedCards.count)")
                replaceMatchedCards(at: index)
            }
        }
    }
    
    private func currentTurnDuration(for turnDate: Date) -> TimeInterval {
        return turnDate.timeIntervalSince(previousSuccesfullMatchDate ?? startGameDate)
    }
    
    private func calculateBonus(for timeDuration: TimeInterval) -> Int {
        var bonus = 0
        
        if let previousTurnDuration = previousTurnDuration {
            if timeDuration < previousTurnDuration {
                bonus = Constants.defaultBonus + Constants.extraBonus
            } else {
                bonus = Constants.defaultBonus
            }
        } else {
            bonus = Constants.defaultBonus
        }
        return bonus
    }

    private mutating func increaseScore(value: Int) {
        score += value
    }
    
    private mutating func decreaseScore(value: Int) {
        if score > 0 {
            score -= value
        }
    }

    private mutating func resetGame() {
        deck = []
        cardsOnTheScreen = []
        playedCards = []
        score = 0
        previousTurnDuration = nil
        previousSuccesfullMatchDate = nil
        startGameDate = .now
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
        
        var removedCard = deck.removeFirst()
        removedCard.isCardFaceUp = true
        cardsOnTheScreen.insert(removedCard, at: index)
    }
    
    private mutating func recalculateAvailableSetsOnScreen() {
        if !availableSetsOnScreen.isEmpty {
            availableSetsOnScreen = []
        }
        
        var allCardsCombinations: [[CardModel]] = []
        
        for i1 in cardsOnTheScreen.indices {
            for i2 in i1 + 1 ..< cardsOnTheScreen.count {
                for i3 in i2 + 1 ..< cardsOnTheScreen.count {
                    allCardsCombinations.append([
                        cardsOnTheScreen[i1],
                        cardsOnTheScreen[i2],
                        cardsOnTheScreen[i3]
                    ])
                }
            }
        }
        
        for combination in allCardsCombinations {
            if checkASet(for: combination) {
                availableSetsOnScreen.append(combination)
            }
        }
        print("There are \(availableSetsOnScreen.count) available sets on the screen")
    }
}
