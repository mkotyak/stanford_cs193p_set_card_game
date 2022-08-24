import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    private enum Constants {
        static let playerTurnDuration: Int = 10
        static let timerFireInterval: TimeInterval = 0.8
        static let matchAnimationDuration: Double = 1
    }
    
    @Published private var gameModel: GameModel
    private var countdown = Constants.playerTurnDuration
    private var timer: Timer?
    @Published var timerTitle = ""
    let isColorBlindModeEnabled: Bool
    
    var cardsOnScreen: [CardModel] {
        gameModel.cardsOnTheScreen
    }
    
    var deck: [CardModel] {
        gameModel.deck
    }
    
    var playedCards: [CardModel] {
        gameModel.playedCards
    }
    
    var isMoreCardAvailable: Bool {
        return deck.isEmpty
    }
    
    var score: Int {
        gameModel.score
    }
    
    var moreCardsButtonColor: Color {
        isMoreCardAvailable ? .gray : .black
    }
    
    init(gameModel: GameModel, isColorBlindModeEnabled: Bool) {
        self.gameModel = gameModel
        self.isColorBlindModeEnabled = isColorBlindModeEnabled
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerFireInterval, repeats: true) { _ in
            self.timerTitle = "Time: \(self.countdown)"
            if self.countdown >= 1 {
                self.countdown -= 1
            } else {
                self.cleanUp()
            }
        }
    }
    
    private func cleanUp() {
        timer?.invalidate()
        timerTitle = ""
        countdown = Constants.playerTurnDuration
    }
        
    // MARK: - Inents

    func startNewGame() {
        cleanUp()
        gameModel.startNewGame()
    }
        
    func select(_ card: CardModel) -> MatchSuccessStatus {
        guard let timer = timer else {
            return .unsuccessfulMatch
        }
        
        guard timer.isValid else {
            return .unsuccessfulMatch
        }
        
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
            return .unsuccessfulMatch
        }
        
        return gameModel.makeTurn(for: chousenCard.id)
//        if matchStatus == .successfulMatch || matchStatus == .unsuccessfulMatch {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.matchAnimationDuration) { [weak self] in
//                self?.gameModel.finishTurn(for: matchStatus)
//                self?.cleanUp()
//            }
//        }
    }
    
    func didSelect(card: CardModel) -> MatchSuccessStatus {
        if timer == nil || timer?.isValid == false {
            startTimer()
        }
        return select(card)
    }
    
    func deal(card: CardModel) {
        gameModel.deal(card: card)
    }
    
    func finishTurn(matchStatus: MatchSuccessStatus) {
        gameModel.finishTurn(for: matchStatus)
        cleanUp()
    }
}
